---
title: "如何撤销一个 git rebase"
date: 2022-07-29T15:15:20+08:00
tags: ["git","rebase"]
categories: ["技术"]
draft: false

---
上次说了通过git rebase 合并多个提交，那如何撤销呢？<!--more-->

先运行git reflog命令查看本地命令记录

```bash
ed8a955 (HEAD -> main) HEAD@{0}: rebase (finish): returning to refs/heads/main
ed8a955 (HEAD -> main) HEAD@{1}: rebase (squash): 添加用户功能
2776eb0 HEAD@{2}: rebase (squash): # This is a combination of 4 commits.
2aade14 HEAD@{3}: rebase (squash): # This is a combination of 3 commits.
ecb64a7 HEAD@{4}: rebase (squash): # This is a combination of 2 commits.
288ebcb HEAD@{5}: rebase (start): checkout HEAD~5
7e7af1b HEAD@{6}: commit: 完成
215353c HEAD@{7}: commit: 修改自测bug
5fcfa4f HEAD@{8}: commit: 完成功能
34024f7 HEAD@{9}: commit: 完成界面设计
288ebcb HEAD@{10}: commit: 开始添加用户功能
b36071d HEAD@{11}: commit: 登录功能
25b848d HEAD@{12}: commit (initial): init
```

可以看到rebase之前的最后提交 是 7e7af1b HEAD@{6}: commit: 完成

将本地历史记录reset到此处即可
```bash
git reset --hard "HEAD@{6}"
```

直接使用commit-ish是一个效果
```bash
git reset --hard 7e7af 
```

