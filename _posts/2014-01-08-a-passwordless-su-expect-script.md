---
# MUST HAVE BEG
layout: post
disqus_identifier: 20140108-an-expect-script-for-passwordless-su # DON'T CHANGE THE VALUE ONCE SET
title: 一个自动化输入su密码的expect脚本
# MUST HAVE END

is_short: true
subtitle:
tags: 
- linux
date: 2014-01-08 20:16:00
image:
image_desc:
---

expect是Unix/Linux上一个用于自动化（automating）*交互程序*的操作的工具。典型的*交互程序*有ftp，ssh，telnet等。
expect可以启动（spawn）一个交互程序，然后监听/等待（expect）它的输出；当监听到指定的输出时，再发送（send）相应的消息给这个程序。

自然地，expect可以很轻松地完成一些自动输入密码的任务，省去每次人工输入的烦恼。像bash一样，expect也有它自己的脚本语言。
下面给出一个免密码运行su（准确地说是执行su命令时让expect自动输入密码）的expect脚本。

<pre class="line-numbers"><code class="language-bash">spawn su
expect "Password:"
send "123456\r"    #发送密码，记得加上\r来模拟人类的回车动作

expect "\$ "       #su成功后开始等待终端提示符，我的终端提示符是$，这个符号需要转义（貌似
                   #我的expect有个bug，仅仅转义$并不行，必须后面跟个空格）；你的root终端
                   #提示符可能是“#”等其他字符，请相应地改成 expect "# "
send "pwd\r"       #现在我们可以以root身份执行命令了；比如执行pwd命令；记得加上\r，需要有一个回车动作

expect "\$ "
send "cmd_2\r"     #以root身份执行其它命令...

expect "\$ "       #记得加上这个expect语句，要不然可能还没有看到“cmd_2”命令的输出，expect脚本就
                   #已经退出了。这个expect语句会让expect程序等待若干秒，然后再（超时）退出。
</code></pre>

假设这个文件叫passwordless_su.expect，运行如下命令就可以自动登录切换成root并执行指定命令，

	expect passwordless_su.expect

当然，假设你的expect程序位于/usr/bin/expect，也可以在这个脚本的第一行加上，

<pre><code class="language-bash">#!/usr/bin/expect
</code></pre>
	
并且为这个脚本加上执行权限（`chmod u+x passwordless_su.expect`），然后直接执行它。

参考资料，    
[The Expect Home Page](http://expect.sourceforge.net)    
[Getting Started With Expect](http://oreilly.com/catalog/expect/chapter/ch03.html)
