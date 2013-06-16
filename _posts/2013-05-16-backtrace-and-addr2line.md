---
# MUST HAVE BEG
layout: post
disqus_identifier: 20130516-backtrace-and-addr2line # DON'T CHANGE THE VALUE ONCE SET
title: backtrace函数和addr2line工具
# MUST HAVE END

subtitle:
tags: 
- Linux
date: 2013-05-16 22:00:00
image:
image_desc:
---
有些时候（比如debug或者抛异常的时候），你希望得到当前函数的调用栈。使用backtrace函数和addr2line程序可以达到这一目的。backtrace是GNU提供的C标准库中的一个函数；addr2line则是GNU提供的二进制工具集Binutils中的一个程序。  

[`int backtrace (void **buffer, int size)`](http://www.gnu.org/software/libc/manual/html_mono/libc.html#Backtraces)   
The backtrace function obtains a backtrace for the current thread, as a list of pointers, and places the information into buffer.   
将当前线程的调用栈信息存放在buffer数组里；size为buffer数组的大小；如果实际的调用栈的大小（层数）小于size，那么返回实际的层数，否则返回size。

[`addr2line`](http://sourceware.org/binutils/docs/binutils/addr2line.html)  
Translates addresses into file names and line numbers.  
将地址信息翻译成相应的源文件名和行号。


###backtrace的实现
backtrace函数的定义在[glibc库](http://zh.wikipedia.org/zh-cn/GNU_C_%E5%87%BD%E5%BC%8F%E5%BA%AB)中backtrace.c文件中，是一个非常小巧的函数。   

	# define CURRENT_STACK_FRAME  ({ char __csf; &__csf; })
	//找到当前栈顶；这个宏仅用于下面的越界检查
	
	# define INNER_THAN <
	//栈是从高地址向低地址生长的。被调用者的栈地址小于调用者的栈地址
	
	# define ADVANCE_STACK_FRAME(next) ((struct layout *) (next))
	//layout结构定义于frame.h中
	struct layout
	{
	  void *next;
	  void *return_address;
	};
	//从定义可以看出next位于低地址，return_address位于高地址；这符合栈的约定
	+---------------+
	| 调用者的帧指针  |
	+---------------+
	| caller        |
	| 调用者         |
	|               |
	+---------------+
	| return address| <-- 调用者的返回地址
	+---------------+
	| next          | <-- next为调用者的帧指针
	+---------------+
	| callee        |
	| 被调用者       |
	| …             |
	
	# define FIRST_FRAME_POINTER  __builtin_frame_address (0)
	//一个gcc内建函数，返回寄存器ebp（帧指针）的值;传入参数0时，返回当前栈的帧指针
	//见http://gcc.gnu.org/onlinedocs/gcc/Return-Address.html

	int __backtrace (array, size)
	     void **array;
	     int size;
	{
	  struct layout *current;
	  void *top_frame;
	  void *top_stack;
	  int cnt = 0;
	
	  top_frame = FIRST_FRAME_POINTER;
	  top_stack = CURRENT_STACK_FRAME;

	  /* We skip the call to this function, it makes no sense to record it.  */
	  current = ((struct layout *) top_frame);
	  while (cnt < size)
	  {
	      if ((void *) current INNER_THAN top_stack
		  || !((void *) current INNER_THAN __libc_stack_end))
	       /* This means the address is out of range.  Note that for the
		  toplevel we see a frame pointer with value NULL which clearly is
		  out of range.  */
		break;
		//边界检查

      array[cnt++] = current->return_address;
      //将调用者的返回地址放入array数组中

      current = ADVANCE_STACK_FRAME (current->next);
      //current的值是被调用者（callee）的帧指针所对应的内存地址；
      //而这块内存中存放的(current->next)是调用者（caller）的帧指针所对应的内存地址
      //向高地址方向移动帧指针
	  }
	
	  return cnt;
	}


###简单的应用
一个简单的示例程序，实现一个异常类，这个异常类被抛出时记录了当时的调用栈信息。

	/* show_bt.cpp */
	#include <execinfo.h>
	#include <iostream>
	#include <string>
	#include <sstream>
	
	using namespace std;
	
	class MyException {
	public:
	   MyException();
	   virtual ~MyException();
	   virtual string show_backtrace() const;
	protected:
	   static const int BT_SIZE=64;
	   void * bt_info[BT_SIZE];
	   int bt_size;
	};
	
	MyException::MyException():bt_size(0) {
	   bt_size = backtrace(bt_info, BT_SIZE);
	}
	
	MyException::~MyException() {}
	
	string MyException::show_backtrace() const {
	   string bt_string;
	   ostringstream oss;
	   for (int i = 0; i < bt_size; ++i) {
	    oss << bt_info[i] <<" ";
	   }
	   bt_string = oss.str();
	   return bt_string;
	}
	
	void f1();
	void f2();
	void f3();
	
	void f1() { f2();}
	void f2() { f3();}
	void f3() { throw MyException(); }
	
	int main(int argc, char * argv[])
	{
	   try {
	    f1();
	   }
	   catch (const MyException &e) {
	    cout << e.show_backtrace() <<endl;
	   }
	
	   return 0;
	}


编译时打开调试选项（-g），addr2line程序需要可执行文件中的调试信息才能进行“翻译”。   

	$ g++ -g -o show_bt show_bt.cpp
运行程序输出如下，

	$ ./show_bt
	0x40109a 0x4010c8 0x401103 0x40110f 0x401127 0x2b196ec06994 0x400d89
将输出的调用栈地址信息传给addr2line程序，

	$ addr2line -f -C -e show_bt 0x40109a 0x4010c8 0x401103 0x40110f 0x401127 	0x2b196ec06994 0x400d89
	MyException
	/x/home/hohua/playground/backtrace/show_bt.cpp:20
	f3()
	/x/home/hohua/playground/backtrace/show_bt.cpp:43
	f2()
	/x/home/hohua/playground/backtrace/show_bt.cpp:41
	f1()
	/x/home/hohua/playground/backtrace/show_bt.cpp:39
	main
	/x/home/hohua/playground/backtrace/show_bt.cpp:48
	??
	??:0
	_start
	??:0

有时候，程序需要拷贝到远程主机运行。含有调试信息的程序体积太大，可以通过下面的命令“剥离”调试信息，

	objcopy --strip-all exe-debug exe-striped
得到调用栈的地址信息后，再在本地对含有调试信息的可执行文件运行addr2line命令。

TODO: Maybe need a better picture to illustrate...