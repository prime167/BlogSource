---
title: "如何让MsBuild自动拷贝和更新System.Data.SQLite的运行时文件夹X64和X86"
date: 2022-06-21T16:42:20+08:00
tags: ["nuget","System.Data.SQLite","dotnet"]
categories: ["技术"]
draft: false

---

## 问题
假设一个工程有如下的结构

----Demo sln

--------WPF

--------DataAccess


* WPF 引用 DataAccess 项目

* DataAccess项目引用nuget包System.Data.SQLite，

编译后

* DataAccess输出文件夹存在System.Data.SQLite文件和X646和X86，内含SQLite.Interop.dll
* WPF输出文件夹仅存在System.Data.SQLite文件，需要手动从DataAccess输出文件夹拷贝X646和X86文件夹

而且每次升级System.Data.SQLite nuget包后都需要重新拷贝一次，否则会因为版本不匹配而出现异常。

## 解决方法
在DataAccess.csproj 中添加
```xml
  <PropertyGroup> 
    <ContentSQLiteInteropFiles>true</ContentSQLiteInteropFiles>
    <CopySQLiteInteropFiles>false</CopySQLiteInteropFiles>
    <CleanSQLiteInteropFiles>false</CleanSQLiteInteropFiles>
    <CollectSQLiteInteropFiles>false</CollectSQLiteInteropFiles>
  </PropertyGroup>
```

## 参考
[SQLite.Interop.dll files does not copy to project output path when required by referenced project](https://stackoverflow.com/a/32639631/65994)
[Change nuget build targets to use 'Content' rather than 'Copy' and 'Delete'](https://system.data.sqlite.org/index.html/info/2ed3cad9cc9d5938808816bbc6da92366cd5a4dc)