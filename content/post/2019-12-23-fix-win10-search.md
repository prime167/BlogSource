---
title: "修复Windows 10 搜索功能"
date: 2019-12-23T15:05:20+08:00
tags: ["windows 10","search"]
categories: ["维护"]
draft: false

---
很多人Win10 升级到1909后，点击搜索按钮，输入两个字符，搜索界面就消失了，非常不便。下面给出解决这个问题的方法。<!--more-->

打开日志查看器，有如下错误日志
```
错误应用程序名称: SearchUI.exe，版本: 10.0.18362.418，时间戳: 0x5d995690
错误模块名称: ConstraintIndex.Search.dll，版本: 10.0.18362.207，时间戳: 0x5d0b11a3
异常代码: 0xc0000005
错误偏移量: 0x00000000000b4cb9
错误进程 ID: 0x3a2c
错误应用程序启动时间: 0x01d5b6f59b9c785c
错误应用程序路径: C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe
错误模块路径: C:\Windows\System32\ConstraintIndex.Search.dll
报告 ID: f1a471d4-1661-4505-9379-6ad5a76cd03e
错误程序包全名: Microsoft.Windows.Cortana_1.13.0.18362_neutral_neutral_cw5n1h2txyewy
错误程序包相对应用程序 ID: CortanaUI
```
用Unlocker或者火绒的文件粉碎器接触文件夹 *:\Windows\SystemApps\Microsoft.Windows.Cortana_* * 的占用, 重命名或者直接删除后再次点击任务栏的搜索按钮，几次后Windows就会重建文件夹，搜索功能就好了。