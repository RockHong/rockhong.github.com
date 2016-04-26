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

Vim的命令需要经常使用才不会忘记。把Vim打造成适合日常开发的主力IDE可以帮助自己熟悉和记忆Vim命令。

## 一些基本的Vim配置

	let mapleader = ','  " 设置快捷键
	
## 搜索文件内容

	" .vimrc
	nmap <leader>a :Ack!  

借助[ack.vim][1]插件，按快捷键`,a`可以进行文件内容搜索，效果见下面的截图。

TODO 截图

ack.vim插件借助第三方的程序来进行搜索，并把搜索结果展示在Vim里。
默认情况下，ack.vim使用[ack][2]来进行搜索。ack比grep[更快、更好用][5]。
ack在Linux下和Windows下都可以安装。
[The Silver Searcher][3]（ag）是一个类似ack的搜索工具，号称比ack更快。
ag在Windows下可以通过Cygwin等方式来安装，详见官方的[Wiki][6]。

	" .vimrc
	let g:ackprg = 'ag --nogroup --column'  " 让ack.vim使用ag作为搜索工具

### 更快地搜索
基本上，ag能接受的参数和ack类似。

默认情况下，ack和ag会搜索当前工作目录。可以通过限制搜索目录来提高搜索速度，比如，

	:Ack! text-to-search some_dir
	
限制搜索的文件类型，比如

	:Ack! --java text-to-search 

可以忽略某些目录。ack默认会忽略.git目录。也可以使用`--ignore-dir=name`选项来指定要忽略的目录。
对于ag，默认会忽略.gitignore中指定的文件。
也可以在[.agignore文件][8]里加上想忽略的文件。比如，忽略maven工程下的`target`目录。
.agignore的语法和.gitignore类似。

ack的更多选项见其[官方文档][9]。
如果某个工程需要经常使用某些选项，可以把这些选项放到工程目录下的.ackrc文件中。

### ack.vim插件的一些有用的命令

	:AckFile         " 可以用Ack.vim来搜索文件
	
更多命令见`:help Ack`。

## 文件系统导航

	" .vimrc
	nmap <leader>d :NERDTreeToggle<CR>
	
文件系统的导航可以借助[NERDTree][10]插件来实现。按下快捷键`,d`，效果见如下截图，

TODO 截图

在NERDTree窗口按`?`键可以显示帮助信息。

### 一些有用的命令

	:NERDTreeFind      " 在NERDTree窗口中显示文件的位置，类似于Eclipse的"Link with Editor"

## 快速打开文件

	nmap <leader>p :CtrlP<CR>

借助[CtrlP][11]插件可以实现文件的快速打开。按下快捷键`,p`，其效果如下图所示，

TODO  截图

搜索是fuzzy的，不用输入完整的文件名。

在CtrlP窗口输入`?`可以显示帮助文档。也可以查看CtrlP的[README文档][11]。




<!--more-->

## TODOs

- 加一些截图，gif
- 附上git仓库链接
- 升级所有的插件，ctrlp见[11][11]

[1]: https://github.com/mileszs/ack.vim "ack.vim"
[2]: http://beyondgrep.com/ "ack"
[3]: https://github.com/ggreer/the_silver_searcher "The Silver Searcher"
[5]: http://beyondgrep.com/why-ack/ "why ack"
[6]: https://github.com/ggreer/the_silver_searcher/wiki/Windows "ag windows"
[8]: https://github.com/ggreer/the_silver_searcher/wiki/Advanced-Usage "agignore"
[9]: http://beyondgrep.com/documentation/ "ack document"
[10]: https://github.com/scrooloose/nerdtree "NERD Tree"
[11]: https://github.com/ctrlpvim/ctrlp.vim "ctrlp.vim"

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




怎么列出所有的快捷键的mapping？？？


## code complete
supertab  大部分够用； 看看supertab的文档，它是不是只知道对vim buffer里的东西
但是有些时候不够强大，是不是onmicompelete好，比如对于写java，可以利用tag


## 符号跳转

http://andrewradev.com/2011/06/08/vim-and-ctags/

http://blog.vinceliu.com/2007/08/vim-tips-for-java-2-using-exuberant.html




## 各个语言相关的
java开发相关的
http://stackoverflow.com/questions/12550848/vim-java-open-class-under-cursor-and-go-to-method

ctags 可以通过cygwin安装  
  

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

-->










  




