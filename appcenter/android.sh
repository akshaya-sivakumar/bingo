#!/bin/bash

RELEASE_NOTES=''
DISTRIBUTION_GROUP="17bd7807-b723-467b-95ae-5b09e94711f9" # QA Team Destination
NOTIFY=$1
AUTH="X-API-Token: 28e29843de522a545f39937b4a64f64753393889"


# Release Android Apk
file_name='app-release.apk'
CONTENT_TYPE='application/vnd.android.package-archive'
APPCENTER_OUTPUT_DIRECTORY="."
UPLOAD_DOMAIN="https://file.appcenter.ms/upload"
API_URL="https://api.appcenter.ms/v0.1/apps/akash111999-gmail.com/BINGO"
ACCEPT_JSON="Accept: application/json"
APP_PACKAGE=$3
# Body - Step 1/7
request_url="$API_URL/uploads/releases"
echo $request_url
echo $ACCEPT_JSON
echo $AUTH
upload_json=$(curl -s -X POST -H "Content-Type: application/json" -H "$ACCEPT_JSON" -H "$AUTH" "$request_url")
echo $upload_json
releases_id=$(echo $upload_json | jq -r '.id')
package_asset_id=$(echo $upload_json | jq -r '.package_asset_id')
url_encoded_token=$(echo $upload_json | jq -r '.url_encoded_token')
RELEASE_FILE_LOCATION="$2/$file_name"
file_size=$(wc -c $RELEASE_FILE_LOCATION | awk '{print $1}')

# Step 2/7
metadata_url="$UPLOAD_DOMAIN/set_metadata/$package_asset_id?file_name=$file_name&file_size=$file_size&token=$url_encoded_token&content_type=$CONTENT_TYPE"

meta_response=$(curl -s -d POST -H "Content-Type: application/json" -H "$ACCEPT_JSON" -H "$AUTH" "$metadata_url")
chunk_size=$(echo $meta_response | jq -r '.chunk_size')
echo $request_url
echo $RELEASE_FILE_LOCATION


split_dir=$APPCENTER_OUTPUT_DIRECTORY/split-dir
mkdir -p $split_dir
eval split -b $chunk_size $RELEASE_FILE_LOCATION $split_dir/split


# Step 3/7
binary_upload_url="$UPLOAD_DOMAIN/upload_chunk/$package_asset_id?token=$url_encoded_token"

block_number=1
for i in $split_dir/*
do
    url="$binary_upload_url&block_number=$block_number"
    size=$(wc -c $i | awk '{print $1}')
    curl -X POST $url --data-binary "@$i" -H "Content-Length: $size" -H "Content-Type: $CONTENT_TYPE"
    block_number=$(($block_number + 1))
done

# Step 4/7
finish_url="$UPLOAD_DOMAIN/finished/$package_asset_id?token=$url_encoded_token"
curl -d POST -H "Content-Type: application/json" -H "$ACCEPT_JSON" -H "$AUTH" "$finish_url"

# Step 5/7
commit_url="$API_URL/uploads/releases/$releases_id"
curl -H "Content-Type: application/json" -H "$ACCEPT_JSON" -H "$AUTH" \
  --data '{"upload_status": "uploadFinished","id": "$releases_id"}' \
  -X PATCH \
  $commit_url

# Step 6/7
release_id=null
counter=0
max_poll_attempts=15

while [[ $release_id == null && ($counter -lt $max_poll_attempts)]]
do
    poll_result=$(curl -s -H "Content-Type: application/json" -H "$ACCEPT_JSON" -H "$AUTH" $commit_url)
    release_id=$(echo $poll_result | jq -r '.release_distinct_id')
    counter=$((counter + 1))
    sleep 3
done

if [[ $release_id == null ]];
then
    echo "Failed to find release android $flavor from appcenter"
    exit 1
fi

# Step 7/7
distribute_url="$API_URL/releases/$release_id"
curl -H "Content-Type: application/json" -H "$ACCEPT_JSON" -H "$AUTH" \
  --data '{"destinations": [{ "id": "'"$DISTRIBUTION_GROUP"'"}], "notify_testers": '"$NOTIFY"', "release_notes": "'"$RELEASE_NOTES"'" }' \
  -X PATCH \
  $distribute_url
echo " $flavor Android released to  appcenter"
