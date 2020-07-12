---
title: "通过API自动更新Aliyun的DNS解析 Go语言版本"
date: 2020-06-29T20:23:49+08:00
tags: ["dns", "go", "爬虫"]
categories: ["技术"]
---

原来一直使用cloudflare做域名解析，还写过[通过API自动更新Cloudflare的DNS解析-Go语言版本]([https://blog.littleghost.ml/posts/%E9%80%9A%E8%BF%87API%E8%87%AA%E5%8A%A8%E6%9B%B4%E6%96%B0Cloudflare%E7%9A%84DNS%E8%A7%A3%E6%9E%90-Go%E8%AF%AD%E8%A8%80%E7%89%88%E6%9C%AC/](https://blog.littleghost.ml/posts/通过API自动更新Cloudflare的DNS解析-Go语言版本/))，但从哪一天开始域名无法正确更新，根据回显提示：

> Check the log file and find the error message: “error”: "You cannot use this API for domains (top-level domains) with .cf, .ga, .gq, .ml or .tk TLDs. DNS settings for this domain, please Use the Cloudflare dashboard.

上网查询看到说cloudflare突然不对这些域名提供DNS更新的API，于是更换DNS解析到阿里云。

阿里云直接提供可供使用的[库](https://github.com/aliyun/alibaba-cloud-sdk-go/tree/master/services/alidns)。

# 申请ACCESS_KEY_ID和SECRET

[关于AccessKey的获取](https://usercenter.console.aliyun.com/?spm=a2c4g.11186623.2.17.3f0230b1ucXJ9Z#/manage/ak)。

![image-20200629112101989](image-20200629112101989.png)

# 代码

```go
package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net"
	"net/http"
	"net/http/cookiejar"
	"regexp"
	"strings"

	"github.com/aliyun/alibaba-cloud-sdk-go/services/alidns"
	"github.com/tidwall/gjson"
)

const (
	REGION_ID         = "cn-hangzhou"
	ACCESS_KEY_ID     = "自行更改"
	ACCESS_KEY_SECRET = "自行更改"
)

func getRecordIdAndIp(subDomainName string) (recordId string, ip string, err error) {

	client, err := alidns.NewClientWithAccessKey(REGION_ID, ACCESS_KEY_ID, ACCESS_KEY_SECRET)
	request := alidns.CreateDescribeSubDomainRecordsRequest()
	request.SubDomain = subDomainName

	response, err := client.DescribeSubDomainRecords(request)
	if err != nil {
		fmt.Print(err.Error())
	}
	// response是个切片,索引0对应一个结构体，[{10.173.9.101 600  littleghost.ml lab 0 19722069506535424 ENABLE false 1 default A}]
	recordId = response.DomainRecords.Record[0].RecordId
	ip = response.DomainRecords.Record[0].Value
	err = nil
	return
}

func checkIp(ip string, ipType string) (nativeIp string, updateFlag bool) {
	if ipType == "ipv4" {
		nativeIpv4, err := getNativeIp("ipv4")
		if err != nil {
			fmt.Println(err)
			updateFlag = false
		}
		if ip != nativeIpv4 {
			nativeIp = nativeIpv4
			updateFlag = true
		}
	} else if ipType == "ipv6" {
		nativeIpv6, err := getNativeIp("ipv6")
		if err != nil {
			fmt.Println(err)
			updateFlag = false
		}

		if ip != nativeIpv6 {
			nativeIp = nativeIpv6
			updateFlag = true
		}
	}
	return
}

// 获取本机的IPv4和IPv6地址
func getNativeIp(ipType string) (ip string, err error) {
	if ipType == "ipv4" {

		jar, _ := cookiejar.New(nil)
		httpClient := &http.Client{
			Jar: jar,
		}
		loginUrl := "http://192.168.1.1/"
		req, _ := http.NewRequest("POST", loginUrl, strings.NewReader(`{"method":"do","login":{"password":"自行更改"}}`))
		res, httpError := httpClient.Do(req)
		if httpError != nil {
			log.Print(httpError)
			err = httpError
		}

		defer res.Body.Close()

		body, _ := ioutil.ReadAll(res.Body)
		stok := gjson.Get(string(body), "stok").String()

		contentUrl := fmt.Sprintf("http://192.168.1.1/stok=%s/ds", stok)
		req, _ = http.NewRequest("POST", contentUrl, strings.NewReader(`{"network":{"name":["wan_status"]},"method":"get"}`))
		res, httpError = httpClient.Do(req)
		if httpError != nil {
			log.Print(httpError)
			err = httpError
		}

		defer res.Body.Close()

		body, _ = ioutil.ReadAll(res.Body)
		ip = gjson.Get(string(body), "network").Get("wan_status").Get("ipaddr").String()

		return ip, nil
	} else if ipType == "ipv6" {
		addrs, err := net.InterfaceAddrs()
		if err != nil {
			fmt.Println(err)
			return "", err
		}
		for _, address := range addrs {
			ipnet, ok := address.(*net.IPNet)
			if ok && !ipnet.IP.IsLoopback() {
				ip = ipnet.IP.String()
				matchFlag, err := regexp.MatchString("2001", ip)
				if err != nil {
					fmt.Println(err)
					return "", err
				}
				if ip != "" && matchFlag {
					break
				}
			}
		}
	}
	return ip, nil
}

func updateAliyunDns(recordId string, ip string, subDomain string, dnsType string) {
	client, err := alidns.NewClientWithAccessKey("cn-hangzhou", ACCESS_KEY_ID, ACCESS_KEY_SECRET)
	if err != nil {
		fmt.Println(err)
	}

	request := alidns.CreateUpdateDomainRecordRequest()
	request.Scheme = "https"
	request.Value = ip
	request.Type = dnsType
	request.RR = subDomain
	request.RecordId = recordId

	_, err = client.UpdateDomainRecord(request)
	// fmt.Println(response)
}

// 程序入口
func main() {

	recordId, ip, err := getRecordIdAndIp("lab6.littleghost.ml")
	if err != nil {
		fmt.Println("getRecordIdAndIp has error")
	}

	nativeIp, updateFlag := checkIp(ip, "ipv6")
	if updateFlag {
		updateAliyunDns(recordId, nativeIp, "lab6", "AAAA")
		fmt.Println("更新了新ip", nativeIp)
	}

	recordId, ip, err = getRecordIdAndIp("lab.littleghost.ml")
	if err != nil {
		fmt.Println("getRecordIdAndIp has error")
	}

	nativeIp, updateFlag = checkIp(ip, "ipv4")
	if updateFlag {
		updateAliyunDns(recordId, nativeIp, "lab", "A")
		fmt.Println("更新了新ip", nativeIp)
	}
}
```

域名更新恢复正常。