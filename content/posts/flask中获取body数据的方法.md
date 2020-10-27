---
title: "Flask中获取body数据的方法"
date: 2020-10-19T11:30:46+08:00
tags: ["flask"]
categories: ["技术"]
---

在Flask中，使用`POST`、`PATCH`等方法进行数据的接收时，有以下几种接受方法。

发送为`application/json`：

```py
data = request.json
```

发送为`application/x-www-form-urlencoded`（表单数据）

```py
data = request.form
```

无`Content-Type`标题的原始发送：

```py
data = request.data
```

---

内容转载自

作者：[黑洞官方问答小能手](https://www.pythonheidong.com/blog/黑洞官方问答小能手)

链接： https://www.pythonheidong.com/blog/article/365488/

来源： [python黑洞网](https://www.pythonheidong.com/)