cd "deploy_git"

git checkout master

rm -rf `ls | grep -v ".git"`
rm ".gitmodules"

cp -r ../public/* ./

git add -A
git commit -m `date +%Y-%m-%dT%H:%M:%S\+08:00`
git push origin master

git checkout "source"
rm -rf `ls | grep -v ".git"`

cp -r ../content ./
cp ../README.md ./
cp ../.gitmodules ./
cp ../config.toml ./
cp ../myDeploy.ps1 ./
cp ../myDeploy.sh ./
cp -r ../themes/meme/static ./

git add -A
git commit -m `date +%Y-%m-%dT%H:%M:%S\+08:00`
git push origin "source"