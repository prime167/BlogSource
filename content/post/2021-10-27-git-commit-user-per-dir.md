---
title: "git 使用includeIf配置多用户隔离"
date: 2021-10-27T09:53:28+08:00
draft: false
tags: ["git",".gitconfig","includeif"]
categories: ["TIL"]
---
## 起因
前天重新配置blog，在重新编写blog并推送到GitHub之后，发现使用的是公司的用户名和邮箱，原因是创建git repo后, commit 之前忘记修改.git/config,并添加GitHub用户名
```
[user]
    name = xxx
    email = xxx+xxx@users.noreply.github.com
```
无奈只好重新来一遍：删除GitHub仓库，删除本地.git 目录，git init，添加上述配置，提交，重新推送
## git 配置文件层级
如上所述，在 git 中，有三个层级的配置文件：

* 系统级: /etc/gitconfig，作用于系统中所有用户的 git 配置；
* 用户级: $HOME/.gitconfig（Windows 为 **%USERPROFILE%.gitconfig** 即 **C:\Users\[CurrentLoginUser]\ .gitconfig** ），作用于用户的 git 配置；
* Repo 级: .git/config，作用于Repo 中。
如果有相同的配置，按照 Repo > 用户 > 系统 的优先级获取配置。
## [includeIf]
从 git 2.13.0 开始，git 配置文件开始支持 Conditional Includes 的配置。通过设置 includeIf.<condition>.path，可以向命中 condition 的 git 仓库引入 path 指向的一个 git 配置文件中配置。

[includeIf] 的语法如下，<keyword> 为关键词，<data> 是与关键词关联的数据， 具体意义由关键词决定。

[includeIf "<keyword>:<data>"]
    path = path/to/gitconfig
其中支持的 keyword 有：

gitdir: 其中 <data> 是一个 glob pattern 如果代码仓库的.git目录匹配 <data> 指定的 glob pattern，那么条件命中；
gitdir/i：gitdir的大小写不敏感版本。
onbranch：其中 <data> 是匹配分支名的一个glob pattern。 假如代码仓库中分支名匹配 <data>，那么条件命中。
就我们的需求，使用 gitdir 完全可以。

## 例子
我们平时大部分时间开发公司内部的项目，有时摸鱼开发自己子GitHub上的项目或者写博客（并不推荐）,代码放置目录如下：
* 公司项目放在 E:\work\git\目录下
* 个人项目放在 E:\Code\  目录下
* 个人博客放在 E:\Data\Blog\目录下

个人项目与公司项目的差异点在：第一、使用的邮箱名不同， 个人项目会使用个人邮箱，公司项目使用公司邮箱。

首先配置用户级的.gitconfig，在这里，我把默认用户配置为GitHub用户
```
[user]
    name = xxx
    email = xxx+xxx@users.noreply.github.com
```
然后在这之后添加公司使用的用户
```
# E:/work/git/ 下面的所有仓库引入 `.gitconfig-work` 中的配置
[includeIf "gitdir/i:E:/work/git/"]
    path = .gitconfig-work
```
最后创建公司项目统一的配置文件%USERPROFILE%.gitconfig-work：

```
[user]
    name = 张三
    email = zhangsan@somecorp.com
```
这样，除了E:/work/git/ 下面的repo使用公司的用户外，其他目录都是用GitHub用户。你可以根据自己的实际情况设置默认用户、创建不同情景下使用的gitconfig