---
title: "C# 的协变和逆变"
date: 2019-10-08T13:22:58+08:00
tags: [".NET","csharp","covariance", "contravariance"]
categories: ["技术"]
draft: false
---
协变和逆变的概念存在于许多计算机语言中，本文主要讲C#中的协变和逆变<!--more-->
## 概念

先从一段代码开始：
```csharp
object[] objects = new string[2];
```
上面的代码在C#中是合法的，其实这就是协变。 因为string继承自object，所以string是object的子类型，记作 string ≦ object。

而oject的数组类型Object[]，是由object构造出来的一种新的类型,可以认为是一种构造类型，记f(object)，那么我们可以这么来描述协变和逆变：

当A ≦ B时,如果有f(A) ≦ f(B),那么f叫做 协变
当A ≦ B时,如果有f(B) ≦ f(A),那么f叫做 逆变
如果上面两种关系都不成立则叫做 不可变。
我觉得知乎问题 [应该怎么理解编程语言中的协变逆变？](https://www.zhihu.com/question/38861374) 的 [一个回答](https://www.zhihu.com/question/38861374/answer/79315718) 说的比较好：

> 逆变和协变描述了具有继承关系的类型，通过类型构造器映射到另一范畴时所具有的继承关系。 保持原继承关系的为协变，继承关系反转的为逆变 。

## 数组的协变
如上所述，C#从一开始就支持数组类型的协变，但这不是类型安全的:
```csharp
Animal[] animals = new Goldfish[10];
animals[0] = new Tiger(); // 运行时异常 ArrayTypeMismatchException
```
因为运行时，objs[]的类型是string[],无法存储int型。所以回抛出异常。这个从Java中抄来的特性，被Eric Lippert 列为[C#10大最糟糕特性](http://www.informit.com/articles/article.aspx?p=2425867)之首，实践中应避免使用。

## 型委托的可变性
C# 2.0 引入了委托的变体支持，用于在 C# 中匹配所有委托的方法签名和委托类型。 这表明不仅可以将具有匹配签名的方法分配给委托，还可以将返回派生程度较大的派生类型的方法分配给委托（协变），或者如果方法所接受参数的派生类型所具有的派生程度小于委托类型指定的程度（逆变），也可将其分配给委托。即 对参数的逆变性和对返回值的协变性

举例说明：

定义如下继承关系
```csharp
public class L1 { }

public class L2 : L1 { }

public class L3 : L2 { }
```
定义一个委托


```charp
public delegate L1 SampleDelegate(L3 t);
```
使用：
```csharp
// 将签名完全匹配的方法赋值给委托，无需转换
SampleDelegate d1 = RL1PL3;

// 将一个返回值的派生程度更大（协变），参数值的派生程度更小（逆变）的方法赋值给委托
SampleDelegate d2 = RL2PL2;

// 方法返回值派生程度继续变大，参数值的派生程度继续变小
SampleDelegate dNonGenericConversion1 = RL3PL1;

// 一个委托就可以适用于全部返回值、参数组合
// 使代码更通用
SampleDelegate sd1 = RL1PL1;
SampleDelegate sd2 = RL1PL2;
SampleDelegate sd3 = RL1PL3;
SampleDelegate sd4 = RL2PL1;
SampleDelegate sd5 = RL2PL2;
SampleDelegate sd6 = RL2PL3;
SampleDelegate sd7 = RL3PL1;
SampleDelegate sd8 = RL3PL2;
SampleDelegate sd9 = RL3PL3;
```
逆变为什么是类型安全的？
```csharp
Action<Base> b = (target) => { Console.WriteLine(target.GetType().Name); };
Action<Derived> d = b;
d(new Derived());
```
由于 lambda 表达式与其自身所分配到的委托相匹配，因此定义了一个方法，此方法采用一个类型 Base 的参数且没有返回值。 可以将结果委托分配给类型类型 Action 的变量，因为 T 委托的类型参数 Action 是逆变类型参数。 由于 T 指定了一个参数类型，因此该代码是类型安全代码。 在调用类型 Action 的委托（就像它是类型 Action的委托一样）时，其参数必须属于类型 Derived。 始终可以将此实参安全地传递给基础方法，因为该方法的形参属于类型 Base。

## 泛型中的可变性
### 泛型集合
C# 不支持泛型集合。考虑下面的代码:
```csharp
List<Giraffe> giraffes = new List<Giraffe>();
giraffes.Add(new Giraffe());
//List<Animal> animals = giraffes; // 编译错误
//animals.Add(new Lion()); // Aargh!
```
如果第3行是合法的，那么第4行也是合法,但animails的实际类型是List，你不可能把Lion添加到里面。

### 泛型委托
对于委托
```csharp
public delegate R SampleGenericDelegate<P, R>(P a);
```
类似非泛型委托,9种函数组合，一个委托就够了：
```csharp
SampleGenericDelegate<L3, L1> dg1 = RL1PL1;
SampleGenericDelegate<L3, L1> dg2 = RL1PL2;
SampleGenericDelegate<L3, L1> dg3 = RL1PL3;
SampleGenericDelegate<L3, L1> dg4 = RL2PL1;
SampleGenericDelegate<L3, L1> dg5 = RL2PL2;
SampleGenericDelegate<L3, L1> dg6 = RL2PL3;
SampleGenericDelegate<L3, L1> dg7 = RL3PL1;
SampleGenericDelegate<L3, L1> dg8 = RL3PL2;
SampleGenericDelegate<L3, L1> dg9 = RL3PL3;
```
C# 4.0 使用 **in** 和 **out** 来限定泛型委托中参数的可变性：

* [out](https://docs.microsoft.com/zh-cn/dotnet/csharp/language-reference/keywords/out-generic-modifier)： 对于泛型类型参数，out 关键字指定该类型参数是协变的。 可以在泛型接口和委托中使用 out 关键字。
* [in](https://docs.microsoft.com/zh-cn/dotnet/csharp/language-reference/keywords/in-generic-modifier)：对于泛型类型参数，in 关键字指定该类型参数是逆变的。 可以在泛型接口和委托中使用 in 关键字。
```csharp
public delegate TResult SampleGenericDelegate<in TP, out TResult>(TP a);
public delegate T SampleGenericDelegate1<out T>();
delegate void Action<in T>(T t);
delegate TResult Func<out TResult>();
```
## 泛型接口
.NET framework 4.0 使用 in 和 out 来定义接口的可变性，在这之前都是不可变的。

* in 限定类型参数只能用于参数，即**逆变**
* out 限定类型参数只能用于返回值，即**协变**
```csharp
interface IVariant<out R, in A>
{
    // 符合规则.
    R GetR();
    void SetA(A sampleArg);
    R GetRSetA(A sampleArg);

    // 不符合规则.
    // A GetA();
    // void SetR(R sampleArg);
    // A GetASetR(R sampleArg);
}
```
内置的一些接口：

* public interface IEnumerable
* public interface IEnumerator
* public interface IQueryable
* public interface IGrouping<out TKey,out TElement>

* public interface IComparable
* public interface IComparer
* public interface IEqualityComparer

举例 

最常见的：
```csharp
// 协变
IEnumerable<string> listL3 = new List<string>();
IEnumerable<object> lis = listL3;
```
方法的参数使用IEnumerable编写更通用的方法:
```csharp
class Program
{
    public static void PrintFullName(IEnumerable<Person> persons)
    {
        
    }
    public static void Main()
    {
        // 协变
        List<Teacher> employees = new List<Teacher>();
        PrintFullName(employees);
        
        // 协变
        List<Student> students = new List<Student>();
        PrintFullName(students);
    }
}
```
因为 IEnumerable 是只读的，无法和List一样添加元素，所以此处是类型安全的。

实现一个通用的Comparer ([来源](https://docs.microsoft.com/en-us/dotnet/standard/generics/covariance-and-contravariance))

```csharp
using System;
using System.Collections.Generic;

abstract class Shape
{
    public virtual double Area { get { return 0; }}
}

class Circle : Shape
{
    private double r;
    public Circle(double radius) { r = radius; }
    public double Radius { get { return r; }}
    public override double Area { get { return Math.PI * r * r; }}
}

class ShapeAreaComparer : System.Collections.Generic.IComparer<Shape>
{
    int IComparer<Shape>.Compare(Shape a, Shape b) 
    { 
        if (a == null) return b == null ? 0 : -1;
        return b == null ? 1 : a.Area.CompareTo(b.Area);
    }
}

class Program
{
    static void Main()
    {
        // You can pass ShapeAreaComparer, which implements IComparer<Shape>,
        // even though the constructor for SortedSet<Circle> expects 
        // IComparer<Circle>, because type parameter T of IComparer<T> is
        // contravariant.
        // SortedSet<Circle> 的构造函数需要IComparer<Circle>，但仍然可以传入是实现IComparer<Shape>的ShapeAreaComparer
        SortedSet<Circle> circlesByArea = 
            new SortedSet<Circle>(new ShapeAreaComparer()) 
                { new Circle(7.2), new Circle(100), null, new Circle(.01) };

        foreach (Circle c in circlesByArea)
        {
            Console.WriteLine(c == null ? "null" : "Circle with area " + c.Area);
        }
    }
}

/* This code example produces the following output:

null
Circle with area 0.000314159265358979
Circle with area 162.860163162095
Circle with area 31415.9265358979
 */
```
## 注意
* 协变逆变是针对构造类型的，注意和赋值兼容的区别
* 协变逆变适用于引用类型，不支持值类型
* 在 .NET Framework 4 中，Variant 类型参数仅限于泛型接口和泛型委托类型。

## 代码:
https://github.com/prime167/csharp-covariance-contravariance.git

## 参考、扩展阅读
* [泛型中的协变和逆变](https://docs.microsoft.com/zh-cn/dotnet/standard/generics/covariance-and-contravariance)
* [Covariance and Contravariance FAQ](https://devblogs.microsoft.com/csharpfaq/covariance-and-contravariance-faq/)
* [The theory behind covariance and contravariance in C# 4](http://tomasp.net/blog/variance-explained.aspx/)
* [Understanding C# Features (8) Covariance and Contravariance](https://weblogs.asp.net/dixin/understanding-csharp-features-8-covariance-and-contravariance)
* [Eric Lippert 协变逆变文章](https://blogs.msdn.microsoft.com/ericlippert/tag/covariance-and-contravariance/page/3/)
* [Why does C# use contravariance (not covariance) in input parameters with delegate?](https://stackoverflow.com/a/37469171/65994)
* [C# - 协变、逆变 看完这篇就懂了](https://www.cnblogs.com/VVStudy/p/11404300.html)
* [COVARIANCE, CONTRAVARIANCE AND WHY CAT LOVERS ARE EVIL](https://web.archive.org/web/20160310155242/http://adamnathan.co.uk/?p=75)