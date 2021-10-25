---
title: ".NET 中的 timer"
date: 2019-09-23T11:47:39+08:00
tags: [".NET","csharp","timer"]
categories: ["技术"]
draft: false
---
今天简单介绍一下 .NET framework中的timer<!--more-->
## 概述
目前，.NET framework中有如下几种 timer：

1. System.Timers.Timer
1. System.Threading.Timer
1. System.Windows.Forms.Timer
1. System.Windows.Threading.DispatcherTimer
1. System.Web.UI.Timer

其中前两个是通用的，即可用于客户端，也可用于服务器；第三个用于winform下，第四个用于WPF下，第五个是传统的Asp.NET Page下的控件

## System.Windows.Forms.Timer
先看这个最简单的。这是Winform工具箱里的一默认组件，设置一个时间间隔，每个时间间隔要触发的时间，用Start()方法启动即可

```csharp
public partial class Form1 : Form
{
    private int _count;
    private readonly Timer _timer = new Timer();
    private readonly Label _lblCount = new Label();

    public Form1()
    {
        InitializeComponent();
        Size = new Size(450, 450);
        Controls.Add(_lblCount);
        _lblCount.Location = new Point(200, 200);
        _timer.Interval = 100;
        _timer.Tick += timer1_Tick;
    }

    private void Form1_Load(object sender, EventArgs e)
    {
        _timer.Start();
    }

    private void timer1_Tick(object sender, EventArgs e)
    {
        _count++;
        _lblCount.Text = _count.ToString("0000");
        if (_count >= 30)
        {
            _timer.Stop();
        }
    }
}
```

当然缺点也很明显：

运行在UI线程，如果每个间隔的操作耗时较长，就会造成阻塞，表现为界面卡顿，影响用户体验

精度较低，最低只能到55毫秒

## System.Windows.Threading.DispatcherTimer
这个和System.Windows.Forms.Timer类似,不过是WPF下使用的
```csharp
public partial class MainWindow : Window
{
    private int _count = 0;
    private readonly DispatcherTimer _timer = new DispatcherTimer();

    public MainWindow()
    {
        InitializeComponent();
        _timer.Interval = TimeSpan.FromMilliseconds(100);
        _timer.Tick += _timer_Tick;
    }

    private void _timer_Tick(object sender, EventArgs e)
    {
        _count++;
        lblCount.Content = _count.ToString("0000");
        if (_count >= 30)
        {
            _timer.Stop();
        }
    }

    private void MainWindow_OnLoaded(object sender, RoutedEventArgs e)
    {
        _timer.Start();
    }
}
```
缺点：

运行在UI线程，耗时操作也会造成界面卡顿
精度较低，因为是再Dispatcher队列中运行，受到自身和队列中其他事件的影响，不能保证严格按照interval触发事件

## System.Threading.Timer
根据时间间隔在线程池中执行操作 (关于跨线程操作，见[上一篇博文](/post/2019-09-06-dotnet-safe-ui-app))
```csharp
public partial class Form3 : Form
{
    private int _count;
    private System.Threading.Timer _timer;
    private readonly Label _lblCount = new Label();
    private readonly SynchronizationContext _context;

    public Form3()
    {
        InitializeComponent();
        _lblCount.Text = "0000";
        _context = SynchronizationContext.Current ?? new SynchronizationContext();
        Size = new Size(450,450);
        Controls.Add(_lblCount);
        _lblCount.Location = new Point(200, 200);
    }

    private void UpdateCount(object state)
    {
        _count++;
        _context.Send(delegate { _lblCount.Text = _count.ToString("0000"); }, null);
        if (_count >= 30)
        {
            _timer.Change(Timeout.Infinite, Timeout.Infinite);
        }
    }

    private void Form3_Shown(object sender, EventArgs e)
    {
        _timer = new System.Threading.Timer(UpdateCount, null, 1000, 100);
    }
}
```
## System.Timers.Timer

通过MSDN文档可以知道，该类继承了System.ComponentModel.Component,并实现了System.ComponentModel.ISupportInitialize结果，所以它也可以被添加到工具箱里

![img](/images/system.timers.timer.png)

通过分析[源码](https://referencesource.microsoft.com/#System/services/timers/system/timers/Timer.cs,897683f27faba082)可以发现，它是对 System.Threading.Timer的包装

用法：
```csharp
public partial class Form2 : Form
{
    private int _count;
    private readonly System.Timers.Timer _timer = new System.Timers.Timer();
    private readonly Label _lblCount = new Label();

    public Form2()
    {
        InitializeComponent();
        Size = new Size(450,450);
        Controls.Add(_lblCount);
        _lblCount.Location = new Point(200, 200);
        _timer.Interval = 100;
        _timer.SynchronizingObject = this;
        _timer.Elapsed += _timer_Elapsed;
    }

    private void _timer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
    {
        _count++;
        _lblCount.Text = _count.ToString("0000");
        if (_count >= 30)
        {
            _timer.Stop();
        }
    }

    private void Form1_Load(object sender, EventArgs e)
    {
        _timer.Start();
    }
}
```

如果设置了SynchronizingObject，则调用该控件的BeginInvoke方法
```csharp
private void MyTimerCallback(object state) {
    // System.Threading.Timer will not cancel the work item queued before the timer is stopped.
    // We don't want to handle the callback after a timer is stopped.
    if( state != cookie) { 
        return;
    } 
    
    if (!this.autoReset) {
        enabled = false;
    }

    FILE_TIME filetime = new FILE_TIME();
    GetSystemTimeAsFileTime(ref filetime);
    ElapsedEventArgs elapsedEventArgs = new ElapsedEventArgs(filetime.ftTimeLow, filetime.ftTimeHigh); 
    try {                                            
        // To avoid ---- between remove handler and raising the event
        ElapsedEventHandler intervalElapsed = this.onIntervalElapsed;
        if (intervalElapsed != null) {
            if (this.SynchronizingObject != null && this.SynchronizingObject.InvokeRequired)
                this.SynchronizingObject.BeginInvoke(intervalElapsed, new object[]{this, elapsedEventArgs});
            else                        
                intervalElapsed(this,  elapsedEventArgs);                                   
        }
    }
    catch 
    {
    }
}
```
## System.Web.UI.Timer
略

源码

[prime167/DotNetTimers](prime167/DotNetTimers)