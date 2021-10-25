---
title: "Firefox 70 配置记录"
date: 2019-10-23T14:20:23+08:00
tags: ["firefox"]
categories: ["技术"]
draft: false
---
最近又开始使用Firefox，速度还是可以的，但要想用起来顺手、顺眼还需要一些配置，在此记录一下<!--more-->

## 使用紧凑布局
1. 在标签最右空白处点击右键，点击 “定制…”，将地址栏左右的弹性空白拖到下方
2. 下方工具栏勾选 书签工具栏
3. 下方密度选择紧凑

## 去掉地址栏右边的pocket图标
地址栏输入 about:config,搜索 pocket，将 extensions.pocket.enabled 改为false

## 禁用标签滚动
标签达到一定数量后，只显示一部分标签，左右会出现箭头，类似滚动条 地址栏输入 about:config,将 browser.tabs.tabMinWidth 改为 0

## 修改个人配置文件位置
地址栏输入 about:profiles , 创建新的配置文件，关闭Firefox后将 APPDATA%\Mozilla\Firefox\Profiles\ 内的文件移动到新位置，启动firexfox，新的profile成文默认旧的可以删除了。

## 安装扩展
* ublock origin
* bitwarden
* 暴力猴
* Tree Style Tab 显示树状标签
