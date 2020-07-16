---
title: "通过两道题学习go的fmt"
date: 2020-07-16T21:35:00+08:00
tags: ["go"]
categories: ["技术"]
---

今天实验室师兄晚上有华为笔试，凑着看了两道用于笔试前练习的题。主要用于练习标准输入，从命令行读入响应数据。

# 题目一

链接：https://ac.nowcoder.com/acm/contest/5646/E
来源：牛客网

## 题目描述

计算一系列数的和 

## 输入描述

输入的第一行包括一个正整数t(1 <= t <= 100), 表示数据组数。
接下来t行, 每行一组数据。
每行的第一个整数为整数的个数n(1 <= n <= 100)。
接下来n个正整数, 即需要求和的每个正整数。

## 输出描述

每组数据输出求和的结果

## 示例1

### 输入

```
2
4 1 2 3 4
5 1 2 3 4 5
```

### 输出

```
10
15
```

## 代码

```go
package main

import (
	"fmt"
	"io"
)

func main() {
	var totalNumber int
	fmt.Scanln(&totalNumber)
	// fmt.Println("totalNumber", totalNumber)
	for i := 0; i < totalNumber; i++ {
		// fmt.Println("进入第一层循环")
		var eachNumber int
		var eachResult int
		var tempEachInput int
		fmt.Scan(&eachNumber)
		// fmt.Println("eachNumber", eachNumber)

		for j := 0; j < eachNumber; j++ {
			fmt.Scan(&tempEachInput)
			eachResult += tempEachInput
		}
		fmt.Println(eachResult)
	}
}
```

# 题目二

链接：https://ac.nowcoder.com/acm/contest/5646/F
来源：牛客网

## 题目描述

计算一系列数的和 

## 输入描述

输入数据有多组, 每行表示一组输入数据。
每行的第一个整数为整数的个数n(1 <= n <= 100)。
接下来n个正整数, 即需要求和的每个正整数。

## 输出描述:

每组数据输出求和的结果

## 示例1

### 输入

```
4 1 2 3 4
5 1 2 3 4 5
```

### 输出

```
10
15
```

## 代码

```go
package main

import (
	"fmt"
	"io"
)

func main() {

	for {
		var eachNumber int
		var eachResult int
		var tempEachInput int

		n, err := fmt.Scan(&eachNumber)
		// fmt.Println("eachNumber", eachNumber)

		fmt.Println(n, err)
		if n == 0 || err == io.EOF {
			break
		}
		for j := 0; j < eachNumber; j++ {
			fmt.Scan(&tempEachInput)
			eachResult += tempEachInput
		}
		fmt.Println(eachResult)

	}
}
```

