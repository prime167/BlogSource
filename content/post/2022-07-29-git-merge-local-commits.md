---
title: "如何合并多个git commits"
date: 2022-07-29T14:04:20+08:00
tags: ["git","rebase"]
categories: ["技术"]
draft: false

---

git的工作区、暂存区、版本库的区分，让我们在编码的时候以渐进的方式稳步的把代码写出来。

我的习惯是先在工作区和暂存区迭代，某个部分写好了用添加到暂存区，进行下一步；发现工作区太乱了或者这样写不行，可以丢弃工作区的更改。

工作区达到一定的阶段，就提交一下。整个功能完成后可能是下面这样：
```bash
* 7e7af1b - (HEAD -> feat/addUser)完成
* 215353c - 修改自测bug
* 5fcfa4f - 完成功能
* 34024f7 - 完成界面设计
* 288ebcb - 开始添加用户功能
* b36071d - (origin/main)登录功能               <----远程
* 25b848d - init
```
直接合并到main稍显杂乱，先用git rebase把提交合并一下：
要合并的是最后5个提交，使用命令
```bash
git rebase -i HEAD~5
```

git 弹出编辑器
```bash
pick 288ebcb 开始添加用户功能
pick 34024f7 完成界面设计
pick 5fcfa4f 完成功能
pick 215353c 修改自测bug
pick 7e7af1b 完成

# Rebase b36071d..7e7af1b onto b36071d (5 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup [-C | -c] <commit> = like "squash" but keep only the previous
# 
```
根据下面的提示，保留第一个(最上面提交)，把后面的提交合并到第一个，下面的pick改成s
```bash
pick 288ebcb 开始添加用户功能
s 34024f7 完成界面设计
s 5fcfa4f 完成功能
s 215353c 修改自测bug
s 7e7af1b 完成

# Rebase b36071d..7e7af1b onto b36071d (5 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup [-C | -c] <commit> = like "squash" but keep only the previous
# 
```

关闭后弹出编辑最终commit message

```bash
# This is a combination of 5 commits.
# This is the 1st commit message:

开始添加用户功能

# This is the commit message #2:

完成界面设计

# This is the commit message #3:

完成功能

# This is the commit message #4:

修改自测bug

# This is the commit message #5:

完成

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# Date:      Fri Jul 29 14:14:06 2022 +0800
```

改为如下，关闭
```bash
# This is a combination of 5 commits.
# This is the 1st commit message:

添加用户功能

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# Date:      Fri Jul 29 14:14:06 2022 +0800
```

提示rebase成功，再次运行git log

```bash
* ed8a955 - 添加用户功能
* b36071d - 登录功能
* 25b848d - init
```
大功告成，合并到主分支，推送，完美。

如果功能比较大，我提交了好几十次，那还得一个一个数吗？可以用
```bash
git rebase -i [commit-hash]
```
这里的commit-hash是要合并的所有提交的**前一个**commit，比如上一个例子里，我要使用
```bash
git rebase -i b3706
```
下面的步骤完全一样，不再赘述。

