---
title: "修复Windows 10 更新错误0x800f0922"
date: 2021-12-17T10:59:20+08:00
tags: ["windows 10","操作系统"]
categories: ["维护"]
draft: false

---
上个月操作系统（Windows 10 21H1）无法启动,自动进入戴尔的恢复操作也没能恢复，最后提示分区表丢失，找了个winpe，修复了分区表，进入系统后发现只有操作系统所在的C盘了。下载DiskGenius，搜索分区，找回了丢失的数据分区，最后保存的时候提示此功能需要标准版，付费，保存。

可是之后系统更新总提示失败，错误0x800f0922。原因在于Windows的 系统恢复分区变成了基本数据分区，可使用下列命令将分区改回EFI分区

硬盘使用的GPT分区表

```batch
管理员运行CMD
diskpart
list disk
 sel disk 0  #这里选择你WIN10的系统所在硬盘（EFI分区所在硬盘）
 list part 
 sel part 1  （选择实际的EFI分区ID，卷标为WINRETOOLS）
SET ID=c12a7328-f81f-11d2-ba4b-00a0c93ec93b
```

之后操作系统就能正常更新了。