---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150523-another-newline-trouble # DO NOT CHANGE THE VALUE ONCE SET
title: 又一个换行符引起的问题
# MUST HAVE END

is_short: true
subtitle:
tags: 
- vim
date: 2015-05-23 17:45:00
image: notepad_show_newline.png
image_desc: newline trouble
---

今天在Windows的cygwin下配置[tmux][2]的时候遇到了一个“奇怪的”的问题。 tmux在加载下面的`.tmux.conf`文件时出错
（`.tmux.conf`是在Windows上用gvim编辑的），

    set -g mode-mouse on
    setw -g mode-mouse on
    setw -g mouse-select-window on
    setw -g mouse-select-pane on

tmux报的错误消息如下，

    $ tmux source-file ~/.tmux.conf
    unknown value: on
    unknown value: on
    bad value: on
    bad value: on
    
Google了一下发现，这[又是][1]Windows和Unix换行符不同产生的问题。

用Notepad++可以方便地（`View->Show Symbol->...`）把换行符等不可见字符显示出来。比如，

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/notepad_show_newline.png" alt="nodepad++ snapshot" style="width: 250px;">
</div>

用Notepad++查看`.tmux.conf`文件后，发现它的换行符是`CRLF`。而cygwin下的tmux认为自己处于“unix世界”里，
它要求`.tmux.conf`文件以`LF`结尾，于是就报错了。

网上有人说可以在vim里用`:set list`显示不可见字符，如果行末显示是`$`表示是`LF`，如果是`^M`则是`CRLF`。
但是在Windows的gvim里，打开`:set list`后不管实际上是`LF`还是`CRLF`结尾，都显示为`$`。

知道了是换行符的原因，解决方法就很简单了。可以在cygwin下用dos2unix命令转换一下换行符，

	$ dos2unix -n ~/.tmux.conf ~/.tmux.conf

也可以在vim/gvim里转换换行符，方法如下：

- `:set fileformat=unix`（或者`:set ff=unix`），设置文本文件的格式
- `:w`，写文件

`set ff=...`只对vim里的单个buffer有效。这意味着不同的buffer可以有不同的值；也意味着不能用这个选项
对vim做全局的设置。

vim提供了另一个选项`fileformats`（`ffs`），它是一个全局的配置，可以影响`ff`。`ffs`可以是`dos`，`unix`等单个值，
也可以是`dos,unix`，`unix,dos`之类的组合。当它设置为单个值时，比如`unix`，打开一个dos文本，
最后写文件时vim会把换行符替换成`LF`；当它设置为组合值时，vim在读文件发现有行是以`LF`结尾时就把`ff`设置成`unix`；
如果全部行都是`CRLF`，那么把`ff`设成`dos`。（更多细节见`:help ffs`）

如果希望Windows的gvim在新建文件时默认采用unix风格的换行符，可以在用户目录的`_gvimrc`文件中这么配置，

	set fileformats=unix,dos

当vim/gvim发现`ff`的值和当前系统“不一致”时，会提醒用户，

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center">
  <img src="/images/blog/unix-vim-written.png" alt="vim snapshot" style="width: 350px;">
</div>

### 总结
在Windows上使用unix/linux工具时，类似的换行符问题总是会[时不时出现][1]。避免类似问题的最好方法是，尽量在“一个世界”
里工作。比如，上面的问题就是由于在cygwin（unix世界）里，用tmux去读取一个gvim（windows世界）写的文件引起的。




[1]: /newline-in-git.html "Git里的换行符"
[2]: http://tmux.sourceforge.net/ "tmux homepage"

