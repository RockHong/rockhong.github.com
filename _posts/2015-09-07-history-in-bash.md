---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150907-history-in-bash # DO NOT CHANGE THE VALUE ONCE SET
title: Bash的history命令
# MUST HAVE END

subtitle:
tags: 
- bash
date: 2015-09-07 20:00:00
image: 
image_desc: 
---

## 基本概念
Shell启动时，会从`HISTFILE`（默认是`~/.bash_history`）里读取命令的历史记录。如果设置了`HISTFILESIZE`变量，那么只会读取`HISTFILESIZE`条历史记录。
Shell退出时，这个shell的最后`HISTSIZE`条历史记录会写到`HISTFILE`里。如果shell打开了`histappend`选项，会以append的方式回写`HISTFILE`文件，
否则回写时会覆盖`HISTFILE`。如果保存时历史记录超过了`HISTFILESIZE`，那么`HISTFILE`会被截断（truncated）。如果不想被截断，可以考虑unset
`HISTFILESIZE`，或者把它设成null、非数字的值或者负数值。

如果不想保存历史信息，可以unset shell的`history` option，（`set +o history`），或者unset `HISTFILE`变量。

在图形界面下，简单地点击shell窗口的关闭按钮可能不会保存这个shell的历史记录。通过执行`exit`命令来退出shell。

可以通过`CTRL-p`和`CTRL-n`来上下浏览历史记录，通过`CTRL-r`反向搜索历史记录。

### Environment Variables
`HISTFILE`，历史记录所在的文件。默认是`~/.bash_history`。不想保存历史信息时，可以unset这个变量。

`HISTFILESIZE`，设置`HISTFILE`文件里可以保存多少条记录，例如`export HISTFILESIZE=10000`。

`HISTSIZE`，设置一个shell session可以存多少条历史记录。

`HISTIGNORE`，保存历史时忽略某些命令。例如`export HISTIGNORE="&:[ ]*:exit"`，会忽略三种类型的历史记录；分别是：
`&`，和上一条历史记录相同的记录；`[ ]*`，以空格开头的历史记录；`exit`，忽略`exit`命令。Pattern之间用`:`分隔。

`HISTCONTROL`，和`HISTIGNORE`类似，也是用来忽略某些历史记录，见`man bash`。

`HISTCMD`，下一个命令在历史记录中的index。假设当前`HISTCMD`的值是123，然后执行`ls`，再执行`history`，会看到：

    $ history
     ...
     122 ...
     123 ls

`HISTTIMEFORMAT`，可以在`history`的输出中显示历史记录的时间戳。`HISTTIMEFORMAT`字符串的可用格式见`man strftime`。

### Bash Options
`history`      
可以控制是否保留历史记录。打开这个选项，`set -o history`；关闭这个选项，`set +o history`。

`histappend`      
打开后，写`HISTFILE`时会用append的方式；否则，使用覆盖的方式。`shopt -s histappend`，打开；`shopt -u histappend`，关闭。
append的时候只会把这个shell启动后新增的历史记录写到`HISTFILE`里。如果`histappend`选项处于关闭状态（默认行为），那么`HISTFILE`只会保留
最后关闭的那个shell的历史（其它shell的历史都被覆盖了）。

`histreedit`      
打开这个option后，如果替换（例如`^xxx^yyy^`）失败，会失败的替换重新输出到shell的输入行上。

`histverify`      
打开后，在做history expansion时会不立即执行它，而是把expansion的结果输出到shell上，让用户有机会在执行前修改它。
比如，打开这个option后，输入`!!`不会立即执行上一个命令，而是把上一个命令打印到shell的输入行上。

（注：可以看到一些选项用`set`来设置，另外一些用`shopt`来设置。这两个都是bash的bulitin command，它们所控制选项有所不同。详见`man bash`。）

## history命令
Bash提供了一个builtin command，`history`，来操作历史记录。`history`命令有下面几种执行格式，

      history [n]
      history -c
      history -d offset
      history [-anrw] [filename]
      history -ps arg

`history`的一些例子，

    $ history   # 列出所有历史记录
    $ history 3 # 列出最近3条历史记录

    $ history -c   # 清除当前shell的历史记录，不会影响HISTFILE
    $ history -d 3 # 删除编号为3的记录
    $ history -w   # 用当前shell的历史来覆盖HISTFILE
    $ history -a   # 把当前shell启动后产生的新的历史记录append到HISTFILE里
    $ history -r   # 读取HISTFILE中的历史记录，把它们append到当前shell的历史记录中
    $ history -n   # 见man bash
    $ history -p a b c 'd e'  # 会按行输出"a"，"b"，"c"，"d e" 
    $ history -s "cmd arg1"   # 把"cmd arg1"保存到当前shell的历史中；不执行命令，就可以保留历史记录

在不退出任何一个shell的情况下，可以通过`-a`和`-r`在shell间分享历史记录。例如，在shell A里执行`history -a`，然后在shell B里执行`history -r`，这样shell B就能看见shell A的历史了。

使用`-w`, `-r`, `-a`, `-n`选项时默认是操作`HISTFILE`文件，也可以在指定别的文件。

## History Expansion   
通过history expansion，可以重新执行之前执行过的命令或者提取之前执行过的命令的参数。 History Expansion有两种类型，event Designators以及word Designators。
Event designators用来重新执行命令，而word designators用来提取历史命令的参数。

<!--more-->
### Event Designators
Event designators以`!`开头，也有一个是以`^`开头的。

    $ !!        # 执行上一个命令，和!-1等效
    $ !-1       # 执行上一个命令
    $ !-2       # 执行上上个命令
    $ !3        # 执行编号为3的历史记录
    $ !xyz      # 执行以xyz开头的最近执行过的命令
    $ !?xyz?    # 执行含有xyz的最近执行过的命令
    $ ^xxx^yyy^ # 找到最近执行的带xxx的命令，把xxx替换成yyy，然后执行它

### Word Designators
Word designators跟在一个event designators后面，它们之间以`:`分隔。

    $ echo !!:2   # 提取上一个命令的第2个参数，然后把它传给echo并执行
    $ !!:2        # 提取上一个命令的第2个参数，并执行它。如果不想执行，要打开bash的histverify选项
                  # 或者用"p" modifier
    $ echo !!:0   # 提取上一个命令的名字
    $ echo !!:3-5 # 提取第3，4，5个参数
    $ echo !!:$   # 提取最后一个参数
    $ echo !!:^   # 提取第一个参数
    $ echo !!:*   # 提取所有参数，和!!:1-$效果一样
    $ echo !!:3*  # 等效于3-$
    $ echo !!:3-  # 提取第3个到倒数第二个

### Modifier
Word designators后面还可以跟着一个modifier，它可以进一步修改word designators提取出的字符串。
    
    $ echo !!:$:h   # 从末尾开始删除直到遇到/，如果!!:$是个path string，那么"h"相当于只保留dirname
    $ echo !!:$:t   # 和"h"相反，保留basename
    $ echo !!:$:r   # 去掉后缀，比如abc.xml会变成abc
    $ echo !!:$:r:r # 去掉两个后缀，比如abc.gz.tar会变成abc。这个例子也说明了modifier可以连续使用
    $ echo !!:$:e   # 只保留后缀，比如abc.xml会变成.xml
    $ echo !!:$:gs/abc/xyz/ # 把字符串中的abc替换成xyz，如果不加"g"，则只会替换第一个abc
    $ echo !!:$:&   # 重复上一次"s"替换
    $ echo !!:*:q   # 给字符串加上单引号；对于单引号内的字符串，bash不会做变量替换
    $ echo !!:*:x   # 和"q"一样，只不过如果字符串带有空格，那么会break word。
                    # 假如字符串是"a b c"，那么"q"的结果是'a b c'，"x"的结果是'a' 'b' 'c'
    $ !!:$:p        # man bash里说：“Print the new command but do not execute it”。
    # "p"的一个例子
    $ find ./abc -name pom.xml
    $ !!:0:p ./xyz !!:2-$

注： `!!:$`可以简写成`!$`，也就是`!!:`可以简写成`!`。

## 其它

    export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

应用了这个`PROMPT_COMMAND`后，每个shell的历史记录都会“实时地”在shell间共享。
`history -a`会把当前shell的命令append到`HISTFILE`里；
然后通过`history -c`清除这个shell的所有历史记录；
最后通过`history -r`把`HISTFILE`的内容读取到当前shell里。这个`PROMPT_COMMAND`会在每次执行命令后都会把`HISTFILE`重新加载一遍，
如果`HISTFILE`很大可能会产生一些延迟。
（这个`PROMPT_COMMAND`在append时没有性能问题，因为每次append只是append一条记录。）

如果不要求“实时”共享，可以通过在一个shell里执行`history -a`，然后在另一个shell里执行`history -r`的方式来分享一个shell的历史记录。

另外，在shell script里`history`命令默认是禁用的。可以通过下面的方式打开，

    set -o history
    echo `history`

## 参考文档
[The Definitive Guide to Bash Command Line History][9]     
[How To Use Bash History Commands and Expansions on a Linux VPS][8]     
[Advancing in the Bash Shell][6]     
[Bash History Cheat Sheet][5]     
[Appendix L. History Commands][3]     
[Bash History Builtins][2]
     
所有关于history的信息都可以在`man bash`中找到。


[2]: http://www.gnu.org/software/bash/manual/html_node/Bash-History-Builtins.html "bash history"
[3]: http://tldp.org/LDP/abs/html/histcommands.html "bash history"
[5]: http://www.catonmat.net/download/bash-history-cheat-sheet.txt "bash history cheat sheet"
[6]: http://samrowe.com/wordpress/advancing-in-the-bash-shell/ "bash advanced"
[8]: https://www.digitalocean.com/community/tutorials/how-to-use-bash-history-commands-and-expansions-on-a-linux-vps "bash history"
[9]: http://www.catonmat.net/blog/the-definitive-guide-to-bash-command-line-history/ "bash history"