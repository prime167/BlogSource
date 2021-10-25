---
title: "c# 传递结构体参数的那些事儿"
date: 2019-08-16T16:36:27+08:00
draft: false
tags: ["csharp","struct"]
categories: ["技术"]
---
今天来说一下C#中传递结构体参数的演化<!--more-->
我们知道，C#有两种数据类型：*值类型* (本文主要讨论结构体) 和*引用类型*，相应的，传参的时候，也有两种方式：

* 按值传递：值类型传递的是变量的副本，在函数里的修改不会影响原值
* 按引用传递：引用类型传递的是对象的引用，在函数内部的修改会也会反应到原变量，因为两者本来就是同一个对象。

## 值传递 ##

```csharp
// 按值传递参数
public double Calculate(Point3D point1, Point3D point2)
{
    double xDifference = point1.X - point2.X;
    double yDifference = point1.Y - point2.Y;
    double zDifference = point1.Z - point2.Z;

    return Math.Sqrt(xDifference * xDifference + yDifference * yDifference + zDifference * zDifference);
}

...

struct Point3D
{
    public double X { get; set; }
    public double Y { get; set; }
    public double Z { get; set; }

    public Point3D(double x, double y, double z)
    {
        X = x;
        Y = y;
        Z = z;
    }
}
```

值传递会频繁创建结构体的副本，当结构体特别大时，就会对性能造成影响。从C# 1.0开始，我们就可以对值类型添加ref 或者 out，直接传递变量的地址而不创建副本，从而避免了性能损耗。

* ref：方法可修改变量
* out：方法必须修变量

## ref 传递 ##

```csharp
// ref传递
public double CalculateRef(ref Point3D point1,ref Point3D point2)
{
    double xDifference = point1.X - point2.X;
    double yDifference = point1.Y - point2.Y;
    double zDifference = point1.Z - point2.Z;

    return Math.Sqrt(xDifference * xDifference + yDifference * yDifference + zDifference * zDifference);
}

// 调用：
var r2 = CalculateRef(ref p1,ref p2);
```

IL代码, 注意参数类型是Point3D&，即传递的是地址

```msil
.method public hidebysig
        instance float64 CalculateRef (
            valuetype Point3D& point1,
            valuetype Point3D& point2
        ) cil managed
    {
        // Method begins at RVA 0x215c
        // Code size 57 (0x39)
        .maxstack 3
        .locals init (
            [0] float64,
            [1] float64
        )

        IL_0000: ldarg.1
        ...
    } // end of method Program::CalculateRef
```

## out 传递 ##

``` csharp
public double CalculateOut(out Point3D point1)
{
    point1 = new Point3D(2,2,2);
    return 0;
}
```

IL 代码, 除了类型是Point3D&，前面还有[out]

```il
.method public hidebysig
        instance float64 CalculateOut (
            [out] valuetype Point3D& point1
        ) cil managed
    {
        // Method begins at RVA 0x21a9
        // Code size 48 (0x30)
        .maxstack 8

        IL_0000: ldarg.1
        IL_0001: ldc.r8 2
        IL_000a: ldc.r8 2
        IL_0013: ldc.r8 2
        IL_001c: newobj instance void Point3D::.ctor(float64, float64, float64)
        IL_0021: stobj Point3D
        IL_0026: ldc.r8 0.0
        IL_002f: ret
    } // end of method Program::CalculateOut
```

但有时候我们不想让调用者修改我们的变量，*ref* 和 *out* 就无能为力了。

## in 传递 ##

作为 *ref* 和 *out* 的补充，C# 7.2对in关键字进行了扩展，允许传参时用*in*关键字修饰，以表明设计意图：变量按照引用方式传递，但是不允许方法对变量进行修改。

```csharp
public double CalculateIn(in Point3D point1,in Point3D point2)
{
    //error CS8332: Cannot assign to a member of variable 'in Point3D' because it is a readonly variable

    //point1.X = 33;
    double xDifference = point1.X - point2.X;
    double yDifference = point1.Y - point2.Y;
    double zDifference = point1.Z - point2.Z;

    return Math.Sqrt(xDifference * xDifference + yDifference * yDifference + zDifference * zDifference);
}
```

如果试图修改point1.X,会产生编译错误CS8332：不能对 in Piont3D变量的成员赋值，因为它是只读的。
但这里有一个陷阱，我们先看一下编译器生成的C#代码：

```csharp
public double CalculateIn([In] [IsReadOnly] ref Point3D point1, [In] [IsReadOnly] ref Point3D point2)
{
    Point3D point3D = point1;
    double x = point3D.X;
    point3D = point2;
    double num = x - point3D.X;
    point3D = point1;
    double y = point3D.Y;
    point3D = point2;
    double num2 = y - point3D.Y;
    point3D = point1;
    double z = point3D.Z;
    point3D = point2;
    double num3 = z - point3D.Z;
    return Math.Sqrt(num * num + num2 * num2 + num3 * num3);
}

// 调用方，不需要添加in
var r4 = CalculateIn(p1,p2);
```

每个变量都生成了防御性副本(defensive copy)。

IL代码

```il
 .method public hidebysig
        instance float64 CalculateIn (
            [in] valuetype Point3D& point1,
            [in] valuetype Point3D& point2
        ) cil managed
    {
        .param [1]
        .custom instance void [mscorlib]System.Runtime.CompilerServices.IsReadOnlyAttribute::.ctor() = (
            01 00 00 00
        )
        .param [2]
        .custom instance void [mscorlib]System.Runtime.CompilerServices.IsReadOnlyAttribute::.ctor() = (
            01 00 00 00
        )
        // Method begins at RVA 0x21dc
        // Code size 105 (0x69)
        .maxstack 3
        .locals init (
            [0] float64,
            [1] float64,
            [2] valuetype Point3D
        )

        IL_0000: ldarg.1
        IL_0001: ldobj Point3D
        IL_0006: stloc.2
        IL_0007: ldloca.s 2
        IL_0009: call instance float64 Point3D::get_X()
        IL_000e: ldarg.2
```

除了和**out**类似的 *[in] valuetype Point3D&* ，还添加了 **IsReadOnlyAttribute**，

*IL_0001: ldobj Point3D* 这条语句也表明会生成变量副本。

## 解决方法 ##

为了解决in传递可能带来的性能问题，C# 7.2 同时添加了 **readonly struct**

```csharp
public double CalculateReadonlyIn(in ReadonlyPoint3D point1,in ReadonlyPoint3D point2)
{
    double xDifference = point1.X - point2.X;
    double yDifference = point1.Y - point2.Y;
    double zDifference = point1.Z - point2.Z;

    return Math.Sqrt(xDifference * xDifference + yDifference * yDifference + zDifference * zDifference);
}

readonly struct ReadonlyPoint3D
{
    // 所有字段必须是只读的
    public double X { get;  }
    public double Y { get;  }
    public double Z { get;  }

    public ReadonlyPoint3D(double x, double y, double z)
    {
        X = x;
        Y = y;
        Z = z;
    }
}
```

编译器生成的代码：

```csharp
public double CalculateReadonlyIn([In] [IsReadOnly] ref ReadonlyPoint3D point1, [In] [IsReadOnly] ref ReadonlyPoint3D point2)
{
    double num = point1.X - point2.X;
    double num2 = point1.Y - point2.Y;
    double num3 = point1.Z - point2.Z;
    return Math.Sqrt(num * num + num2 * num2 + num3 * num3);
}
```

没有创建防御性副本。

## 总结 ##

* 对于较大的struct，用in关键字进行传递提高性能同时表明方法的意图：引用传递，无法修改传入的值
* 用in传参时一定要配readonly struct，以避免性能损失。

## 参考 ##

[Write safe and efficient C# code](https://docs.microsoft.com/en-us/dotnet/csharp/write-safe-efficient-code)

[Avoiding struct and readonly reference performance pitfalls with ErrorProne.NET](https://devblogs.microsoft.com/premier-developer/avoiding-struct-and-readonly-reference-performance-pitfalls-with-errorprone-net/)

[The ‘in’-modifier and the readonly structs in C#](https://devblogs.microsoft.com/premier-developer/the-in-modifier-and-the-readonly-structs-in-c/)

[本文所有源码](https://sharplab.io/#gist:5df6f47fe62ae0a766540f16dc23544e)
