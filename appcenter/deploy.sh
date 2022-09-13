
DIR="$( cd "$( dirname "$0" )" && pwd )"
buildSaveLocation=$HOME/Desktop
projectLocation="${DIR%/*}"
filename='appcenter/releaseNotes.txt'
releaseNotes="";
Error='\033[0;31m'
Success='\033[0;32m'
NC='\033[0m' # No Color
n=1
while read line; do
# reading each line
releaseNotes=$releaseNotes"\n"$line
n=$((n+1))
done < $filename

echo  "${Success}projectLocation $projectLocation/\n${NC}" 
echo  "${Success}buildSaveLocation $buildSaveLocation/bingo\n${NC}" 
echo  "$ReleaseNote\n" 

rm -rf $buildSaveLocation/bingo
rm -rf $projectLocation/build/app/outputs/flutter-apk/'app-release.apk'

mkdir -p $buildSaveLocation/bingo

echo Release Android 
echo " Android BINGO Apk Building"
flutter build apk --release
cp $projectLocation/build/app/outputs/flutter-apk/'app-release.apk' $buildSaveLocation/bingo/
echo $buildSaveLocation/bingo
sh appcenter/android.sh true $buildSaveLocation/bingo
