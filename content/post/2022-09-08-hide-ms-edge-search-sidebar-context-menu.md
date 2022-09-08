---
title: "如何隐藏Edge浏览器的在侧边栏搜索菜单"
date: 2022-09-08T10:54:20+08:00
tags: ["edge","浏览器"]
categories: ["技术"]
draft: false

新的基于Chromium的Edge浏览器是不错，可是微软老师往里塞乱七八糟的的东西，好在大部分都可以关闭。今天发现了[关闭侧边栏搜索右键菜单的方法](https://www.reddit.com/r/edge/comments/ncrbbm/comment/gya3ukg/)

快捷方式**目标**后边追加

```
 --disable-features=msSidebarSearchAfterSearchWebFor,msSidebarSearchBeforeSearchWebFor
```
确定重启即可
