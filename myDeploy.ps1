hugo

cd deploy_git

# update to master branch
git checkout master

# delete all files except .git
$files = Get-ChildItem -Path .\ -Exclude .git
if ($files.count -gt 0) {
    foreach($file in $files)
    {
        Remove-Item $file.FullName -Recurse -Force
    }
}

# copy pages files
Copy-Item -Path ..\public\* -Recurse -Destination .\

# Tuesday 06/25/2019 16:17 -07:00
# "dddd MM/dd/yyyy HH:mm K"
$currentTime = Get-Date -Format "yyyy-MM-ddTHH:mm:ss+08:00"
git add -A
git commit -m $currentTime
git push origin master

# update to source branch
git checkout source

# delete all files except .git
$files = Get-ChildItem -Path .\ -Exclude .git
if ($files.count -gt 0) {
    foreach($file in $files)
    {
        Remove-Item $file.FullName -Recurse -Force
    }
}

# copy some files
Copy-Item -Path ..\content -Recurse -Destination .\
Copy-Item -Path ..\README.md -Recurse -Destination .\
Copy-Item -Path ..\.gitmodules -Recurse -Destination .\
Copy-Item -Path ..\config.toml -Recurse -Destination .\
Copy-Item -Path ..\myDeploy.ps1 -Recurse -Destination .\
Copy-Item -Path ..\myDeploy.sh -Recurse -Destination .\
Copy-Item -Path ..\themes -Recurse -Destination .\

git add -A
git commit -m $currentTime
git push origin source

# return to the previous path
cd ..