---
title: "修改NuGet全局缓存路径"
date: 2019-12-26T16:10:06+08:00
tags: ["nuget",".NET"]
categories: ["技术"]
draft: false
---
修改NuGet全局缓存路径<!--more-->

Nuget的全局缓存路径默认在

* %userprofile%.nuget\packages
* %localappdata%\NuGet\v3-cache
随着时间的推移，这个文件夹会占用大量的磁盘。可以通过添加环境变量的方式把它移到其他的盘下：

## 通过环境变量
* 添加新变量 **NUGET_PACKAGES** 值设置为新位置，如 “D:\NugetCache”

* 添加新变量 **NUGET_HTTP_CACHE_PATH** 值设置为新位置，如 “D:\NugetHttpCache”

* 重启系统后将原文件夹内的内容移到新位置

## 修改 %appdata%/nuget下的nuget.config
%userprofile%.nuget\packages 还可以通过修改用户nuget.config实现

添加 **globalPackagesFolder** 节点
```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <config>
    <add key="globalPackagesFolder" value="D:\NugetCache" />
  </config>
</configuration>
```
## 注意
环境变量的优先级较高，二者同时存在的话，前者会覆盖后者。

## 参考
* [Managing the global packages, cache, and temp folders](https://docs.microsoft.com/en-us/nuget/consume-packages/managing-the-global-packages-and-cache-folders)