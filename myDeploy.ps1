hugo

cd deploy_git

# update to master branch
git checkout master

$files = Get-ChildItem -Path .\ -Exclude .git
if ($files.count -gt 0) {
    foreach($file in $files)
    {
        Remove-Item $file.FullName -Recurse -Force
    }
}

Copy-Item -Path ..\public\* -Recurse -Destination .\

# Tuesday 06/25/2019 16:17 -07:00
# "dddd MM/dd/yyyy HH:mm K"
$currentTime = Get-Date -Format "yyyy-MM-ddTHH:mm:00+08:00"
git add -A
git commit -m $currentTime
git push origin master

# update to source branch
git checkout source

$files = Get-ChildItem -Path .\ -Exclude .git
if ($files.count -gt 0) {
    foreach($file in $files)
    {
        Remove-Item $file.FullName -Recurse -Force
    }
}

Copy-Item -Path ..\content -Recurse -Destination .\
Copy-Item -Path ..\README.md -Recurse -Destination .\
Copy-Item -Path ..\.gitmodules -Recurse -Destination .\
Copy-Item -Path ..\config.toml -Recurse -Destination .\
Copy-Item -Path ..\myDeploy.ps1 -Recurse -Destination .\
Copy-Item -Path ..\myDeploy.sh -Recurse -Destination .\

git add -A
git commit -m $currentTime
git push origin source

cd ..