---
published: false
# MUST HAVE BEG
layout: post
disqus_identifier: 20130516-backtrace-and-addr2line # DON'T CHANGE THE VALUE ONCE SET
title: backtrace函数和addr2line工具
# MUST HAVE END

subtitle:
tags: 
- Linux
date: 2013-05-16 22:00:00
image: xxx	
image_desc: xxx
---


异常间接，来自primer里的内容和概念
unwinding
local is free。 pointer not
exception object
reference
initializer and try
析构函数 和异常
RAII

异常的实现。



有些时候（比如debug或者抛异常的时候），你希望得到当前函数的调用栈。使用backtrace函数和addr2line程序可以达到这一目的。backtrace是GNU提供的C标准库中的一个函数；addr2line则是GNU提供的二进制工具集Binutils中的一个程序。  

int backtrace (void **buffer, int size)   
The backtrace function obtains a backtrace for the current thread, as a list of pointers, and places the information into buffer. 

addr2line translates addresses into file names and line numbers.

一张图


int
__backtrace (array, size)
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

      array[cnt++] = current->return_address;

      current = ADVANCE_STACK_FRAME (current->next);
    }

  return cnt;
}


一个异常的示例程序



+++++++
我的XCode版本是4.6.2。

新建一个C++工程的步骤如下，  
第一步，打开“File”->“New”->“Project…”，在弹出的选择模版的对话框中选择“OS X”->“Application”->“Command Line Tool”，如图   
![xcode c++ step1](../images/blog/xcode-cpp-step1.png "xcode c++ step1")

第二部，填好工程名字（Product Name）；在“Type”下拉列表中选择“C++”；取消选择“Use Automatic Reference Counting”（Apple应该没有为C++提供ARC的吧），如图    

完成，新的C++工程就建好了。

待做——向XCode中导入已经存在的C++工程。  
[http://stackoverflow.com/questions/5034286/import-existing-c-project-into-xcode-ide](), Do more search.


========

