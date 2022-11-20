---
title: "生成自签ssl证书"
date: 2022-11-20T11:46:13+08:00
tags: ["ssl"]
categories: ["技术"]
---

[TOC]

> 参考自[EMQ X MQTT 服务器启用 SSL/TLS 安全连接 - 简书 (jianshu.com)](https://www.jianshu.com/p/9da0b8073b8e)
>
> 原文为[emqx-server-ssl-tls-secure-connection-configuration-guide](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.emqx.io%2Fcn%2Fblog%2Femqx-server-ssl-tls-secure-connection-configuration-guide)，目前打开已404。应该是改成了[EMQX MQTT 服务器启用 SSL/TLS 安全连接 | EMQ](https://www.emqx.com/zh/blog/emqx-server-ssl-tls-secure-connection-configuration-guide)

# 阅读本文请注意

1. 所有以`$`开头的命令均为命令行中的输入，只需要复制`$`后面的内容即可，无需输入`$`。

2. 生成证书的步骤可在任意计算机上执行，即可在服务器之外（例如个人计算机）上生成，再将证书拷贝到服务器上。

3. 最好新建一个文件夹，在这个文件夹下执行命令，例如

   ```bash
   $ mkdir ~/new_crt
   $ cd ~/new_crt
   ```

# 主要步骤

1. 生成ca私钥
2. 生成ca证书
3. 生成服务端私钥
4. 配置`openssl.cnf`
5. 生成服务端证书请求
6. 使用ca证书签发服务端证书

# 1. 生成ca私钥

```bash
$ openssl genrsa -out my_root_ca.key 2048
```

# 2. 生成ca证书

```bash
$ openssl req -x509 -new -nodes -key my_root_ca.key -sha256 -days 3650 -out my_root_ca.pem
```

```
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:
Email Address []:
```

以上所有内容均**直接回车**，**没有**输入任何内容。

# 3. 生成服务端私钥

```bash
$ openssl genrsa -out emqx.key 2048
```

# 4. 配置或者新建`openssl.cnf`

最好在当前文件夹新建一个`openssl.cnf`文件

```ini
[req]
default_bits  = 2048
distinguished_name = req_distinguished_name
req_extensions = req_ext
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
countryName = CN
stateOrProvinceName = Zhejiang
localityName = Hangzhou
organizationName = EMQX
commonName = Server certificate
[req_ext]
subjectAltName = @alt_names
[v3_req]
subjectAltName = @alt_names
[alt_names]
IP.1 = BROKER_ADDRESS
DNS.1 = BROKER_ADDRESS
```

**注意：**`[req]`部分中的`req_distinguished_name`与后面的`req_distinguished_name`的名称要对应起来，例如

```ini
[req]
distinguished_name = abc
--- 略 ---
[abc]
--- 略 ---
```

其他部分如`req_ext`、`[v3_req]`、`alt_names`同样需要一一对应。

**注意：**`alt_names`中的`IP.1 = BROKER_ADDRESS`要改成`IP.1 = x.x.x.x`，即改成服务端的ip。DNS部分可以省略。

# 5. 生成服务端证书请求

```bash
$ openssl req -new -key ./emqx.key -config openssl.cnf -out emqx.csr
```

# 6. 使用ca证书签发服务端证书

```bash
$ openssl x509 -req -in ./emqx.csr -CA my_root_ca.pem -CAkey my_root_ca.key -CAcreateserial -out emqx.pem -days 3650 -sha256 -extensions v3_req -extfile openssl.cnf
```

# 服务端使用的是服务端证书和服务端私钥

需要在服务端上传两个文件

|  文件名  |    说明    |
| :------: | :--------: |
| emqx.pem | 服务端证书 |
| emqx.key | 服务端私钥 |

**注意：**服务端私钥一定要保护好不能泄露！

# 客户端使用的是ca证书

|     文件名     |  说明  |
| :------------: | :----: |
| my_root_ca.pem | ca证书 |
