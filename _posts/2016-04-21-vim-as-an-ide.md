---
# MUST HAVE BEG
layout: post
disqus_identifier: 20160421-vim-as-an-ide # DO NOT CHANGE THE VALUE ONCE SET
title: Vim as an IDE
# MUST HAVE END

is_short: false # 
subtitle:
tags: 
- vim
date: 2016-04-21 12:36:00
image: 
image_desc: 
---

*Working in process*

Vim的命令需要经常使用才不会忘记。
把Vim打造成适合日常工作的“轻量级IDE”可以有助于熟悉和记忆Vim命令。

## 一些基本的Vim配置

### 设置mapleader
在`.vimrc`文件里加上下面的配置，

{% highlight vim %}
let mapleader = ',' 
{% endhighlight %}

{% highlight vim %}
nmap <leader>a :Ack! 
{% endhighlight %}

现在就可以用快捷键`,`+`a`来快速地输入命令`:Ack!`。

### 安装一个插件管理系统
装一个插件管理系统可以更好地管理Vim的插件。我选了[pathogen.vim][12]作为Vim的插件管理。


## 搜索文件内容
[ack.vim][1]插件可以用来搜索文件内容。

{% highlight vim %}
nmap <leader>a :Ack!  
{% endhighlight %}

按快捷键`,a`就可以进行文件内容搜索了，效果见下面的截图。

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/vim-ack.png" alt="diff-highlight" style="max-width:610px;">
</div>

ack.vim插件是借助第三方的程序来进行搜索的，然后把搜索结果展示在Vim里。
默认情况下，ack.vim使用[ack][2]来进行搜索。ack相比grep要[更快、更好用][5]。
[The Silver Searcher][3]（ag）是一个类似ack的搜索工具，号称比ack还要快。
OS X下可以用homebrew方便地安装它们，

{% highlight bash %}
brew install ack
brew install ag
{% endhighlight %}

ack和ag也可以在Windows下安装。
ag在Windows下可通过Cygwin*等*方式来安装，详见ag的官方[Wiki][6]。

让ag成为ack.vim的搜索工具，

{% highlight vim %}
let g:ackprg = 'ag --nogroup --column'  " 让ack.vim使用ag作为搜索工具
{% endhighlight %}
	

### 更快地搜索
基本上，ag和ack能接受的参数是类似的。

默认情况下，ack和ag会搜索当前工作目录。可以通过限制搜索目录来提高搜索速度，比如，

	:Ack! text-to-search some_dir
	
也可以限制搜索的文件类型，比如

	:Ack! --java text-to-search 

ack默认会忽略.git目录。也可以使用`--ignore-dir=name`选项来指定要忽略的目录。
对于ag，默认会忽略.gitignore中指定的文件。
也可以在[.agignore文件][8]里加上想忽略的文件。比如，忽略maven工程下的`target`目录。
.agignore的语法和.gitignore类似。

ack的更多选项见其[官方文档][9]。
如果某个工程需要经常使用某些选项，可以把这些选项放到工程目录下的.ackrc文件中。


## 文件系统导航
文件系统的导航可以借助[NERDTree][10]插件来实现。

{% highlight vim %}
nmap <leader>d :NERDTreeToggle<CR>
{% endhighlight %}
	
按下快捷键`,d`，效果见如下截图，

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/vim-nerdtree.png" alt="diff-highlight" style="max-width:610px;">
</div>

在NERDTree窗口按`?`键可以显示帮助信息。

`:NERDTreeFind`命令可以在NERDTree窗口中显示当前文件的位置，类似于Eclipse的"Link with Editor"功能。

{% highlight vim %}
nmap <leader>df :NERDTreeFind<CR>
{% endhighlight %}

现在输入快捷键`,df`就可以在NERDTree窗口中显示当前文件。


## 快速打开文件
借助[command-t][11]插件可以实现文件的快速打开。
<!--more-->

{% highlight vim %}
nmap <leader>t :CommandT<CR>
{% endhighlight %}

按下快捷键`,t`，其效果如下图所示，

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/vim-commandt.png" alt="diff-highlight" style="max-width:610px;">
</div>

搜索是fuzzy的，不用输入完整的文件名，只要输入文件路径和文件名中的某些字母就可以。

command-t需要对Ruby和C编译器有依赖，详见其[文档][15]。另一个类似的插件[CtrlP][11]是纯VimScript实现的。
但是在使用中发现CtrlP有时候不能找到指定的文件，所以还是选择了command-t。

另外`:CommandTBuffer`命令可以用来快速打开已经打开的文件。
而`:CommandTJump`命令可用了在jumplist里快速定位。

## 自动补全
[supertab][16]插件可以用作轻量级的自动补全工具。输入文字，然后按`tab`键进行补全，如下图所示，

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/vim-supertab.png" alt="diff-highlight" style="max-width:610px;">
</div>

## 执行外部程序
总是时不时地需要执行一些外部命令。比如代码写好后，用git命令来提交一下。
可以借助[tmux][18]来执行外部命令。tmux可以开多个pane，进行文字编辑时可以输入`C-b`+`z`进入“全屏模式”；
需要执行外部命令时，再`C-b`+`z`退回多pane模式。

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/vim-tmux.png" alt="diff-highlight" style="max-width:610px;">
</div>


最好附上[我的Vim配置][19]作为参考。


[1]: https://github.com/mileszs/ack.vim "ack.vim"
[2]: http://beyondgrep.com/ "ack"
[3]: https://github.com/ggreer/the_silver_searcher "The Silver Searcher"
[5]: http://beyondgrep.com/why-ack/ "why ack"
[6]: https://github.com/ggreer/the_silver_searcher/wiki/Windows "ag windows"
[8]: https://github.com/ggreer/the_silver_searcher/wiki/Advanced-Usage "agignore"
[9]: http://beyondgrep.com/documentation/ "ack document"
[10]: https://github.com/scrooloose/nerdtree "NERD Tree"
[11]: https://github.com/ctrlpvim/ctrlp.vim "ctrlp.vim"
[12]: https://github.com/tpope/vim-pathogen "pathogen"
[13]: https://github.com/wincent/command-t "command-t"
[15]: https://github.com/wincent/command-t/blob/master/doc/command-t.txt "command-t doc"
[16]: https://github.com/ervandew/supertab "supertab"
[18]: http://rockhong.github.io/tmux-info.html "tmux"
[19]: https://github.com/RockHong/vim-env "my vim cfg"




<!-- 

## done
## 显示换行符
:set list! to toggle the option on, so that you can later press : followed by the up arrow to repeat the previous command, to toggle 'list' off.
set list listchars=tab:»·,trail:·,eol:¶

##   鼠标 enable mouse, drag panel size
set mouse=a                         " Enable basic mouse behavior such as resizing buffers.


##关闭某个panel对应的buffer，但是不关闭这个panel
http://stackoverflow.com/questions/4465095/vim-delete-buffer-without-losing-the-split-window
bp|bd #
nnoremap <C-c> :bp\|bd #<CR>

## todo
vim and git
格式化代码

tab and workspace
  different tab share the same CWD
  but different tab can have different nerdtree



怎么列出所有的快捷键的mapping？？？


## code complete
supertab  大部分够用； 看看supertab的文档，它是不是只知道对vim buffer里的东西
但是有些时候不够强大，是不是onmicompelete好，比如对于写java，可以利用tag

https://www.reddit.com/r/vim/comments/3hl0ec/youcompleteme_neocomplete_or_supertab/
youcompleteme, neocomplete or supertab


## 符号跳转

http://andrewradev.com/2011/06/08/vim-and-ctags/

http://blog.vinceliu.com/2007/08/vim-tips-for-java-2-using-exuberant.html




## 各个语言相关的
### 符号的跳转
java开发相关的
http://stackoverflow.com/questions/12550848/vim-java-open-class-under-cursor-and-go-to-method

ctags 可以通过cygwin安装

ruby

python  
  

# 给插件的命令配上快捷键
以逗号开头？

## 格式化粘贴



## 跳转
how to go back to previous place?


## 注释  
trigger comment on a code block
  virtual select a block, then I, then input "#", "//", then esc
  


## 多文件编辑


  
## 保存macro
某个宏可以方便地生产java的getter setter


* how to match ', " ? how to find unmatched (, {, [, ', " ?


##For coding
###%    '===' 
(not need to put cursor exactly on the 'item')   see :help %
Find the next item in this line after or under the
cursor and jump to its match. inclusive motion.
Items can be:
([{}])          parenthesis or (curly/square) brackets
                (this can be changed with the
                'matchpairs' option)
/* */           start or end of C-style comment
#if, #ifdef, #else, #elif, #endif
                C preprocessor conditionals (when the
                cursor is on the # or no ([{
                following)
...

###>> and << 
shift code. :help >>    '==='

###gd 
Goto local Declaration. When the cursor is on a local variable.

###K 
Run a program to lookup the keyword under the cursor. default is to launch 'man'.
can use '2K' to look for the specified section of man.

###]p
like p, but consider code indent   '==='


###Edit multiple files
http://stackoverflow.com/questions/53664/how-to-effectively-work-with-multiple-files-in-vim

#### Using Tabs (introduced in Vim 7)
':tabe <filepath>' add a new tab
'gvim -p main.pl maintenance.pl' will open these two files in tabs.
':q' or ':wq' you close a tab. 'ZZ' also can be used instead of :wq
switch between tabs with ':tabn' and ':tabp'        
'gt' goes to the next tab, and 'gT' goes to the previous tab      
jump to any tab by using 'ngt', where n is the index of the tab (beginning with one).
if you already have existing buffers, you can ':tabnew', and in the new tab enter ':b2'

If you map :tabn and :tabp to your F7/F8 keys you can easily switch between files.

#### Not Using tabs
':ls'  see a list of current buffers    
':e ../myFile.pl'  open a new file
you can also use ':find' which will search a set of paths for you, but you need to customize those paths first.
use ':b myfile' with enhanced tab completion (still set wild menu) to switch between all open files 
':b' with tab-key providing auto-completion (awesome !!)
':b#' choses the last visited file, so you can use it to switch quickly between two files.
':bp' previous buffer
':bn' next buffer
':bn' (n a number) move to nth buffer
':bw' (buffer wipe, remove a buffer)
'sb' split your screen, enter a number to specify the buffer to split 
'arga[dd]' to add multiple files from within vim
    ':arga foo.txt bar.txt',  ':arga /foo/bar/*.txt',   ':argadd /foo/bar/*'

#### split windows
Starting vim with a '-o' or '-O' flag opens each file in its own split.

'Ctrl-W w' to switch between open windows
'Ctrl-W h' (or j or k or l) to navigate through open windows.
'Ctrl-W c' to close the current window
'Ctrl-W o' to close all windows except the current one.

':split filename'  , split window to open a file
':vsplit filename' , vertical split
':sview filename'  , read-only
'ctrl-w-'          , decrease size by one line 
'ctrl-w+'          , increase size
'10ctrl-w+'        , increase 10 lines
'ctrl-w_'          , maximize current window
':hide'            , close current window, but buffer is not deleted
':only'            , keep only current window open, others close


###mark, move using mark, jump using mark '==='
http://reefpoints.dockyard.com/2014/04/10/vim-on-your-mark.html    
':help mark-motions'       

lowercase marks
    marks in single files. when buffer closes, they will lost. 
    if delete the lines containing marks, they lost.
    they can restore using undo and redo
    they can combine with operators. for example 'd`a' will delete till the postion of mark a. '==='

uppercase marks
    you can use them to jump from file to file.
    they can only combine with operators when they are in current buffer.
    remains even if the lines containing the marks are deleted.

numbered marks
    set automatically. "'0" is the location of the cursor when you last exit vim.

you can check document using ':help mark-motions', and scroll down the help document a little bit.

'm{a-zA-Z}'                  Set mark {a-zA-Z} at cursor position
"'{a-z}  `{a-z}"             Jump to the mark {a-z} in the current buffer, 
                         "'" will go to the first non-blank position of the line,
                         "`" will go to the exact position when you do marking
"'{A-Z0-9}  `{A-Z0-9} "      To the mark {A-Z0-9} in the file where it was set
"g'{mark} g`{mark} "         jump, but not change the jumplist
':marks'                     list marks
':marks aB'                  list marks between a and B
" '0  "                      will cause Vim to jump to the 0 mark, which is a "special mark" that 
                             represents the last file edited when Vim was exited.
':delm a'  ':delm aB'  'delm p-z'
" '.  `.  "                  To the position where the last change was made.    '==='
" '<  `<  "                  To the first line or character of the last selected visual area
" '>  `>  "                  To the last line or character of the last selected visual area
" ''  ``  "                  To the position before the latest jump, or where the
                             last "m'" or "m`" command was given.

###jump
http://vimcasts.org/episodes/using-the-changelist-and-jumplist/
http://usevim.com/2013/02/15/vim-101-jumps/

go to file under cursor, seems useful for coding
    1)':gf' open in the same window
    2)':<c-w>f' open in a new window
    3)':<c-w>gf' open in a new tab

When writing a program, it is helpful to set the 'path' option to list the directories with your include files. 
If there are several files in your 'path' that match the name under the cursor, 'gf' opens the first, while '2gf' opens the second
Names containing spaces, you can visually select the name (including the spaces), then type gf

go back to previous file
1) use ':ctrl-6', it toggles between two files. same as ":e #"
2) navigate in jump list, use ':ctrl-o' (can add [count]) for backward, use '<tab>' or 'ctrl-i'(can add [count]) for forward

':jumps'
show jump list. the one begin with '>' is current pos. the number can be used in '[count]ctrl-o/i'
'what will add into jump list', http://usevim.com/2013/02/15/vim-101-jumps/
1) Freely jumping around a file. Example: G
2) Jumping based on the window size. Example: M
3) Text block jumps. Examples: (, ), {, }
and, Searching (/ and ?) and (n, N)


- 升级所有的插件，ctrlp见[11][11]


### ack.vim插件的一些有用的命令

	:AckFile         " 可以用Ack.vim来搜索文件
	
更多命令见`:help Ack`。    这个用command-t等“专业”的插件来做吧。。。

在CtrlP窗口输入`?`可以显示帮助文档。也可以查看CtrlP的[README文档][11]。
-->










  




