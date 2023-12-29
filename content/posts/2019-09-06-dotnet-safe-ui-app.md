---
title: "编写线程安全的UI程序"
date: 2019-09-06T16:43:48+08:00
tags: [".NET","thread"]
categories: ["技术"]
draft: false
---
本篇讲一下如何编写线程安全的Winform 程序<!--more-->
## 有问题的代码
一个很简单的功能，Winform上实时显示当前时间：
```csharp
public partial class Form1 : Form
{
    private System.Threading.Timer _timer;
    public Form1()
    {
        InitializeComponent();
    }

    private void Form1_Load(object sender, EventArgs e)
    {
        _timer = new System.Threading.Timer(UpdateTime, null, 0, 20);
    }

    private void UpdateTime(object state)
    {
        lblTime.Text = DateTime.Now.ToString("hh:mm:ss");
    }
}
```
F5 运行，出错了：

![ex](/images/exception.png)