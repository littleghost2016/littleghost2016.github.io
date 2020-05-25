---
title: C语言上机作业
date: 2016-01-03T22:45:25+08:00
tags: ["c"]
categories: ["技术"]
---

# C语言上机作业

整理一下大一上时的练习，当时用的还是`ThinkPad L410`+`XP`+`VC++6.0`，那时的自己还能一边食堂吃午饭一边手机看汇编学习的视频，有点怀念QAQ

# printf的使用

```c++
// It's the first class in college
#include<stdio.h>

void main()
{
  printf("Hello World.\n");
}

// 第一次stdio.h打错了
// 知道还有”math.h””string.h”
// #include 表示引用头文件
// 如”stdio.h”中包括标准的输入输出函数
```

# printf的使用2

```c++
#include<stdio.h>
void main()
{
  int number;
  float amount;
  number=100;
  amount=30.75+70.35;
  printf("%d\n",number);
  printf("%5.2f",amount);
}
```

# 理解i++和++i

```c++
#include<stdio.h>

void main()
{
  int x,y;
  x=10;
  y=++x;
printf("x=%d,y=%d\n",x,y);
}

//（++i先自加后运算）
```

# 学习scanf和math.h

```c++
#include<stdio.h>
#include<math.h>

main()
{
  scanf("%d",a);
  char a;
  int b=2,c=3,d=0;
  d=a*b*c;
  printf("%d\n",d);
}

// （scanf在调试时容易忘记输入...）
// （a乘b乘c要使用”*”符号，不能像数学计算中一样省略，此处不能省略）
```

# 学习单个字符输出函数putchar（2015.9.24）

```c++
//3.4 数据输出
#include<stdio.h>

main()
{
	char a,b;
	a='b';b='o';
	putchar(a);putchar(b);
	putchar('y');putchar('\n');
}

// （括号内可以是字符常量，也可以是整型变量，此时仅输出低字节所代表的字符）
```

# 作业（2015.10.10）

## 分开一个两位数的十位和个位

```c++
#include<stdio.h>

void main()
{
	int a,b,c;
	puts("输入一个两位数");
  scanf("%d",&a);
	b=a/10;
	c=a-b*10;
	printf("该数字的十位是%d,个位是%d\n",b,c);
}
```

![img](clip_image002.jpg)

## printf的进阶使用

```c++
#include<stdio.h>

main()
{	unsigned double a;
	scanf("%d",&a);
	printf("%d\n",10*a);
}
```

![img](clip_image001.png)

```c++
// <把“double”前的“unsigned”去掉（有符号变无符号）>
#include<stdio.h>

main()
{	double a;
	scanf("%d",&a);
	printf("%d\n",10*a);
}
```

![](20151010.png)

# if（和else）条件的使用（2015.10.15）

## 一

```c++
#include<stdio.h>

void main()
{
	int x,y;
	scanf("%d",&x);
	if(x<-5)
		y=x;
	  else if(x>=-5&&x<1)
	    y=2*x+5;
	  else if(x>=1&&x<4)
	    y=x+6;
	else y=3*x-2;
	printf("%d\n",y);

}
```

![](1.png)

![](2.png)

## 二、根据学生成绩分等级

```c++
#include<stdio.h>

void main()
{
	int a,b;
	scanf("%d",&a);
	if(a<0||a>100) b=1;
	if(a>=0&&a<60) b=2;
	if(a>=60&&a<70) b=3;
	if(a>=70&&a<80) b=4;
	if(a>=80&&a<90) b=5;
	if(a==100) b=6;
	switch(b)
	{   
	    case 1:puts("您输入了错误的成绩...");break;
	    case 2:puts("学生等级为'E',对不起，您不及格...");break;
		case 3:puts("学生等级为'D'");break;
		case 4:puts("学生等级为'C'");break;
		case 5:puts("学生等级为'B'");break;
		case 6:puts("学生等级为'A',您得了满分，学霸呀~");break;
        default: puts("学生等级为'A'"); 
	}
}
```

![](3.png)

![](4.png)

![](5.png)

![](6.png)

## 三个程序的比较

分别根据不同的x来给y赋值（本质相同，判断条件不同）

```c++
#include<stdio.h>

void main()
{
	int x,y=1;
	scanf("%d",&x);
	if(x<=0)
    {
		if(x<0)
			y=-1;
		else y=0;
	}
	printf("%d\n",y);
}
```

```c++
#include<stdio.h>

void main()
{
	int x,y=0;
	scanf("%d",&x);
	if(x<0||x>0)
    {
		if(x<0)
			y=-1;
		else y=1;
	}
	printf("%d\n",y);
}
```

```c++
#include<stdio.h>

void main()
{
	int x,y=-1;
	scanf("%d",&x);
	if(x>=0)
    {
		if(x>0)
			y=1;
		else y=0;
	}
	printf("%d\n",y);
}
```

# 作业【2015.10.17】

## 解一元二次方程

```c++
#include<stdio.h>
#include<math.h>

void main()
{
	int a,b,c,d,e,f,x1,x2;
	puts("请对应输入方程的a,b,c");
    scanf("%d %d %d",&a,&b,&c);
    d=b*b-4*a*c;	
 	if(d<0)
	{
		f=sqrt(-d);
	    printf("x1=%d+%di\n",(-b)/(2*a),f/(2*a));
        printf("x2=%d-%di\n",(-b)/(2*a),f/(2*a));
	}
	if(0==d)
	{	
		f=sqrt(-d);
		e=(-b)/(2*a);
	    printf("此方程有两个相等的根，为x=%d\n",e);
	}
    if(d>0)
	{   
		f=sqrt(d);
		x1=(-b+f)/(2*a);
        x2=(-b-f)/(2*a);
		printf("x1=%d,x2=%d\n",x1,x2);
	}
}
```

![](7.png)

![img](clip_image001-1586097707043.png)

![img](clip_image002.png)

![img](clip_image003.png)

 

![img](clip_image004.png)

## switch菜单+n的阶乘

```c++
#include<stdio.h>
#include<math.h>

void main()
{
	int a,b=1,c=1,n;
	puts("请选择您想要执行的方式\n");
	puts("1.for语句\n2.while语句\n3.do while语句\n4.go for+if语句\n");
	scanf("%d",&a);
	switch(a)
	{
	    case 1:puts("您选择的是for语句，请输入n");scanf("%d",&n);for(;b<=n;c=b*c,b=b++);break;
		case 2:puts("您选择的是while语句，请输入n");scanf("%d",&n);
			while(b<=n)
			   {
				   c=b*c;
				   b=b++;
			   }
			  ;break;
		case 3:puts("您选择的是do while语句，请输入n");scanf("%d",&n);
			   do
			   {
				   c=b*c;
				   b=b++;
			   }
			   while(b<=n);break;
		case 4:puts("您选择的是goto+if语句，请输入n");scanf("%d",&n);
             loop:if(b<=n)
			   {
				   c=b*c;
				   b=b++;
				   goto loop;break;
			   }
	}
	    printf("%d\n",c);
}
```

![img](clip_image001-1586097856539.png)

![img](clip_image002-1586097856539.png)

![img](clip_image004.jpg)

## N的阶加

```c++
//2015.10.17
#include<stdio.h>

void main()
{
	int a,b,n;
	puts("请输入n\n");
	scanf("%d",&n);
	for(a=0,b=1;b<=n;a=a+b,b=b++);
	printf("%d\n",a);
}
```

![](8.png)

![img](clip_image001-1586097954033.png)

![IMG_2039](clip_image002-1586097965141.jpg)

## N的阶乘

```c++
#include <stdio.h>

int aaa(int a)
{
	int b=1;
	if(a==1)
		b=1;
	else b=a*aaa(a-1);
	return b;
}

void main()
{
	int a,b;
	scanf("%d",&a);
	aaa(a);
	printf("%d\n",aaa(a));
}
```

## 显示1-10的平方数

```c++
#include<stdio.h>

void main()
{
	int a,n;
	puts("请输入一个n");
	scanf("%d",&n);
	a=n*n;
	printf("该数的平方数为%d\n",a);
}
```

![](9.png)

![](10.png)

# 作业【2015.10.25】

## 十进制转十六进制

```c++
#include<stdio.h>

void main()
{
	int a,b,c[100],d=0,e;
	scanf("%d",&a);
	for(;a>=1;d=d++)
	{
		(a%16)<10?c[d]=a%16:c[d]=(a%16)+55;a=a/16;
	}
	for(e=d-1;e>=0;e--)
	{
		(c[e]<10)?printf("%d",c[e]):printf("%c",c[e]);
	}
}
```

![](11.png)

![](12.png)

## 扑克牌洗牌

```c++
#include<stdio.h>
#include<stdlib.h>
#include<time.h>

void main()
{
	int a=0,card[52],b,c;
	puts(" 甲 乙 丙 丁");
	while(a<=52)
	{
		card[a]=a+1;
		a=a++;
	}
	srand(time(0));
	for(a=0;a<52;a=a++)
	{
		b=rand()%(52-a)+a;
		c=card[a];
		card[a]=card[b];
		card[b]=c;
		printf("%3d",card[a]);
		if(a!=0)
			if(a%4==0)
				printf("\n");
			else 1==1;
		else a=a++;
	}
	printf("%3d\n",card[a]);
}
```

![](13.png)![](14.png)![](15.png)![](16.png)

# 函数【2015.11.5】

## strcmp字符串比较函数

```c++
#include<stdio.h>
#include<string.h>

void main()
{
	char a[20],b[20];
	gets(a);
	gets(b);
	strcmp(a,b);
	printf("%d\n",strcmp(a,b));
}
```

## strcpy字符串拷贝函数

```c++
#include<stdio.h>
#include<string.h>

void main()
{
	char a[20],b[20];
	gets(a);
	strcpy(b,a);
	printf("%s\n",b);
}
```

## strcat字符串连接函数

```c++
#include<stdio.h>
#include<string.h>

void main()
{
	char a[40],b[20];
	gets(a);
	gets(b);
	strcat(a,b);
	printf("%s\n",a);
}
```

![](17.png)

## strlen字符串长度测试函数

```c++
#include<stdio.h>
#include<string.h>

void main()
{
	char a[20];
	gets(a);
	printf("%d\n",strlen(a));
}
```

![img](clip_image001-1586098644743.png)

```
H  e  l  l  o  *  w  o  r  l  d  !     （*表示空格）
1  2  3  4  5  6  7  8  9  A  B  C
```

## strlwr字符串转换函数（大转小）

```c++
#include<stdio.h>
#include<string.h>

void main()
{
	char a[20];
	gets(a);
	strlwr(a);
	printf("%s\n",strlwr(a));
}
```

![](18.png)

## strupr字符串转换函数（小转大）

```c++
#include<stdio.h>
#include<string.h>

void main()
{
	char a[20];
	gets(a);
	printf("%s\n",strupr(a));//(比六的代码更精简)
}
```

![img](clip_image001-1586098733205.png)

# 大小写字符转换【2015.11.12】

## V1.0

```c++
#include<stdio.h>
void L2UandU2L(char str[]);

main()
{
	char a[]="1aS2dF3zX4cV";
	puts(a);
	L2UandU2L(a);
	puts(a);
}

void L2UandU2L(char str[])
{
	int i=0;
	while(str[i])
	{
		if(str[i]>='a'&&str[i]<='z')
			str[i]=str[i]-'a'+'A';
		else if(str[i]>='A'&&str[i]<='Z')
			str[i]=str[i]-'A'+'a';
		i++;
	}
}
```

![img](clip_image001-1586098779362.png)

## V2.0

![img](clip_image001-1586098798532.png)

# 作业【2015.11.16】

## Dir

显示目录文件和子目录列表。如果在没有参数的情况下使用，则 dir 显示磁盘的卷标和序列号，后接磁盘上目录和文件的列表，包括它们的名称和最近修改的日期及时间。dir 可以显示文件的扩展名以及文件的字节大小。Dir 也显示列出的文件及目录的总数、累计大小和磁盘上保留的可用空间（以字节为单位）。

 ![img](clip_image001-1586098983555.png)

## Path

![img](clip_image002-1586098983555.png)

可用”path 路径;%path%”添加路径

## #include中的<>和””的区别 

<>先去系统目录中找头文件，如果没有在到当前目录下找。所以像标准的头文件 stdio.h、stdlib.h等用这个方法。 
 而""首先在当前目录下寻找，如果找不到，再到系统目录中寻找。 这个用于include自定义的头文件，让系统优先使用当前目录中定义的。

## Stdio.h

![img](clip_image003-1586098983555.png)

# 交换两个变量的值【2015.11.22】

## 指针-引用temp

```c++
#include<stdio.h>

void swap(int *x,int *y)
{
	int temp;
	temp=*x;
	*x=*y;
	*y=temp;
}

void main(int x,int y)
{
	scanf("%d %d",&x,&y);	
	swap(&x,&y);
	printf("%d %d\n",x,y);
}
```

## 异或

```c++
#include<stdio.h>

void swap(int *x,int *y)
{
	*x^=*y;
	*y^=*x;
	*x^=*y;
}

void main(int x,int y)
{
	scanf("%d %d",&x,&y);	
	swap(&x,&y);
	printf("%d %d\n",x,y);
}
```

![](19.png)

![img](clip_image001-1586099144595.png)

## 引用传递

```c++
#include<stdio.h>

void swap(int &x,int &y)
{
	int temp;
	temp=x;
	x=y;
	y=temp;
}

void main(int x,int y)
{
	scanf("%d %d",&x,&y);	
	swap(x,y);
	printf("%d %d\n",x,y);
}
```

![img](clip_image001-1586099175197.png)

# 多种方法输出及查看内存和值【2015.11.26】

## 多种方法输出hellp world

```c++
#include<stdio.h>
#include<string.h>

main()
{
	int i;
	char a[]="hello world",*b;
	b=a;
	printf("hello world\n");  //printf函数
	puts("hello world");      //puts函数
	printf("%s\n",a);         //数组整体输出
	for(i=0;i<strlen(a);i++)
		printf("%c",a[i]);      //数组单个元素循环输出
	printf("\n");
	printf("%s\n",b);         //运用指针的数组输出
	for(;*b;b++)
		printf("%c",*b);        //按照地址单个输出
	printf("\n");
}
```

![img](clip_image001-1586099226782.png)

## 查看内存和值

![img](clip_image002-1586099238066.jpg)

# dos常用命令

## DIR

含义：显示指定路径上所有文件或目录的信息

格式：DIR [盘符：][路径][文件名] [参数]

参数：

/W：[宽屏](http://product.pconline.com.cn/itbk/diy/display/1111/2579088.html)显示，一排显示5个文件名，而不会显示修改时间，文件大小等信息;

/P：分页显示，当屏幕无法将信息完全显示时，可使用其进行分页显示;

/A：显示具有特殊属性的文件;

/S：显示当前目录及其子目录下所有的文件。

举例：DIR /P

将分屏显示当前目录下文件。在当前屏最后有一个“Press any key to continue . . .”提示，表示按任意键继续。

[![常用DOS命令大全1](clip_image001.jpg)](http://www.pconline.com.cn/images/html/viewpic_pconline.htm?http:/img0.pconline.com.cn/pconline/1404/14/4604099_1.jpg&channel=8970)

## taskkill

taskkill /f /im 想要结束的进程名 /f：指定强制终止的进程 /im ：映像名称 在后面可加/t：结束进程树

# 字典程序

## V1.0【2015.12.3】

```c++
#include <stdio.h>

void main()
{
	int a,i,j,k,l;
	char b[]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	puts("请输入1-4来选择您想要对应尾数的字典程序");
	scanf("%d",&a);
	puts("生成的字典为");
	if(a<1||a>4)
		puts("你输入的数字不符合要求");
	else
	{
		switch(a)
		{
		case 1:for(i=0;i<62;i++)
			   {
				   printf("%c ",b[i]);
			   }
			break;
		case 2:for(i=0;i<62;i++)
			   {
				   for(j=0;j<62;j++)
				   {
					   printf("%c%c  ",b[i],b[j]);
				   }
			   }
			break;
		case 3:for(i=0;i<62;i++)
			   {
				   for(j=0;j<62;j++)
				   {
					   for(k=0;k<62;k++)
					   {
						   printf("%c%c%c ",b[i],b[j],b[k]);
					   }
				   }
			   };
			break;
		case 4:for(i=0;i<62;i++)
			   {
				   for(j=0;j<62;j++)
				   {
					   for(k=0;k<62;k++)
					   {
						   for(l=0;l<62;l++)
							   printf("%c%c%c%c ",b[i],b[j],b[k],b[l]);
					   }
				   }
			   };
			break;
		}
	}
}

// 运用嵌套的for循环来实现功能，这个最基础的方法，也是最繁琐的、代码最长的方法。
```

![](clip_image001-1586099341294.png)

![clip_image003-1586099341294](clip_image003-1586099341294.png)

![clip_image002-1586099341294](clip_image002-1586099341294.png)

## V2.0（带结构体）【2015.12.10】

```c++
#include <stdio.h>

dir1(int a);
dir2(int a);
dir3(int a);
dir4(int a);

struct data
{
	char b[63];
};

struct data c={"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"};
int a,i,j,k,l;

void main()
{

	puts("请输入1-4来选择您想要对应尾数的字典程序");
	scanf("%d",&a);
	puts("生成的字典为");
	if(a<1||a>4)
		puts("你输入的数字不符合要求");
	else
	{
		switch(a)
		{
		case 1:dir1(a);break;
		case 2:dir2(a);break;
		case 3:dir3(a);break;
		case 4:dir4(a);break;
		}
	}
}

dir1(int a)
{
	int i;
	for(i=0;i<62;i++)
		printf("%c ",c.b[i]);
}

dir2(int a)
{
	int i;
	for(i=0;i<62;i++)
	{
		for(j=0;j<62;j++)printf("%c%c  ",c.b[i],c.b[j]);
	}
}

dir3(int a)
{
	int i;
	for(i=0;i<62;i++)
	{
		for(j=0;j<62;j++)
		{
			for(k=0;k<62;k++)
				printf("%c%c%c ",c.b[i],c.b[j],c.b[k]);
		}
	}
}

dir4(int a)
{
	int i;
	for(i=0;i<62;i++)
	{
		for(j=0;j<62;j++)
		{
			for(k=0;k<62;k++)
			{
				for(l=0;l<62;l++)
					printf("%c%c%c%c ",c.b[i],c.b[j],c.b[k],c.b[l]);
			}
		}
	}
}

// 仍然沿用V1.0的嵌套循环法，不过加入了结构体
```

## V3.0（有待修改）

```c++
#include "stdio.h"
#include "math.h"
#include "string.h"

char *opt[]={"0123456789","ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz"};
char source[63]={0};
int o=0;

void fun(int b,int g);
void option(int a);

void main()                                       //主函数
{
	int a,b;
	puts("字典程序选项如下：\n1.纯数字\n2.纯小写字母\n3.纯大写字母\n4.数字+小写字母\n5.数字+大写字母\n6.大小写字母混合\n7.数字+字母\n");
	puts("请输入字典类型和位数 (注意中间用空格隔开~) ");
	scanf("%d%d",&a,&b);
	if(a<1||a>7)
		puts("您输入了错误的数字，请关闭程序再重新进入");
	else
	{
		option(a);
		fun(o,b);
	}
}

void option(int a)
{
	int b;
	switch(a)                                     //匹配选项
	{
	case 1:strcpy(source,opt[0]);b=10;break;
	case 2:strcpy(source,opt[1]);b=26;break;
	case 3:strcpy(source,opt[2]);b=26;break;
	case 4:strcpy(source,opt[0]);strcat(source,opt[1]);b=36;break;
	case 5:strcpy(source,opt[1]);strcat(source,opt[2]);b=52;break;
	case 6:strcpy(source,opt[0]);strcat(source,opt[2]);b=36;break;
	case 7:strcpy(source,opt[0]);strcat(source,opt[1]);strcat(source,opt[2]);b=62;break;
	}
	o=b;
}

void fun(int b,int g)                             //功能函数
{
	int c,d,f;
	char a[1000]={0};
	for(c=0;c<pow(b,g);c++)
	{
		for(d=0,f=c;d<g;d++,f=f/62)
			a[d]=source[f%62];
		printf("%s\t",strrev(a));
	}
}
```

![img](clip_image001-1586099547382.png)

![img](clip_image002-1586099547382.png)

# 修改成绩（数组溢出）【2016.1.5】

## 学渣版

```c++
#include "stdio.h"
#include "string.h"

struct student
{
	int age;
	char name[9];
	int score;
}loser;

void main()
{
	char name[]="aaaaaaa d";
	int i=0;
	for(i=0;i<9;i++)
	{
		loser.name[i]=name[i];
	}
	printf("学渣的分数为：%d\n",loser.score);
	printf("%s\n",loser.name);
}
```

## 学霸版

```c++
#include "stdio.h"
#include "string.h"

struct student
{
	int age;
	char name[8];
	int test;
}hacker;

void main()
{
	char name[]="aaaaaaa d";
	int i=0,j=1;
	for(i=0;i<9;i++)
	{
		hacker.name[i]=name[i];
	}
	hacker.test=j;
	printf("黑客的分数为：%d\n",hacker.test);
	printf("%s\n",hacker.name);
}
```

# fgets函数【2016.1.7】

```c++
#include "stdio.h"
#include "string"

void main()
{
	char pro[10];
	puts("please enter a project:");
	fgets(pro,sizeof(pro),stdin);
	pro[strlen(pro)-1]=0;
	printf("Is %s your favorite project?\n",pro);
}
```

1. fgets（）强行限制用户输入字符串的长度，保证不会越界。
2. scanf（）允许输入结构化数据，而fgets（）只能输入一个字符串，且遇到换行符就停止。
3. scanf（）不能读取带空格的字符串，而fgets（）能读取整个字符串。

## 因此

需要输入有多个字段构成的结构化数据---->scanf()

想要输入一个非结构化的字符串---->fgets()