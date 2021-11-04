---
title: "VLSM与CIDR的区别"
date: 2021-11-04T09:14:00+08:00
draft: false
tags: ["network","cidr","vlsm"]
categories: ["网络"]
---
## VLSM （Variable Length Subnetwork Mask     可变长子网掩码）

　　VLSM(Variable Length Subnet Mask 可变长子网掩码)，这是一种产生不同大小子网的网络分配机制，指一个网络可以配置不同的掩码。开发可变长度子网掩码的想法就是在每个子网上保留足够的主机数的同时，把一个网分成多个子网时有更大的灵活性。如果没有VLSM，一个子网掩码只能提供给一个网络。这样就限制了要求的子网数上的主机数。

　　VLSM技术对高效分配IP地址(较少浪费)以及减少路由表大小都起到非常重要的作用。但是需要注意的是使用VLSM时，所采用的路由协议必须能够支持它，这些路由协议包括RIP2，OSPF，EIGRP和BGP。

## CIDR Classless Inter.Domain Routing 无类别域间路由）

　　1992年引入了CIDR，它意味着在路由表层次的网络地址“类”的概念已经被取消，代之以“网络前缀”的概念。Internet中的CIDR Classless Inter-Domain Routing 无类别域间路由 的基本思想是取消地址的分类结构，取而代之的是允许以可变长分界的方式分配网络数。它支持路由聚合，可限制Internet主干路由器中必要路由信息的增长。IP地址中A类已经分配完毕，B类也已经差不多了 剩下的C类地址已经成为大家瓜分的目标。显然 对于一个国家、地区、组织来说分配到的地址最好是连续的 那么如何来保证这一点呢？于是提出了CIDR的概念。CIDR是Classless Inter Domain Routing的缩写 意为无类别的域间路由。“无类别”的意思是现在的选路决策是基于整个32位IP地址的掩码操作。而不管其IP地址是A类、B类或是C类，都没有什么区别。它的思想是：把许多C类地址合起来作B类地址分配。采用这种分配多个IP地址的方式，使其能够将路由表中的许多表项归并 summarization 成更少的数目。

## 区别
- CIDR是把几个标准网络合成一个大的网络
- VLSM是把一个标准网络分成几个小型网络（子网）
- CIDR是子网掩码往左边移了，VLSM是子网掩码往右边移了
