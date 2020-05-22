---
title: zsh报错command not found compdef
date: 2019-07-10T21:38:55+08:00
tags: ["zsh"]
---
安装zsh后报错，解决方案：

```bash
$ compaudit | xargs -I '%' chmod g-w,o-w '%'
$ rm ~/.zcompdump*
$ exec zsh
```

