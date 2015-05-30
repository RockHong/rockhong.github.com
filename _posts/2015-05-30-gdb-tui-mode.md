---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150530-gdb-tui-mode # DO NOT CHANGE THE VALUE ONCE SET
title: GDB的TUI Mode
# MUST HAVE END

is_short: true
subtitle:
tags: 
- gdb
date: 2015-05-30 17:00:00
image: 
image_desc: 
---

最近要做一个buffer overflow的培训，准备环境时发现gdb的TUI(Text User Interface)
模式还是很不错的。效果如下图：

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/tui-snapshot.png" alt="gdb tui snapshot">
</div>

在Google English搜索一下关键词“gdb tui”就能找到详细的文档。

要注意的一点是，最好以下面的方式进入tui模式，

    gdb -tui a.out

而不要打开gdb后，再通过`Ctrl-x a`切换到tui模式。否则在tui模式中可能不能正常使用类似`Ctrl-x a`
等的快捷键；按下`Ctrl-x a`可能只能在gdb的命令行显示`^xa`。

