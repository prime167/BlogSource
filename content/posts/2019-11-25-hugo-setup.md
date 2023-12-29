---
title: "Hugo 配置记录"
date: 2019-08-07T16:36:46+08:00
lastmod: 2021-10-22
draft: false
tags: ["hugo","meta"]
categories: ["blog"]
---
新博客配置的七七八八了，记录一下过程和未解决问题。<!--more-->
## 更新记录
* 2019/8/7 配置完成
* 2019/10/18 添加Gitmen评论系统
* 2019/11/25 添加 .nojekyll 文件解决以“.”开头的tag页面显示404问题
* 2020/6/16 内容过期提醒
* 2021/10/25 重写丢失的blog，更换maupassant主题，配置utteranc评论系统
* 2023/12/29 主题更换为 PaperMod

## 注册GitHub

这个没什么好说的，输入用户名、密码、邮箱创建账户就可以了。

## 创建博客 repo

* repo 必须设置位public
* repo 的名字必须是[github用户名].github.io

## 下载hugo

1. 到hugo的 [github releases](https://github.com/gohugoio/hugo/releases) 页面下载最新版本
2. 解压到某个目录，例如 *E:\Data\blog\hugo*
3. 将此目录添加到环境变量,方便以后运行。推荐使用 [Rapid Environment Editor(RapidEE)](https://www.rapidee.com/en/download)

## 创建blog

在 *E:\Data\blog* 下运行

```bash
hugo new site myBlog
```

会在 *E:\Data\blog* 下生成目录 *myBlog*

## 设置主题

[hugo主题网站](https://themes.gohugo.io/) 有很多网站可选,找打自己喜欢的某个主题，根据Installation提示克隆到myBlog\themes文件夹，比如我用的是even，就在myblog目录执行

```
git clone https://github.com/olOwOlo/hugo-theme-even themes\even
```

然后将themes\even\\exampleSite\config.toml 拷贝到根目录

## 基本配置

用notepad++或者vscode打开config.toml,根据注释修改一些必要的设置:

```toml
baseURL = "https://xxxxxx.github.io"
languageCode = "zh-cn"
defaultContentLanguage = "zh-cn"                             # en / zh-cn / ... (This field determines which i18n file to use)
title = "我的博客"
preserveTaxonomyNames = true
enableRobotsTXT = true
enableEmoji = true
theme = "even"
enableGitInfo = false # use git commit log to generate lastmod record # 可根据 Git 中的提交生成最近更新记录。

# Syntax highlighting by Chroma. NOTE: Don't enable `highlightInClient` and `chroma` at the same time!
pygmentsOptions = "linenos=table"
pygmentsCodefences = true
pygmentsUseClasses = true
pygmentsCodefencesGuessSyntax = true

hasCJKLanguage = true     # has chinese/japanese/korean ? # 自动检测是否包含 中文\日文\韩文
paginate = 5                                              # 首页每页显示的文章数
disqusShortname = ""      # disqus_shortname
googleAnalytics = ""      # UA-XXXXXXXX-X
copyright = ""            # default: author.name ↓        # 默认为下面配置的author.name ↓

[author]                  # essential                     # 必需
  name = "Codest"

[sitemap]                 # essential                     # 必需
  changefreq = "weekly"
  priority = 0.5
  filename = "sitemap.xml"

[[menu.main]]             # config your menu              # 配置目录
  name = "主页"
  weight = 10
  identifier = "home"
  url = "/"
[[menu.main]]
  name = "归档"
  weight = 20
  identifier = "archives"
  url = "/post/"
[[menu.main]]
  name = "标签"
  weight = 30
  identifier = "tags"
  url = "/tags/"
[[menu.main]]
  name = "类别"
  weight = 40
  identifier = "categories"
  url = "/categories/"
```
## 配置内容过期提醒
```toml
[params.outdatedInfoWarning]
    enable = true
    hint = 30               # Display hint if the last modified time is more than these days ago.    # 如果文章最后更新于这天数之前，显示提醒
    warn = 180              # Display warning if the last modified time is more than these days ago.    # 如果文章最后更新于这天数之前，显示警告
```
如果你写的内容具有很强的时效性，可以通过配置此项达到提醒读者的目的 如果正在浏览的某篇文章的更新时间在设置的天数之前，则会以不同的底色显示提醒或警告
> 【注意】最后更新于 6月前，文中内容可能已过时，请谨慎使用。

## 配置utteranc评论系统
[utterances](https://github.com/utterance/utterances) 是一款基于 GitHub issues 的评论工具。
首先创建评论存储库，例如https://github.com/prime167/BlogComment
然后打开https://github.com/apps/utterances，安装utterances到刚才创建的库
config.toml 添加配置
```toml
[params.utteranc]
  enable = true
  repo = "prime167/BlogComment"
  issueTerm = "title"
  theme = "github-light"
```

## 添加新文章

运行

``` 
hugo new post/hello-world.md
```

文件就会生成到 *content\post\hello-world.md*

## 编辑

用vscode打开myBlog文件夹，编辑hell-world.md

```toml
---
title: "Hello World"
date: 2019-08-07T16:26:41+08:00
lastmod: 2020-06-16T07:26:41+08:00
draft: false
---
文章的开头，在两个---之间的叫front matter，控制文章的标题，发布时间、最后修改时间等元数据。在下面接着用markdown写正文就可以了

```

### 设置tag

```toml
---
title: "Hello World"
date: 2019-08-07T16:26:41+08:00
draft: true
tags: ["git","git worktree", "scm"]
---
```

### 设置分类

```toml
---
title: "git worktree 命令的使用"
date: 2019-07-26T14:05:29+08:00
draft: false
tags: ["git","git worktree", "scm"]
categories: ["技术"]
---
```

### 设置文章摘要

hugo 默认把文章的前70个字符作为摘要，有时候会断的莫名其妙，可以在正文任意位置插入*<code>&#60;&#33;&#45;&#45;more&#45;&#45;&#62;</code>* ,之前的是摘要，之后的是正文。

### 本地预览

运行

```
hugo server -D
```

浏览器打开 localhost:1313, 就可以预览了，保存后就实时更新。编辑时使用vscode的实时预览，保存后在浏览器中预览。如果显示器足够大或者双屏，就可以都开着。

## 发布

文章写完检查无误后，把 *draft:true* 改成 *draft:false*，命令行预先hugo,生成静态页面到public文件。把这个文件夹push到一开始创建的GitHub repo，文章就发布了。