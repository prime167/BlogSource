---
title: "数独背后的数学"
date: 2023-12-28T14:12:20+08:00
tags: ["数独","数学"]
categories: ["数学"]
draft: false
---
今年第一篇也是最后一篇献给数独吧<!--more-->

本次暂且只记录一些结论及来源

### 结论
* 2x2 的4宫数独，完整盘面总共有 288 种，基本形式有2种, 解开至少需要4个提示
* 2x3 的6宫数独，完整盘面总共有 28200960 种，基本形式有49种, 解开至少需要8个提示
* 3x3 的9宫数独，完整盘面总共有 6,670,903,752,021,072,936,960 (6.671×10^21), 基本形式有 5,472,730,538种, 解开至少需要17个提示

上面的种数是指数独盘面填满的所有可能情况, 所有形式都可以通过对基本形式旋转、反射、置换和重新标记等对称性操作后得到。一个完整盘面可以通过挖去某些数字得到一个数独谜题，虽然不同的完整盘面挖去数字后可能得到相同的数独谜题，我想可以做的（有唯一解）3x3的数独题比5,472,730,538多吧？

即使可以做的数独题目只有365种，我想仍然不会对数独的趣味性有什么损失：给你一个3天之前做的题应该也很少有人记得做过，所以上述结论仅仅是为了满足人类的好奇心的纯数学结论罢了。

### 参见

* [Mathematics of Sudoku facts for kids](https://kids.kiddle.co/Mathematics_of_Sudoku)
* [Mathematics of Sudoku -Wikipedia](https://en.wikipedia.org/wiki/Mathematics_of_Sudoku)
* [Mathematics of Sudoku -academic.com](https://en-academic.com/dic.nsf/enwiki/1368721)
* [The Math Behind Sudoku
The 4×4 Case](https://pi.math.cornell.edu/~mec/Summer2009/Mahmood/Four.html)
* [
How many possible 2x2 soduku's](http://programmers.enjoysudoku.com/www.setbb.com/sudoku/viewtopic41e5.html?t=882&mforum=sudoku)
* [
The Structure of Reduced Sudoku Grids and the Sudoku Symmetry Group](https://downloads.hindawi.com/journals/ijct/2012/760310.pdf)
* [There are 5472730538 essentially different Sudoku grids
... and the Sudoku symmetry group
Ed Russell and Frazer Jarvis](https://archive.is/VpOW7)
* [There are 49 essentially different Sudoku 2x3 grids
... and the 2x3 Sudoku symmetry group](https://archive.is/2012.07.20-061559/http://www.afjarvis.staff.shef.ac.uk/sudoku/sud23gp.html#selection-13.13-13.14)
* [A291187		Number of 2 X n Sudoku grids ((2*n) X (2*n) grids divided into 2 X n boxes)](https://oeis.org/A291187)
* [Number of essentially different Sudoku grids](http://forum.enjoysudoku.com/number-of-essentially-different-sudoku-grids-t4281.html)
* [There is no 16-Clue Sudoku: Solving the Sudoku Minimum
Number of Clues Problem via Hitting Set Enumeration](https://arxiv.org/pdf/1201.0749.pdf)