---
title: Java作业整理
date: 2017-01-07T14:36:56+08:00
tags: ["java"]
categories: ["技术"]
---

# 课后题

## 2-3

```java
public class Work3
{
    public static void main(String[] args)
    {
        int i=0,j=0;
        double[] b={1,-2,+0,-0,Double.POSITIVE_INFINITY,Double.NEGATIVE_INFINITY,Double.NaN};
        double[][] a=new double[7][7];
        for(i=0;i<=6;i++)
            for(j=0;j<=6;j++)
                {
                    a[i][j]=b[i]/b[j];
                    System.out.print(a[i][j]+"      ");
                    if(j==6)
                    {
                        System.out.print("\n");
                    }
                }
    }
}
```

## 2-17

```java
public class Work17
{
    public static void main(String[] args)
    {
        int[] a={4,6,23,78,2,345,90098,2,5,1,90098};
        int min=0,min_value=0,i=0;
        for(;i<a.length;i++)
        {
            if(a[i]>min_value)
                {
                    min_value=a[i];
                    min=i;
                }
            if(a[i]==min_value)
                continue;
        }
        System.out.println("The min is NO."+min+" : "+min_value);
        System.out.println("Attention please:The array is began with \"0\"");
    }
}
```

## 2-18

```java
public class Work18
{
    public static void main(String[] args)
    {
        int[][] array={{99,22,639,15,66,19},{17,85,56,535,89,76},{56,67,71,51,24,873},{821,61,83,17,24,78},{2,232,87,95,68,49},{25,90,869,92,93,25}};
        int[] sum=new int[6];
        int max=0,max_value=0,i=0,j=0;
        for(;i<array[0].length;i++)
            for(;j<array[0].length;j++)
                sum[i]=sum[i]+array[i][j];
        for(i=0;i<array[0].length;i++)
        {
            if(sum[i]>max)
                {
                    max_value=sum[i];
                    max=i;
                }
            if(sum[i]==max_value)
            continue;
        }
        System.out.println("The max sum_value("+max_value+") is in the Line."+max);
    }
}
```

## 2-19

```java
public class Work19
{
    public static void main(String args[])
    {
        int[] a=new int[4];
        int i=1000,j=0;
        for(;i<10000;i++)
        {
            a[0]=i/1000;
            a[1]=(i-a[0]*1000)/100;
            a[2]=(i-a[0]*1000-a[1]*100)/10;
            a[3]=i-a[0]*1000-a[1]*100-a[2]*10;
            if((a[0]*10+a[1])*(a[2]*10+a[3])==i||(a[1]*10+a[0])*(a[2]*10+a[3])==i||(a[0]*10+a[1])*(a[3]*10+a[2])==i||(a[1]*10+a[0])*(a[3]*10+a[2])==i)
                System.out.println(i);
            if((a[0]*10+a[2])*(a[1]*10+a[3])==i||(a[2]*10+a[0])*(a[1]*10+a[3])==i||(a[0]*10+a[2])*(a[3]*10+a[1])==i||(a[2]*10+a[0])*(a[3]*10+a[1])==i)
                System.out.println(i);
            if((a[0]*10+a[3])*(a[1]*10+a[2])==i||(a[3]*10+a[0])*(a[1]*10+a[2])==i||(a[0]*10+a[3])*(a[2]*10+a[1])==i||(a[3]*10+a[0])*(a[2]*10+a[1])==i)
                System.out.println(i);
        }
    }
}
```

## 3-2

```java
public class Work2
{
    public static void main(String args[])
    {
        NewRectangle a=new NewRectangle();
        a.Initialize(3,4);
        a.getArea(3,4);
        a.getPerimeter(3,4);
    }
}

class NewRectangle
{
    double width,height;
    public void Initialize(double width,double height)
    {
        this.width=width;
        this.height=height;
        System.out.println("width initialize:"+this.width+'\n'+"height initialize:"+this.height+'\n');
    }
    public void getArea(double width,double height)
    {
        System.out.println("The area is:"+width*height+'\n');
    }
    public void getPerimeter(double width,double height)
    {
        System.out.println("The perimeter is:"+2*(width+height));
    }
}
```

*3-2和3-3中有重复的类NewRectan，会相互覆盖...*

## 3-3

```java
public class Work3
{
    public static void main(String args[])
    {
        NewRectangle a=new NewRectangle();
        a.Initialize(0,0);
        a.set(1,1,4,5);
        Point b=new Point();
        b.Initialize(6,3);
        System.out.println(a.bPointIn(b));
        Rectangle c=new Rectangle();
        c.Initialize(10,10,10,10);
        System.out.println(a.bRectangleIn(c));
    }
}

class NewRectangle
{
    double width,height;
    public void Initialize(double width,double height)
    {
        this.width=width;
        this.height=height;
        //System.out.println("width initialize:"+this.width+'\n'+"height initialize:"+this.height+'\n');
    }
    /*public void getArea(double width,double height)
    {
        System.out.println("The area is:"+width*height+'\n');
    }
    public void getPerimeter(double width,double height)
    {
        System.out.println("The perimeter is:"+2*(width+height));
    }*/
    Point lower_left=new Point();
    public void set(double x,double y,double width,double height)
    {
        this.width=width;
        this.height=height;
        lower_left.x=x;
        lower_left.y=y;
    }
    public boolean bPointIn(Point p)
    {
        if((lower_left.x<=p.x)&&(p.x<=lower_left.x+this.width)&&(lower_left.y<=p.y)&&(p.y<=lower_left.y+this.height))
            return true;
        else
            return false;
    }
    public boolean bRectangleIn(Rectangle r)
    {
        Point m=new Point();
        m.Initialize(r.x,r.y);
        if(bPointIn(m))
            return true;
        m.Initialize(r.x+r.width,r.y);
        if(bPointIn(m))
            return true;
        m.Initialize(r.x,r.y+r.height);
        if(bPointIn(m))
            return true;
        m.Initialize(r.x+r.width,r.y+r.height);
        if(bPointIn(m))
            return true;
        return false;
    }
}

class Point
{
    double x,y;
    public void Initialize(double x,double y)
    {
        this.x=x;
        this.y=y;
    }
    public void distance(double a,double b)
    {
        //System.out.println("The distance is:"+Math.sqrt((a-x)*(a-x)+(b-y)*(b-y)));
    }
}

class Rectangle
{
    double x,y,width,height;
    public void Initialize(double x,double y,double width,double height)
    {
        this.x=x;
        this.y=y;
        this.width=width;
        this.height=height;
    }
}
```

3-3中复杂在判断两个矩形是否有相互覆盖的地方，想出来的办法是对其中一个矩形的4个顶点分别调用判断是否在另一个矩形内的函数

## 3-9

```java
public class Work9
{
    public static void main(String args[])
    {
        Cycle a=new Cycle();
        Unicycle b=new Unicycle();
        Bicycle c=new Bicycle();
        Tricycle d=new Tricycle();
        run1(d);                 //upcasting

        Cycle e1=new Bicycle();
        Bicycle e2=(Bicycle) e1;
        run2(e2);                //downcasting
        /*
        if(e1 instanceof a)
        {
            Bicycle e2=(Bicycle) e1;
            run2(e2);
        }
         */
        }
    }
    public static void run1(Cycle cycle)
    {
        cycle.wheel();
    }
    public static void run2(Bicycle bicycle)
    {
        bicycle.balance();
    }
}

class Cycle
{
    public void ride()
    {
            wheel();
    }
    public void wheel()
    {
        System.out.println("4");
    }
}

class Unicycle extends Cycle
{
    public void wheel()
    {
        balance();
    }
    public void balance()
    {
        System.out.println("1");
    }
}

class Bicycle extends Cycle
{
    public void wheel()
    {
        balance();
    }
    public void balance()
    {
        System.out.println("2");
    }
}

class Tricycle extends Cycle
{
    public void wheel()
    {
        System.out.println("3");
    }
}
```

3-9中对于向上转型和向下转型的理解还不是很到位，因为变得程序不多，现在还没体会到这种多态的巨大优势性

## 5-4

```java
import java.util.*;

public class Work5_4
{
    public static void Deal(String str1)
        {
            int i,j=0;
            List<Character> a=new LinkedList<Character>();
            char[] str=str1.toCharArray();
            for(i=0;i<str.length;i++)
            {
                if(str[i]=='+')
                    {
                        a.add(j,str[i+1]);
                        j++;
                    }
                if(str[i]=='-')
                {
                    System.out.print(a.get(j-1)+" ");
                    a.remove(j-1);
                    j--;
                }
            }
            System.out.println("\n"+a);
        }
    public static void main(String args[])
    {
        String str="+U+n+c---+e+r+t---+a-+i-+n+t+y---+-+r+u--+1+e+s---";
        Deal(str);
    }
}

```

## 5-7

```java
import java.io.*;
import java.util.regex.*;

public class Work5_7
{
    public static void main(String args[])
    {
        String filepath="D:\\wordlist.txt";
        Deal(filepath);
    }
    
    public static void Deal(String filepath)
    {
        String line;
        int public1=0,class1=0,new1=0,import1=0;
        try
        {
            BufferedReader in=new BufferedReader(new FileReader(filepath));
            line = in.readLine();
            Matcher m;
            while(line!=null)
            {
                String lines=line.toArray.split(" ");
                System.out.println(lines);
                m=Pattern.compile("public").matcher(line);
                if(m.find())
                    public1+=1;
                m=Pattern.compile("class").matcher(line);
                if(m.find())
                    class1+=1;
                m=Pattern.compile("new").matcher(line);
                if(m.find())
                    new1+=1;
                m=Pattern.compile("import").matcher(line);
                if(m.find())
                    import1+=1;
                line = in.readLine();
            }
            in.close();
            System.out.println("public:"+public1);
            System.out.println("class:"+class1);
            System.out.println("new:"+new1);
            System.out.println("import:"+import1);
        }
        catch(IOException e)
        {
            System.out.println("Problemreading"+filepath);
        }
    }
}
//程序运行缺点：当一行有多个同样的关键字时，只能算作一个...
```

## 6-4

```java
import java.util.regex.*;

public class Work6_4
{
    public static void main(String args[])
    {
        Deal deal=new Deal();
        deal.Work();
    }
}

class Deal
{
    static String str="In this world there are millions of source and you can Learn from Every Possible Source. With a Master you start Learning to learn.";
    public void Work()
    {
        System.out.println("The string is\n"+this.str);
        Matcher m1=Pattern.compile("[aeiou]").matcher(this.str);
        Matcher m2=Pattern.compile("(?i)[aeiou]").matcher(this.str);
        String str21=m1.replaceAll("*");
        String str22=m2.replaceAll("*");
        System.out.println(str21);
        System.out.println(str22);
    }
}
```

## 6-6

```java
import java.io.*;
import java.util.regex.*;

public class Work6_6
{
    public static void Read(String filepath)
    {
        String line;
        try
        {
            BufferedReader in=new BufferedReader(new FileReader(filepath));
            line=in.readLine();
            while(line!=null)
            {
                Matcher m=Pattern.compile("//\\w+").matcher(line);
                if(m.find())
                    System.out.println(m.group());
                /*m=Pattern.compile("/\\*\\w+").matcher(line);
                if(m.find())
                    System.out.println(m.group());
                Matcher n=Pattern.compile("\\w+\\*\\/").matcher(line);
                line=n.group();
                while(!n.find())
                {
                    System.out.println(line);
                    line = in.readLine();
                    n=Pattern.compile("\\w+\\*\\/").matcher(line);
                }*/
                //处理"//"可以，但是"/* */"处理不好 =。=
                line = in.readLine();
            }
            in.close();
        }
        catch(IOException e)
        {
            System.out.println("Problemreading"+filepath);
        }
    }
    
    public static void main(String args[])
    {
        String filepath="D:\\wordlist.txt";
        Read(filepath);
    }
}
```

## 10-5

```java
class Lock
{
    protected boolean locked;
    
    public Lock()
    {
        locked = false;
    }
    
    public synchronized void lock() throws InterruptedException
    {
        while (locked)
            wait();
        locked = true;
    }
    
    public synchronized void unlock()
    {
        locked = false;
        notify();
    }
}
class Fork
{
    public char id;
    private Lock lock = new Lock();
    
    public void pickup() throws InterruptedException
    {
        lock.lock();
    }
    
    public void putdown() throws InterruptedException
    {
        lock.unlock();
    }
    
    public Fork(int j)
    {
        Integer i = new Integer(j);
        id = i.toString().charAt(0);
    }
}

class Philosopher extends Thread
{
    public char state = 'T';
    private Fork L, R;
    
    public Philosopher(Fork left, Fork right)
    {
        super();
        L = left;
        R = right;
    }
    
    protected void think() throws InterruptedException
    {
        sleep((long) (Math.random() * 100.0));
    }
    
    protected void eat() throws InterruptedException
    {
        sleep((long) (Math.random() * 100.0));
    }
    
    public void run()
    {
        int i;
        try {
            for (i = 0; i < 100; i++)
            {
                state = 'T';//Thinking
                think();
                state = 'L';//Picking Left Chopsticks
                sleep(1);
                L.pickup();
                state = 'R';//Picking Right Chopsticks
                sleep(1);
                R.pickup();
                state = 'E';//Eating
                eat();
                L.putdown();
                R.putdown();
            }
            state = 'o';//over
        } catch (InterruptedException e){
        }
    }
}

public class Work10_5
{
    static Fork[] fork = new Fork[5];
    static Philosopher[] philo = new Philosopher[5];
    
    public static void main(String[] args)
    {
        int i, j = 0, k = 0;
        boolean goOn;
        for (i = 0; i < 5; i++)
        {
            fork[i] = new Fork(i);
        }
        for (i = 0; i < 4; i++)
        {
            philo[i] = new Philosopher(fork[i], fork[(i + 1) % 5]);
        }
        philo[4] = new Philosopher(fork[0], fork[4]);
        for (i = 0; i < 5; i++)
        {
            philo[i].start();
        }
        int newPrio = Thread.currentThread().getPriority() + 1;
        Thread.currentThread().setPriority(newPrio);
        goOn = true;
        while (goOn) {
            for (i = 0; i < 5; i++)
            {
                System.out.print(philo[i].state+"\t");
            }
            System.out.println();
            goOn = false;
            for (i = 0; i < 5; i++)
            {
                goOn |= philo[i].state != 'o';
            }
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                return;
            }
        }
    }
}
```

# 练习

## AccountProducerConsumer

```java
import java.util.concurrent.*;

public class AccountProducerConsumer
{
    static Account account=new Account();
    public static void main(String args[])
    {
        ExecutorService exec=Executors.newFixedThreadPool(2);
        exec.execute(new DepositTask());
        exec.execute(new WithdrawTask());
        exec.shutdown();
    }
}

class Account
{
    private int balance=0;
    public synchronized void deposit(int amount)
    {
        this.notifyAll();
        balance+=amount;
        System.out.println("Deposit "+amount+":balance = "+getBalance());
    }
    public synchronized void withdraw(int amount)
    {
        while(balance<amount)
        {
            try
            {
                this.wait();
            }
            catch(InterruptedException e)
            {
                e.printStackTrace();
            }
        }
        balance-=amount;
        System.out.println("Withdraw "+amount+"; balance = "+getBalance());
    }
    public int getBalance()
    {
        return balance;
    }
}

class DepositTask implements Runnable
{
    public void run()
    {
        while(true)
        {
            AccountProducerConsumer.account.deposit(1);
            try
            {
                Thread.sleep(1000);
            }
            catch(InterruptedException e)
            {
                e.printStackTrace();
            }
        }
    }
}

class WithdrawTask implements Runnable
{
    public void run()
    {
        while(true)
        {
            AccountProducerConsumer.account.withdraw(5);
        }
    }
}
```

## AddAccountSync

```java
public class AddAccountSync
{
    static Account account=new Account();
    public static void main(String args[])
    {
        for(int i=0;i<100;i++)
            new Thread(new TaskSync()).start();
        System.out.println("Final balance: "+account.getBalance());
    }
}

class TaskSync implements Runnable
{
    public void run()
    {
        synchronized(AddAccountSync.account)
        {
            AddAccountSync.account.deposit(1);
        }
    }
}

class Account
{
    private int balance=0;
    public void deposit(int amount)
    {
        int tmp=balance+amount;
        Thread.yield();
        balance=tmp;
    }
    public int getBalance()
    {
        return balance;
    }
}
```

## GetLockAgain

```java
public class GetLockAgain implements Runnable
{
    public synchronized void mtd()
    {
        System.out.println("Entered Critical Section in mtd()");
        mtd2();
    }
    public synchronized void mtd2()
    {
        System.out.println("Entered Critical Section in mtd2()");
    }
    public void run()
    {
        mtd();
    }
    public static void main(String args[])
    {
        new Thread(new GetLockAgain()).start();
    }
}
```

## Logger

```java
public class Logger implements Runnable
{
    private volatile static Logger logger=null;
    
    public void run()
    {
        try
        {
            for(int i=0;i<3;i++)
            {
                System.out.println("I'm writing in the log...\n");
                Thread.sleep((long)(Math.random()*3000));
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }
    
    private Logger() {}
    
    public static Logger getInstance()
    {
        if (logger== null)  {
            synchronized (Logger.class)
            {
                if (logger== null)
                {
                    logger= new Logger();
                }
            }
        }
        return logger;
    }
    
    public static void main(String args[])
    {
        Thread t1=new Thread(Logger.getInstance());
        Thread t2=new Thread(Logger.getInstance());
        Thread t3=new Thread(Logger.getInstance());
        t1.start();
        t2.start();
        t3.start();
    }
}
```

## ArrayCopy_Length

```java
public class ArrayCopy_Length
{
    public static void main(String[] args)
    {
        char[] src={'h','o','w',' ','a','r','e',' ','y','o','u'};
        char[] target=new char[3];
        System.arraycopy(src,4,target,0,3);
        System.out.println(new String(target));
        int[][] a={{1,2,3,4,5},{1,2,3}};
        System.out.println(a.length+";"+a[0].length+";"+a[1].length);
    }
}
```

## AssignConversion

```java
public class AssignConversion
{
    public static void main(String[] args)
    {
        int i=123456789;
        long l=9123456789000000000L;
        float f;
        double d
        ;

        f=i;//损失精度
        System.out.println(f);
        f=l;//损失精度
        System.out.println(f);
        d=l;//损失精度
        System.out.println(d);
        f=1.23f;
        d=f;//损失精度
        System.out.println(d);
    }
}
```

## BinaryConversion

```java
public class BinaryConversion
{
    public static void main(String[] args)
    {
        int i=0;
        float f=2.0f;
        double d=4.0;

        //首先 float*int转换为loat*float然后float==double转换为ouble==double
        System.out.println(f*i==d);

        byte b=0x1f;
        char c='G';
        System.out.println(Integer.toHexString(b&c));//byte&byte转换为nt&int

        f=(b==0)?i:6.0f;                    //int:float转换为loat:float
        System.out.println(f/2.0);          //float/doublet转换为ouble/double
    }
}
```

## BufferedIO

```java
package chap08;

import java.io.*;

public class BufferedIO
{
    public static void main(String args[]) throws IOException
    {
        BufferedReader in=new BufferedReader(new FileReader("chap08\\BufferedIO.java"));
        PrintWriter out=new PrintWriter(new BufferedWriter(new FileWriter("chap08\\BufferedIO.txt")));
        String s;
        int linecnt=1;
        StringBuilder sb=new StringBuilder();
        while((s=in.readLine())!=null)
        {
            sb.append(linecnt+";"+s+"\n");
            out.println(linecnt+";"+s);
            linecnt++;
        }
        in.close();
        out.close();
        System.out.print(sb.toString());
    }
}
```

## ConstructSubObj

```java
public class ConstructSubObj
{
    public static void main(String[] args)
    {
        Undergraduate ug=new Undergraduate(12345678);
    }
}

class Person
{
    Person()
    {
        System.out.println("Person");
    }
}

class Student extends Person
{
    Student(int id)
    {
        System.out.println("Student"+id);
    }
}

class Undergraduate extends Student
{
    Undergraduate(int id)
    {
        super(id);
        System.out.println("Undergraduate");
    }
}
```

## HelloWorld

```java
public class HelloWorld
{
    public static void main(String[] args)
    {
        System.out.println("Hello World!");
    }
}
```

## InstanceInitializer

```java
public class InstanceInitializer
{
    Comp c1=new Comp(1);
    public InstanceInitializer()
    {
        System.out.println("Instance Initielizer");
    }
    Comp c2;
    public static void main(String[] args)
    {
        InstanceInitializer ii=new InstanceInitializer();
    }
    Comp c3=new Comp(3);
    {//实例初始化程序块
        c2=new Comp(2);
    }
}

class Comp
{
    public Comp(int i)
    {
        System.out.println("Comp("+i+")");
    }
}
```

## ParameterPass

```java
public class ParameterPass
{
    public  void passValue(int v)
    {
        v=3;
    }
    public void passObject1(Circle c)
    {
        c=new Circle(3.0);
    }
    public void passObject2(Circle c)
    {
        c.setRadius(3.0);
    }
    public void passArray1(int[] a)
    {
        a=new int[4];
    }
    public void passArray2(int[] a)
    {
        a[a.length-1]=0;
    }
    public void printArray(int[] a)
    {
        for(int i:a)
            System.out.println(i+" ");
        System.out.println();
    }
    public static void main(String[] args)
    {
        ParameterPass pp=new ParameterPass();
        int i=4;
        pp.passValue(i);//传值，不会改变i的内容
        System.out.println(i);

        Circle circ=new Circle(4.0);
        pp.passObject1(circ);
        System.out.println(circ.getRadius());
        pp.passObject2(circ);
        System.out.println(circ.getRadius());

        int[] array=new int[]{1,2,3};
        pp.passArray1(array);
        pp.printArray(array);

        pp.passArray2(array);
        pp.printArray(array);
    }
}

class Circle
{
    private double radius;
    public Circle(double r)
    {
        radius=r;
    }
    public void setRadius(double r)
    {
        radius=r;
    }
    public double getRadius()
    {
        return radius;
    }
}
```

## Rectangle

```java
public class Rectangle
{
    private int width=0;
    private int height=0;
    
    public boolean setwidth(int w)
    {
        if(w>0)
        {
            width=w;
            return true;
        }
        return false;
    }
    
    public boolean setHeight(int h)
    {
        if(h>0)
        {
            height=h;
            return true;
        }
        return false;
    }
    
    public int getWidth()
    {
        return width;
    }
    
    public int getHeight()
    {
        return height;
    }
    
    public int getArea()
    {
        return width*height;
    }
    
    public int getPerimeter()
    {
        return 2*(width+height);
    }
    
    public static void main(String[]  args)
    {
        Rectangle rect=new Rectangle();
        if(rect.setwidth(3)&&rect.setHeight(2))
        {
            System.out.println(rect.width+";"+rect.height);
            System.out.println("Area of Rectangle:"+rect.getArea());
            System.out.println("Perimeter of Rectangle:"+rect.getPerimeter());
        }
    }
}
```

## Rectangle2

```java
public class Rectangle2
{
    int witdth=3;
    int height=2;
    Point pos;
    
    public Rectangle2(int w, int h,int x,int y)
    {
        witdth=w;
        height=h;
        pos=new Point(x,y);
    }
    
    public static void main(String[] args)
    {
        Rectangle2 rect=new Rectangle2(10,11,1,1);
    }
}

class Point
{
    int x;
    int y;
    public Point(int x,int y)
    {
        this.x=x;
        this.y=y;
    }
}
```

## ShiftRight

```java
public class ShiftRight
{
    public static void main(String[] args)
    {
        System.out.println(Integer.toBinaryString(-12));//0xfffffff4

        int i=-12;
        System.out.println(Integer.toBinaryString(i>>2));//带符号右移
        System.out.println(Integer.toBinaryString(i>>>2));//无符号右移

        byte b=-12;
        System.out.println(Integer.toBinaryString(b>>2));//首先byte转换为int，然后带符号右移
        System.out.println(Integer.toBinaryString(b>>>2));//首先byte转换为int，然后无符号右移

        System.out.println(Integer.toBinaryString(b>>2L));//byte转换为int，而不会转换为long
        System.out.println(Long.toBinaryString(-12L>>2L));
    }
}
```

## TestInheritance

```java
public class TestInheritance
{
    public static void main(String[] args)
    {
        Rectangle rect=new Rectangle();
        rect.newDraw();
        Circle circ=new Circle();
        circ.newDraw();
    }
}

class Shape
{
    public void draw()
    {
        System.out.println("Draw shape");
    }
}

class Rectangle extends Shape
{
    public void draw()
    {
        System.out.println("Draw Rectangle");
    }
    public void newDraw()
    {
        draw();
        super.draw();
    }
}

class Circle extends Shape
{
    public void newDraw()
    {
        draw();
        super.draw();
    }
}
```

## TestIterator

```java
import java.util.*;

public class TestIterator
{
    public static void main(String args[])
    {
        String sentence="The day you went away!";
        String[] strs=sentence.split(" ");
        List<String> list=new ArrayList<String>(Arrays.asList(strs));
        Iterator<String> it=list.iterator();
        while(it.hasNext())
        {
            System.out.print(it.next()+"_");
        }
        System.out.println();

        it=list.iterator();
        while(it.hasNext())
        {
            if(it.next().equals("you"))
                it.remove();
        }

        it=list.iterator();
        while(it.hasNext())
        {
            System.out.print(it.next()+" ");
        }
        System.out.println();
    }
}
```

## TestOverloading

```java
public class TestOverloading
{
    public static void main(String[] args)
    {
        System.out.println(false);
        System.out.println('C');
        System.out.println(123);
        System.out.println(132L);
        System.out.println(12.3f);
        System.out.println(12.3);
        System.out.println();
        char[] cc={'a','b','c'};
        System.out.println(cc);
        System.out.println("abc");
        System.out.println(new java.util.Date());
    }
}
```

## TestSet

```java
import java.util.*;

public class TestSet
{
    public static void main(String args[])
    {
        Random rand=new Random(47);
        Set<Integer> s=new HashSet<Integer>();
        for(int i=0;i<5000;i++)
        {
            s.add(rand.nextInt(40));
        }
        System.out.println(s);

        s=new TreeSet<Integer>();
        for(int i=0;i<5000;i++)
        {
            s.add(rand.nextInt(40));
        }
        System.out.println(s);

        s=new LinkedHashSet();
        for(int i=0;i<5000;i++)
        {
            s.add(rand.nextInt(40));
        }
        System.out.println(s);
        }
}
```