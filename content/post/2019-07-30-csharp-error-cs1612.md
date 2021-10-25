---
title: "C# 编译错误 CS1612：无法修改“xxx”的返回值，因为它不是变量"
date: 2019-07-30T15:51:59+08:00
draft: false
tags: ["csharp","CS1612"]
categories: ["技术"]
---

看似简单的问题，背后涉及了很多基础知识。<!--more-->

## 代码 ##

```csharp
using System;

namespace Cs1612Demo
{
    class Program
    {
        static void Main(string[] args)
        {
            Player p = new Player();
            p.ShowLocation();
            p.Location.x = 6; // CS1612
            p.Location.y = 2; // CS1612
            p.ShowLocation();
            List<Point> _locations = new List<Point>();
            // add..
            _locations[0].x = 3;// CS1612
        }
    }

    struct Point
    {
        public float x;
        public float y;
    }

    class Player
    {
        public Point Location { get; set; }

        public void ShowLocation()
        {
            Console.WriteLine(Location.x + "," + Location.y);
        }
    }
}
```

## 分析 ##

上面的代码不会通过编译，错误为：

```nohighlight
错误    CS161    无法修改“Player.Location”的返回值，因为它不是变量*

错误    CS1612    无法修改“List<Point>.this[init]”的返回值，因为它不是变量*
```

属性的get方法和List的索引返回的是Location的副本，而不是Location的引用。由于这个副本不保存在任何变量中，所以修改值并不会保存回Location变量，赋值没有意义。

消除错误的方法：

1. 将Point改为class。但由于Point是 C#的内置类型，这种方法并大多数情况下并不可行。

2. 去掉 *{ get; set; } *将Location 改为public field，这也不推荐。Property较之Field有很多优点

   * 封装底层field
   * set中可以包含验证逻辑
   * field不能用于绑定

3. 如前所述，return _location返回的是一个临时副本，对其修改没意义。那我们就先把它赋给一个变量，修改后再赋回去：

   ```csharp
    //p.Location.x = 6; // 报错 CS1612
    //p.Location.y = 2; // 报错 CS1612
    var location = p.Location;
    location.x = 6;
    location.y = 2;
    p.Location = location;

    var temp = _locations[0];
    temp.x = 3;
    _locations[0] = temp;
   ```

4. 有的struct很大，为了避免按值传递带来的性能损耗，C# 7.0新增了ref returns，允许开发者返回值类型的引用，并直接对其修改：

   ```csharp
   using System;

    namespace Cs1612Demo
    {
        class Program
        {
            static void Main(string[] args)
            {
                Player p = new Player();
                p.ShowLocation();
                p.Location.x = 6;
                p.Location.y = 2;
                p.ShowLocation();
            }
        }

        struct Point
        {
            public float x;
            public float y;
        }

        class Player
        {
            Point _location;

            public ref Point Location { get { return ref _location; } }

            public void ShowLocation()
            {
                Console.WriteLine(Location.x + "," + Location.y);
            }
        }
   ```

这样，返回的就是_location 的引用，可以像上面改成class一样修改了。注意这里需要去掉setter，否则会报错误" *CS8147    按引用返回的属性不能有 set 访问器* "。因为返回的是引用，可以任意修改，也就没有必要保留set访问器了。

## 参考链接 ##

[Compiler Error CS1612](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-messages/cs1612)

[Ref returns and ref locals](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/ref-returns)

[What's new in C# 7.0](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-7)

[C# 7 Series, Part 7: Ref Returns](https://blogs.msdn.microsoft.com/mazhou/2017/12/12/c-7-series-part-7-ref-returns/)


