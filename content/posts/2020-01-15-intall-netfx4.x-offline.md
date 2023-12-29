---
title: "在Windows 7 SP1 下离线安装 .NET Framework 4.8"
date: 2020-01-15T16:23:19+08:00
tags: ["dotnet"]
categories: ["技术"]
draft: false
---
在未联网的计算机上安装.NET Framework 4.6.1, 4.6.2, 4.7, 4.8 可能会因为缺少根证书失败<!--more-->

昨天在一台未联网的Windows 7 SP1 上安装 .NET Framework 4.8,报错

>无法建立到信任根颁发机构的证书链

英文系统下的提示为

>A certificate chain could not be built to a trusted root authority

意思是我在你的电脑上没有我需要的根证书，我尝试联网下载，但是又连不上。

解决方法： 最简单的方法就是联网让安装程序自己下载、导入证书（确保能连接 http://ctldl.windowsupdate.com/msdownload/update/v3/static/trustedr/en）。

如果实在无法联网，就需要下面的步骤了：

1、下载证书：MicrosoftRootCertificateAuthority2011.cer

2、安装：

  1. 开始→运行→MMC
  2. 文件 → 添加删除管理单元 (Ctrl+M)
  3. 证书 → 计算机帐户 -> 本地计算机
  4. 展开到：证书 → 受信任的根证书颁发机构 → 证书
  5. 右击展开菜单，所有任务 → 导入
  6. 选择刚才下载好的MicrosoftRootCertificateAuthority2011.cer，确定

在Windows 7 下离线安装Visual Studio 2019也会遇到证书问题

https://docs.microsoft.com/zh-cn/visualstudio/install/install-certificates-for-visual-studio-offline?view=vs-2019
