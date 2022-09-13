DIR="$( cd "$( dirname "$0" )" && pwd )"
projectLocation="${DIR%/*}"
echo $projectLocation
FILE="/Users/akshayas/Documents/bingo/build/app/outputs/flutter-apk/app-release.apk"


curl --location --request POST 'https://www.googleapis.com/upload/drive/v3/files' \
--header 'Content-Type: application/vnd.android.package-archive; charset=UTF-8' \
--header 'Authorization: Bearer ya29.a0AVA9y1u8rB32FsDndyvx_7ASOUxFki9wDub68g0Q7264rQ7Y7J7clf514n8kGr8fXUGi09gM8X0uqBIXtKIbKvjbNnlT5Rnz1KC9hndNMZ2PdMKfEXWKt-kH3YbGhFnrHh6-UP1CSk7hZrDaI1xcm4wUQFxoaCgYKATASARASFQE65dr8pl0lbQi2KqWCQV3R-LcE8g0163' \
--form 'app.apk=@'$FILE'' \
--form 'name="app-qa"'