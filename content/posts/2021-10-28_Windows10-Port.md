---
title: "Windows 10 解决端口被占用问题"
date: 2021-10-28T09:53:28+08:00
draft: false
tags: ["Windows 10","端口","hyper-V"]
categories: ["TIL","port"]
---
前几天启动hugo server时提示1313端口被占用，给分配了一个随机端口，打开自己写的程序，mqtt默认的1883端口也被占用，使用
```cmd
netstat -ano | findstr 1883
```
没有任何返回
一番Google后得知某些端口被Hyper-V保留了。
解决方法：
1. 关闭Hyper-V
    ```cmd
    dism.exe /Online /Disable-Feature:Microsoft-Hyper-V
    ```
2. 重启后设置你想保留的端口，这样Hyper-V就不能再占用
    ```cmd
    # 排除ipv4动态端口占用 startport 起始端口 numberofports 端口数
    netsh int ipv4 add excludedportrange protocol=tcp startport=<your port> numberofports=1
    ```
    对于1313和1883端口，我执行了两次此命令：
    ```cmd
    netsh int ipv4 add excludedportrange protocol=tcp startport=1313 numberofports=1

    netsh int ipv4 add excludedportrange protocol=tcp startport=1883 numberofports=1
    ```
3. 重新启用Hyper-V,需要重启
    ```cmd
    dism.exe /Online /Enable-Feature:Microsoft-Hyper-V /All
    ```

再次查看端口排除范围（被系统或者我们自己保留的端口）
```cmd
λ netsh int ipv4 show excludedportrange tcp

协议 tcp 端口排除范围

开始端口    结束端口
----------    --------
        80          80
      1313        1313     *
      1883        1883     *
      1899        1998
      1999        2098
      2108        2207
      2208        2307
      2308        2407
      2422        2521
      2522        2621
      2622        2721
      2722        2821
      2822        2921
      5357        5357
     45000       45000
     50000       50059     *

* - 管理的端口排除。
```
带*就是我上面添加的。

如果要取消保留端口，可以执行
```cmd
netsh int ipv4 delete excludedportrange protocol=tcp startport=<your port> numberofports=1
```