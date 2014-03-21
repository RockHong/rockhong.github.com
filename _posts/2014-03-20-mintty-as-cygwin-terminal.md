---
# MUST HAVE BEG
layout: post
disqus_identifier: 20140320-mintty-as-a-cygwin-terminal # DON'T CHANGE THE VALUE ONCE SET
title: 使用mintty作为cygwin的终端
# MUST HAVE END

subtitle:
tags: 
- cygwin
date: 2014-03-20 21:10:00
image: mintty_logo.png
image_desc: mintty logo
---

cygwin的默认终端使用起来有一些不顺手。之前用的puttycgy（[链接](https://code.google.com/p/puttycyg/)）在2011年末后就不再维护了。搜索后发现一个新的（更好的）选择——mintty。mintty

* 可以配置为鼠标右键粘贴（默认是中键粘贴，但是中键比较难按……）
* 可以方便地通过拖拽文件或者目录的图标到mintty窗口来得到路径
* 可以按住Ctrl点击来打开文件或者URL
* 可以通过Ctrl+“+”和Ctrl+“-”来缩放字体
* ……

###安装
通常cygwin的bin目录下已经自带了mintty程序。如果不存在也可以使用cygwin的setup.exe程序来下载/安装；可以在“Shell”分类下找到mintty。    
也可以在mintty的项目网站上下载（[链接](https://code.google.com/p/mintty/)）。

###其他
如果使用mintty时，提示找不到“ls”，“pwd”等命令，可以将cygwin的bin路径加入到Windows的PATH环境变量中。      
关于mintty的使用说明，可以直接在mintty中查看手册`man mintty`，也可以查看文档（项目网站和下载的安装包中都有）。

<img src="../images/blog/mintty_logo.png" alt="Mintty logo" title="mintty logo" style="    width: 60px; display: block; margin-left: auto; margin-right: auto;">

HAVE FUN.
