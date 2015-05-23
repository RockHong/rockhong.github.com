---
# MUST HAVE BEG
layout: post
disqus_identifier: 20130511-intro-of-elf # DON'T CHANGE THE VALUE ONCE SET
title: ELF简介
# MUST HAVE END

subtitle:
tags: 
- Linux
date: 2013-05-11 14:34:00
image: 217px-elf-layout.png	
image_desc: ELF layout
---
在Unix/Linux中，可执行文件、目标文件（.o）、共享库（.so）等一般都是ELF（Executable and Linkable Format）格式的。一个ELF文件的大致结构如下所示，  

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/217px-elf-layout.png" alt="ELF layout">
</div>

首先是ELF header，它描述了这个ELF文件的概况，比如数据的编码方式、ELF文件的类型、program header和section header的起始位置(起始字节)等。ELF header同时还指定了自身的长度，一般而言是64字节（byte）；之后，就是program header。  
readelf命令可以用来检查ELF文件的内容。查看ELF header的命令如下，      
<!--more-->

	[hong@localhost elf]$ readelf -h exe
	ELF Header:
	  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 #ELF文件的mgaic number
	  Class:                             ELF64
	  Data:                              2's complement, little endian #补码，小端编码
	  Version:                           1 (current)
	  OS/ABI:                            UNIX - System V
	  ABI Version:                       0
	  Type:                              EXEC (Executable file) #可执行文件
	  Machine:                           Advanced Micro Devices X86-64
	  Version:                           0x1
	  Entry point address:               0x400390 #第一条指令的地址
	  Start of program headers:          64 (bytes into file) 
	  Start of section headers:          2416 (bytes into file)
	  Flags:                             0x0
	  Size of this header:               64 (bytes) #ELF header长度为64字节
	  Size of program headers:           56 (bytes)
	  Number of program headers:         8
	  Size of section headers:           64 (bytes)
	  Number of section headers:         30
	  Section header string table index: 27
	
ELF header之后是两张表和多个section，依次排列为——首先是program header table，然后紧接着多个section，最后是section header table。  
program header table中的信息可以告诉操作系统在运行该ELF文件时应该如何加载这个ELF文件。通过如下命令可以查看program header table的信息，

	[hong@localhost elf]$ readelf -l exe
	 
	Elf file type is EXEC (Executable file)
	Entry point 0x400390
	There are 8 program headers, starting at offset 64
	 
	Program Headers:
	  Type           Offset             VirtAddr           PhysAddr
	                 FileSiz            MemSiz              Flags  Align
	  PHDR           0x0000000000000040 0x0000000000400040 0x0000000000400040
	                 0x00000000000001c0 0x00000000000001c0  R E    8
	  INTERP         0x0000000000000200 0x0000000000400200 0x0000000000400200
	                 0x000000000000001c 0x000000000000001c  R      1
	      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
	  LOAD           0x0000000000000000 0x0000000000400000 0x0000000000400000
	                 0x000000000000062c 0x000000000000062c  R E    200000
	  LOAD           0x0000000000000630 0x0000000000600630 0x0000000000600630
	                 0x00000000000001e4 0x0000000000000200  RW     200000
	  DYNAMIC        0x0000000000000658 0x0000000000600658 0x0000000000600658
	                 0x0000000000000190 0x0000000000000190  RW     8
	  NOTE           0x000000000000021c 0x000000000040021c 0x000000000040021c
	                 0x0000000000000044 0x0000000000000044  R      4
	  GNU_EH_FRAME   0x0000000000000588 0x0000000000400588 0x0000000000400588
	                 0x0000000000000024 0x0000000000000024  R      4
	  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
	                 0x0000000000000000 0x0000000000000000  RW     8
	 
	 Section to Segment mapping:
	  Segment Sections...
	   00     
	   01     .interp 
	   02     .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt .text .fini .rodata .eh_frame_hdr .eh_frame 
	   03     .ctors .dtors .jcr .dynamic .got .got.plt .data .bss 
	   04     .dynamic 
	   05     .note.ABI-tag .note.gnu.build-id 
	   06     .eh_frame_hdr 
	   07 
  
注意类型为LOAD的两个segment，在ELF文件被执行时它们会被加载到内存中。以第一个类型为LOAD的segment为例，它会被加载到内存中以地址（虚拟地址）0x0000000000400000起始，长度为0x000000000000062c的区域。可以看到这个segment中包含了.text（代码段），所以代码段在运行时会被加载到内存中。另外，地址0x0000000000400000是程序运行时的最低虚拟地址，如果是32位系统，则是0x08048000。

ELF文件的大部分信息都在它的各个section里，典型的section有,

- .text：编译成机器码的程序指令。使用objdump -d elf-file-name命令，可以对.text进行反汇编。  
- .data：已经初始化的全局变量。函数体内的局部变量是在运行时在栈上分配的，不会出现在这个section里
- .bss：没有做初始化的全局变量。因为未作初始化的全局变量一律被设置成“0”，所以.bss没有必要存储这些变量的值；只需知道这个变量属于.bss，自然就知道它的值——“0”。.bss仅仅是一个占位符，不会在ELF文件中耗费空间。
- .symtab：存放了程序中定义和引用的函数和全局变量（同样地，不含局部变量）信息。无论是否在编译时加上了debug选项（-g），这个section都会存在。使用readelf -s elf-file-name命令，可以查看符号表。
- debug相关的section，包括.debug，.line等
-重定位/链接相关的section，.o类型的ELF文件中会包含.rel.text，.rel.data等section，它们告诉链接器在生成一个可执行文件时如何重定位被引用的符号的地址。

ELF文件的最后一块信息是section header table。通过这张表可以知道各个section在ELF文件中的起始位置、长度等信息。可以通过readelf -S elf-file-name命令查看section header table，

###ELF与链接
ELF文件格式被设计成可以满足分离编译和链接的要求。在链接多个.o类型的ELF文件为单个可执行的ELF文件时，需要注意链接器所使用的规则。规则如下，  
链接器认为函数和已初始化的全局变量为强符号，未初始化的全局变量是弱符号；则，  
1 不允许出现强符号的重复定义  
2 如果定义了一个强符号和多个弱符号，那么引用时会选择引用强符号   
3 如果有多个同名弱符号的定义，那么引用时会任意选择   
当链接器默默地引用规则2或者3时，可以会导致意想不到的行为。提高链接时的警告级别，可以发现潜在的问题。强弱符号可以通过nm命令查看。

另外在链接多个静态库时，如果相同名字的符号在多个静态库中被定义，那么这些库在链接时的排列顺序会影响符号的重定位。
	
###常用的检查ELF文件的工具
ar、ldd、nm、objdump、od、readelf、strings、strip


注意：以上讨论的ELF文件是基于C语言编译而来。

参考：  
《深入理解计算机系统/Computer Systems A Programmer's Perspective 2nd Edition》  
《Binary Hacks》  
[http://en.wikipedia.org/wiki/Executable_and_Linkable_Format]()  
[http://stackoverflow.com/questions/7187981/whats-the-memory-before-0x08048000-used-for-in-32-bit-machine]()


