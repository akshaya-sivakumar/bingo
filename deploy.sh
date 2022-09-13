DIR="$( cd "$( dirname "$0" )" && pwd )"
projectLocation="${DIR%/*}"
echo $projectLocation
FILE="/Users/akshayas/Documents/bingo/build/app/outputs/flutter-apk/app-release.apk"


curl -X PUT --http1.1 -F 'app=@'$FILE'' https://getupdraft.com/api/app_upload/9be40f651a59485a97d2afe65fcc58df/4b38ac26a04d4dae8733ffd86071d2be/
