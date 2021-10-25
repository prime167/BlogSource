---
title: "git worktree 命令的使用"
date: 2019-07-26T14:05:29+08:00
draft: false
tags: ["git","git worktree", "scm"]
categories: ["技术"]
---

使用 git worktree **同时** 签出多个分支，提高开发效率，节省磁盘空间。<!--more-->

## 概念 ##

git 最强大也最为人称道的就是它的分支功能，现在也有了很多成熟的分支模型，比如常用的master/dev/feature/hotfix 模型。

正常情况下，我们用 **git init** 或者 **git clone** 命令 新建一个repo，目录内有一个 .git文件夹 和我们要跟踪的文件，该目录就是我们的 *工作目录* *working directory* ，也就是 *working tree* 。我们要切换分支时，就用 **checkout** 命令：

```bash
git checkout hotfix-2
```

但是随着时间的推移，我们的repo越来越庞大，切换分支变得越来昂贵：

* git checkout 命令本身需要处理很多的文件，导致很大的磁盘IO开销
* IDE 需要重新索引项目文件，特别是两个分支之间差别很大时。
* 跑耗时的单元测试，无法切换分支，只能等着。

虽然我们也可以通过克隆多份，每一份checkout不同的分支的方式来解决上面列出的问题，但这会引入新的问题：

* 占用较多的磁盘空间，因为每一份克隆都有一个.git 文件夹。
* 为了保持多个克隆间的同步，需要在不同的文件夹拉取相同的变更很多次。

针对这些问题，git在2.5 版中加入了 *worktree* 子命令,这样就可以把一个或多个分支checkout到单独的文件夹，但这些文件夹是关联到现有的版本库的，他们共享一个.git 文件夹。

## 使用方法 ##

```bash
# 先初始化一个 repo
mkdir projectX
cd projectX
touch readme.md
git init
git add .
git commit -m init
git remote add origin https://github.com/prime167/projectX.git
git push

# 初始化 dev 分支
git checkout -b dev
touch a.cs
git add .
git commit -m "add a.cs"
git push

# 从现有本地分支新建一个worktree
git checkout master
git worktree add ../projectX-dev dev 

# 从现有tag新建一个worktree
git worktree add ../projectX-v0.1 v0.1 

#从现有远程分支新建一个worktree
git fetch
git worktree add ../projectX-hotfix1 hotfix1

# 新建分支并添加worktree，最后的master为基础commit-ish，如果不指定，则默认为HEAD
git worktree add -b feature-A ../projectX-feature-A master

#列出worktree
git worktree list

# 移动worktree (git 2.17 新增)
git worktree move ../projectX-feature-hotfix2 ../projectX-hotfix2 

# 删除worktree的话，直接删除目录即可
rm -rf ../projectX-hotfix2
git worktree prune
```

## 技术细节 ##

以 git worktree add ../projectX-dev dev 为例：

* 在版本库的 .git/worktrees 下新建一个目录projectX-Dev, *gitdir* 文件指向worktree内的 *.git* 文件

   ```nohighlight
   D:/git/projectX-dev/.git
   ```

* 新建一个与ProjectX平级的的projectX目录，包括dev分支的内容和一个 *.git* 文件，内容为

   ```nohighlight
   gitdir: D:/git/projectX/.git/worktrees/projectX-dev
   ```

git worktree move ../projectX-Dev ../projectX-Dev1 命令只会更改 *gitdir* 的内容到新位置，其目录名并不会更改；相应的，worktree内的 *.git* 文件的内容也不会更改。所以以后手动改了worktree的目录名后，如果没有强迫症的话只改 *gitdir* 的内容就可以了。

## 限制 ##

* 一个分支不能同时迁出到多个worktree
* 对子模块的支持不完整

## 总结 ##

本篇，我们学习了使用 *worktree* 进行多分枝并行开发的方法和优点，包括但不限于：

* 可以快速进行多分枝并行开发、测试
* 提交可以在同一个repo中共享
* 和再次克隆项目相比，节省了硬盘空间
* 方便分支间的比较和文件操作
* 避免忘记切换分支造成的拷错 dll或者exe的尴尬。

## 参考链接 ##

1. [git-worktree - Manage multiple working trees](https://git-scm.com/docs/git-worktree/)

2.[Git 2.5, including multiple worktrees and triangular workflows](https://github.blog/2015-07-29-git-2-5-including-multiple-worktrees-and-triangular-workflows/)