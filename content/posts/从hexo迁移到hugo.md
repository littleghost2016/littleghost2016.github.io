---
title: "从hexo迁移到hugo"
date: 2020-05-25T20:11:36+08:00
tag: ["hexo", "hugo"]
categaries: ["技术"]
---

# 原因

## 间接原因

1. `hexo`基于`nodejs`，部署`hexo`的时候需要加载许多包。而`hugo`只需要一个二进制文件，相对来说部署更加简便。
2. `hugo`的文件分布更简洁一些，可以通过自己写的部署脚本将博客源md文件也上传至同一仓库下的另一分支（`hexo`也可以实现，但我没尝试\-\_\-||

## 直接原因

前几天在使用`scoop`升级了`nodejs`之后，`hexo d`命令报错`TypeError [ERR_INVALID_ARG_TYPE]: The "mode" argument must be integer`，无法将本地修改推到`github`，就打算迁移至`hugo`试一试。

# 过程中的踩坑

## content文件夹

hugo的博客md文件都是放在根目录的content文件夹下（hexo的是在source/\_posts文件夹下），在使用命令`hugo new`时应指定所属文件夹，例如

```bash
$ hugo new "posts/新文章.md"
```

如果不指定前面的posts文件夹，则直接创建在content文件夹下。

同时，如果直接在`content`文件夹下创建诸如`me.md`、`friendlinks.md`文件，同时在`config.toml`配置文件中指定这些文件对应的url链接，则可实现类似`hexo`中类似的`about.html`、`友链`等页面的效果。

## *disablePath*ToLower

`hugo`在使用时，url会默认将所有英文字母转为小写，这将导致这样的问题：若md文件的名称中有大写字母时，通过链接访问会自己转为小写，提示找不到页面，因此应该在`config.toml`中将下面的选项打开

```toml
disablePathToLower = true
```

## FrontMatter

例子

```toml
title: test
date: 2020-01-01T12:13:14+08:00
tags: ["hugo"]
categories: ["技术"]
```

### date

格式与`hexo`不同

### tags

类似于`Go`中的切片，应该使用中括号`[]`，hexo中使用`-`。`hugo`中若不写中括号，则在生成静态文件时会产生`at <.>: *range* can't iterate over`之类的报错。

### categories

同样类似于`Go`中的切片，应该使用中括号`[]`，hexo中使用`-`，且`hexo`中为单数：category，与tags的复数形式并不一致。若不写中括号，同样会出现tags的类似问题。

# hugo的文件结构

```bash
➜  myblog-hugo tree -L 1
.
├── README.md
├── config.toml
├── content
├── deploy_git
├── myDeploy.ps1
├── myDeploy.sh
├── public
├── resources
└── themes
```

## README.md

**文件**

我自己创建的

## config.toml

**文件**

hugo的配置文件，拷贝自所使用主题提供的例子，需要自己根据需要修改

## content

**文件夹**

存放博客源文件

## deploy_git

**文件夹**

我自己创建的，用于向github推送的临时文件夹

## myDeploy.ps1

**文件**

推送至`Github`的`PowerShell`脚本

## myDeploy.sh

**文件**

推送至`Github`的`Bash`脚本

## public

**文件夹**

存放`hugo`生成的静态文件

## resources

**文件夹**

hugo缓存

## themes

**文件夹**

存放主题

# 推送至Github

public文件夹里的内容为`Github Pages`对外显示的内容，因此推送至`master`分支。其他一些需要备份的内容，推送至`source`分支。

## PowerShell脚本

```powershell
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
```

## Bash脚本

```bash
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
cp -r ../themes ./

git add -A
git commit -m `date +%Y-%m-%dT%H:%M:%S\+08:00`
git push origin "source"
```

# 写在最后

现在还是刚开始使用`hugo`，后续如果有其他问题和发现，也会一并更新到这里。