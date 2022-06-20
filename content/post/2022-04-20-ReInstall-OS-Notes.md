---
title: "重装操作系统备忘录"
date: 2022-04-20T14:57:20+08:00
tags: ["windows 10","操作系统"]
categories: ["维护"]
draft: false

---

## 缘起
公司电脑升级到Windows 10 21H2后出现了各种问题：

* 加密软件每天不定时失效，需要重启电脑才能解决
* 电脑无法休眠
* WinCvs 闪退
* Visual Studio 2019 & 2022 拷贝文本经常出现卡死

于是决定重装操作系统。由于之前吃过亏，我是先安装Windows 10 1607，安装加密软件和WinCvs后又升级到21H1，经过几天的使用，没有出现上述的问题，以后就在这一版本养老了。

## 备份
### 1、IP及DNS设置
### 钉钉聊天记录 

    C:\Users\Administrator\AppData\Roaming\DingTalk
### 2、微信聊天记录
### 3、桌面快捷方式
### 4、环境变量
### 5、浏览器的UserData
由于Google的限制，基于Chromium的浏览器无法做到完全的Portable，重装系统后扩展需要通过同步重新安装。
#### 5.1 Edge    
    * AppData\Local\Microsoft\Edge\User Data
    * AppData\Local\Microsoft\Edge Beta\User Data
    * AppData\Local\Microsoft\Edge Dev\User Data
    * AppData\Local\Microsoft\Edge SxS\User Data
#### 5.2 Google Chrome   
    * AppData\Local\Google\Chrome\User Data
    * AppData\Local\Google\Chrome Beta\User Data
    * AppData\Local\Google\Chrome dev\User Data
    * AppData\Local\Google\Chrome SxS\User Data
## 安装软件

## 调整系统设置

### 隐藏此电脑下的文件夹
[如何隐藏Win10「此电脑」中的「3D对象、视频、图片、文档、下载、音乐、桌面」文件夹](https://fengooge.blogspot.com/2019/01/how-to-hide-the-useless-folders-in-Windows-10.html)
