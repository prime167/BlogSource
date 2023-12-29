---
title: "git 使用includeIf配置多身份隔离"
date: 2021-10-27T09:53:28+08:00
draft: false
tags: ["git",".gitconfig","includeif"]
categories: ["TIL"]
---
## 问题
作为开发者，我们会有很多项目，公司项目，开源项目。对于不同的项目，我会使用不同的身份（user.name和user.email组合）：
* 公司的项目使用自己的名字和公司的邮箱: `张三 <zhansan@somecorp.com>`
* 开源项目我会使用昵称和私人邮箱: `Jack <xxx+xxx@users.noreply.github.com>`

在~/.gitconfig（Windows 为%USERPROFILE%.gitconfig）只能声明一组name和email组合作为默认身份。虽然可以在每个repo下简单的通过运行 `git config user.email <EMAIL>` 和 `git config user.name <NAME>`命令来更改，问题是对于每个项目我都要运行这两个命令，难免有时候也会忘了设置，导致使用了错误的身份提交。

幸运的是，git为我们提供解决此问题的方法

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

## 解决方案
加入我们有以下两个目录
```
|-Work
|-Personal
```
用公司身份提交的项目都存放在work目录，用个人身份提交的项目都存放在personal目录，
在你的~/.gitconfig里，可以使用includeif，根据当前repo的所在目录来加载另一个gitconfig的文件内容：
```.gitconfig
...
[includeIf "gitdir/i:E:/Work/]
    path =.gitconfig-work

[includeIf "gitdir/i:E:/Personal/"]
    path =.gitconfig-personal
...
```
.gitconfig-work：
```.gitconfig
[user]
    name = 张三
    email = zhangsan@somecorp.com
```
.gitconfig-personal：
```.gitconfig
[user]
    name = Jack
    email = xxx+xxx@users.noreply.github.com
```
这样，:E:/Work/下的所有项目都会使用张三这个身份，E:/Personal/下的所有项目则使用Jack这个身份。

## 举例
除了公司的工作项目，我目前还使用用GitHub，上面有我一些小的项目和这个托管在GitHub Pages 上的blog，我的配置如下
```.gitconfig
[include]
	path =.gitconfig-personal

[includeIf "gitdir/i:E:/work/git/"]
	path =.gitconfig-work
```
这样，把默认身份为个人身份。除了E:/work/git/下的项目用工作身份提交外，其他所有目录的都用个人身份提交。

## GUI 支持
* Sourcetree 完美支持
* Git Extensions：commit 对话框左下角始终显示默认的用户信息，但是实际签入的时候是调用的底层的系统git，所以能够使用正确的用户签入。

参见：
* [Author information incorrect when using multiple GitHub accounts (via conditional includes)](https://github.com/gitextensions/gitextensions/issues/8374)
* [Support for .gitconfig conditional includes](https://github.com/gitextensions/gitextensions/issues/5492)

## 总结
使用 **includeif**，可以按照文件夹为不同的组织、公司、项目指定不同的身份，不需要每次都给新的repo指定 `user.name` 和 `user.email`。

## 参考
[Conditional includes](https://git-scm.com/docs/git-config#_conditional_includes)
