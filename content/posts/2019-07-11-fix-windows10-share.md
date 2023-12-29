---
title: "解决WinCE6.0无法访问Win10共享文件夹问题"
date: 2019-07-11T17:40:12+08:00
draft: false
tags: ["wince","共享配置"]
categories: ["技术"]
---

公司主要是用WinCE6.0做嵌入式开发，有时需要把文件发送到PC机器，但最近有一台1803的Win10总是报"error 53 找不到网络路径"的错误 。 <!--more-->

解决过程：

* TCP/IP NetBIOS Helper 服务已开启
* 网卡属性里的 “Microsoft 网络客户端” 存在并勾选
* 网卡属性里的 “Microsoft 网络的文件和打印机共享” 存在并勾选

最后定位到原因：[SMB](https://www.anquanke.com/post/id/97002) 1.0/CIFS 共享文件支持功能没有开启，这是一很老的网络共享协议，漏洞很多，默认是关闭的。

![smbv1](/images/smbv1.png)

