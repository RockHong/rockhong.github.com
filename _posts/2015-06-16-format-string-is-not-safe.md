---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150616-format-string-is-not-safe # DO NOT CHANGE THE VALUE ONCE SET
title: 不安全的格式化字符串
# MUST HAVE END

is_short: false
subtitle:
tags: 
- gdb
- security
- c
date: 2015-06-16 23:24:00
image: 
image_desc: 
---

[之前的一篇文章][2]讲了一个缓冲区溢出的简单示例，这里再讲一下格式化字符串存在的安全性问题。

### Variable Argument List
C语言的库函数`printf(const char * format_str, ...)`是我们很熟悉的一个函数，它接受一个格式化字符串，以及一组数目不定的其它参数。

`printf()`通常通过“可变长度参数列表”（variable argument list）来实现。“可变长度参数列表”的一个简单例子如下所示（详
见`man 3 stdarg`），

{% highlight cpp %}
#include <stdarg.h> 
#include <stdio.h>
    
void printNDoubles(int n, ... ) {        /* 函数声明中的"..."表示可变长度参数 */
    va_list args;                        /* 对应的类型 */
    va_start(args, n);                   /* 找到可变长度参数列表的起始处 */

    int i = 0;
    for (; i < n; ++i) {
        double d = va_arg(args, double); /* 取可变长度参数列表中的下一个参数 */
        printf("%dth double is:%f\n", i, d);
    }
    va_end( args );                      /* 做一下清理工作 */
}

int main(int argc, char **argv) {
    printNDoubles(3, 1.1, 2.2, 3.3);

    return 0;
}
{% endhighlight %}

对于`printf()`而言，它会根据格式化字符串中的格式信息，比如`%d`，`%f`等，利用`va_arg()`依次取出可变参数列表中的相应参数。

一般而言，`va_start`，`va_arg`等会被实现成宏（macro）；[这篇文章][1]给出了一个简单的实现，

{% highlight cpp %}
typedef unsigned char *va_list;
#define va_start(list, param) (list = (((va_list)&param) + sizeof(param)))
#define va_arg(list, type)    (*(type *)((list += sizeof(type)) - sizeof(type)))
{% endhighlight %}

（*TODO:* 看一下gcc/glibc中的实现）

`va_start`等的实现依赖于函数调用时参数入栈（stack）的一些惯例（convention）。函数调用发生时，caller传给callee的
参数是按顺序入栈的；也就是说，`printNDoubles(3, 1.1, 2.2, 3.3)`的参数`"3`，`1.1`，`2.2`和`3.3`在栈上是互相挨着
存放的。用`va_start(args, n)`找到可变长度参数列表在栈中的起始位置（就是紧挨着参数`n`的“下一个”位置）后，就可以
用`va_arg`来依次查看可变参数列表中的参数了。

下面看一下函数的局部变量和函数调用时的参数在栈上是怎么布局的。

### 函数的局部变量（local variables）
函数的局部变量保存在它自己的栈上；局部变量的声明顺序和它们在栈上的存储位置可以通过[gdb反汇编][2]方便地看出来。

（所有的源文件都是以`gcc -m32 -fno-stack-protector -Wno-format-security -g test.c`在Ubuntu 14.04上编译。）
 
{% highlight cpp %}
int main(int argc, char **argv) {
    int s1 = 42;
    int s2 = 8;
    char s3[] = "hello";
    /* ... */
}
{% endhighlight %}

对应的汇编语句如下，

    mov    DWORD PTR [esp+0x1c],0x2a        // s1
    mov    DWORD PTR [esp+0x18],0x8         // s2
    mov    DWORD PTR [esp+0x12],0x6c6c6568  // s3，“lleh”（l:0x6c, e:0x65, h:0x68）
    mov    WORD PTR [esp+0x16],0x6f         // s3，“o”（o:0x6f）

栈的示意图，

	|----------| esp，低地址
	|s3 8Byte  | esp+0x12
	|----------|
	|s2 4Byte  | esp+0x18
	|----------|
	|s1 4Byte  | esp+0x1c
	|----------| 高地址

### 函数调用时的参数

{% highlight cpp %}
int main(int argc, char **argv) {
	/* ... */
	printf("%s",argv[1]);
	/* ... */
}
{% endhighlight %}

在gdb里执行上面的代码，执行时传入一个参数（`(gdb) run abc`）。调用`printf()`时的汇编代码片段如下，

	0x8048445 <main+40>     mov    eax,DWORD PTR [ebp+0xc]   // [ebp+0xc]是argv[]数组
	0x8048448 <main+43>     add    eax,0x4                   // 加4，argv+1，就是argv[1]的地址
	0x804844b <main+46>     mov    eax,DWORD PTR [eax]       // 把eax设成argv[1]的值，就是字符串“abc”的地址
	0x804844d <main+48>     mov    DWORD PTR [esp+0x4],eax   // printf的参数argv[1]入栈
	0x8048451 <main+52>     mov    DWORD PTR [esp],0x8048500 // printf的参数"%s"入栈，0x8048500是字符串"%s"的地址
	0x8048458 <main+59>     call   0x80482f0 <printf@plt>

在程序执行到`call   0x80482f0 <printf@plt>`指令时，检查一下寄存器和内存的状态，验证一下上面的判断。

	(gdb) info registers eax
	eax            0xffffd0b8       -12104
	(gdb) x/w $eax
	0xffffd0b8:     0xffffd2a6
	(gdb) x/16bx 0xffffd2a6
	0xffffd2a6:     0x61    0x62    0x63    0x00  确实是字符串"abc" ...
	0xffffd2ae:     略...
	(gdb) x/16bx 0x8048500
	0x8048500:      0x25    0x73    0x00  字符串"%s" ...
	0x8048508:      略...

栈的示意图，

	|----------------------| 
	|printf的参数1，"%s"    | esp，低地址
	|----------------------|
	|printf的参数2，argv[1] | esp+0x4
	|----------------------|
	| ...                  | 高地址

### 格式化字符串存在的安全问题
下面的代码允许用户传入格式化字符串，这会产生安全问题。

{% highlight cpp %}
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
   	int magic = 0xbad15bad;
   	char *str = (char *)malloc(20);
   	memset(str, 0, 20);

   	printf(argv[1]); /* 允许用户传入格式化字符串 */

   	printf("now str is :%s\n", str);

   	return 0;
}
{% endhighlight %}

##### 通过格式化字符串查看内存内容
用下面的参数执行程序，

	$ ./a.out %#x_%#x_%#x_%#x_%#x_%#x_%#x_%#x_
	0_0x14_0xf75cf10d_0xf77433c4_0xf7781000_0x87eb008_0xbad15bad_0x80484f0_now str is :

可以看到局部变量`magic`被打印出来了。
<!--more-->

`printf(argv[1])`执行时，栈的示意图如下，

	|--------------| 低地址
	|printf的参数1  | 
	|--------------|
	| ...          |
	|--------------|
	|str   4 bytes | 
	|--------------| 
	|magic 4 bytes |
	|--------------| 高地址

`printf`会认为它的第一个参数的“下方”（高地址方向）就是它的可变长度参数列表；所以，只要传入的格式化字符串足够长，
就能打印出`magic`变量。可以看到`“%#x_%#x_%#x_%#x_%#x_%#x_%#x_%#x_”`中的第7个“%#x”打印出了`magic`变量的值。

`%#x`中的`x`表示以16进制形式打印整数；`#`则在16进制整数前面加上`0x`。详见`man 3 printf`。

##### 通过格式化字符串修改内存内容
目标是通过传入一个精心构造的格式化字符串，使得字符串`str`的内容被修改成`"bad"`。

格式化字符串中的`%n`可以让`printf()`把它在遇到`%n`前所输出的字符的数量写入到一个内存地址（`int *`）中。比如，

{% highlight cpp %}
int count = 0;
printf("123456789%n", &count);  /* count的值会被printf设为9 */
{% endhighlight %}

格式化字符串中的第7个`%`对应`magic`变量，前一个`%`（第6个）对应的就是`str`变量。因为`str`变量实际上是个
内存地址（`char *`指针），所以把第6个`%`变成`%n`就能修改`str`指向的内存内容。

`str`指向一块长度为20字节的内存，要把它的前4个字节修改成下图所示的内容，

	 --------------------------------------------
	| 1       | 2        | 3       | 4 | ... | 20| 
	 --------------------------------------------
	| b (0x62)| a (0x61) | d (0x64)| 0 | ... | . |
	 --------------------------------------------

当`%n`写`str`指向的内存时，它会认为`str`是`int *`类型的指针，也就是`%n`会把一个整数写入`str`所指内存的
前4个字节。因为我的机器的字节序（Byte Order）是Little Endian，所以前4个字节对应的整数是`0x646162`（`0x00646162`）。
也就是说`printf`在遇到`%n`前应该先输出`0x646162`个字符。简单算一下`0x646162`对应的10进制值，

    $ echo $((0x646162))
    6578530

格式化字符串`%#010x`中的`#`表示打印16进制整数时加上`0x`前缀，`0`表示如果指定了宽度时用0来做填充，`10`表示
输出宽度是10个字符，`x`表示16进制打印；所以整数`0x62`会输出成`0x00000062`。

现在我们给可执行程序传入如下的字符串，

	./a.out %#010x_%#010x_%#010x_%#010x_%#06578485x_%n_%#010x_
            11     +11    +11    +11    +6578485   +1 = 6578530

在程序打印了一大堆`'0'`后，可以看到打印出的`str`字符串已经被修改成`"bad"`了。

### 总结
所以，不要让用户传入格式化字符串。现代的编译器发现这类可疑代码时会警告你；所以不要关闭编译器的warning。另外，
OS X上的`man 3 printf`就有一个专门的章节讲了`printf`家族存在的安全性问题。

C语言经常被人诟病不安全是有原因的。


[1]: http://www.cplusplus.com/reference/cstdarg/va_start/ "var arg"
[2]: /buffer-overflow-poc.html "buffer overflow"


<!--   other draft info below
## http://blog.aaronballman.com/2012/06/how-variable-argument-lists-work-in-c/
可变参数的实现

Because va_start needs the exact location of the parameter, it is a macro instead of a function

va_end is called when completed to clean up

function taking a variable argument list must be declared as __cdecl because the caller is the only one who knows how to properly clean up the call stack (the callee doesn’t know how many parameter were passed to it, remember?)

里面的一条评论里还讨论了在以寄存器传参数的cpu上，平台上，是怎么实现va_start的

## 如果在Ubuntu上 -m32 有问题， 报错误 fatal error: sys/cdefs.h: No such file or directory
you can try to install the package libc6-dev-i386
http://askubuntu.com/questions/470796/fatal-error-sys-cdefs-h-no-such-file-or-directory


## github上有很多 gcc ，glic的源码（镜像），可以看看
比如
https://github.com/gcc-mirror/gcc

官方
https://gcc.gnu.org/about.html#cvs


-->
