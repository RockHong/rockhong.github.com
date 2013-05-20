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


search   “c++ exception implement gcc”

好文， http://static.usenix.org/events/osdi2000/wiess2000/full_papers/dinechin/dinechin_html/

http://gcc.gnu.org/wiki/WindowsGCCImprovements     讲了一点简单的

http://www.airs.com/blog/archives/166   可以一看

http://gnu.wildebeest.org/blog/mjw/2007/08/23/stack-unwinding/ 可以一看

http://mentorembedded.github.io/cxx-abi/   可以一看

http://www.hexblog.com/wp-content/uploads/2012/06/Recon-2012-Skochinsky-Compiler-Internals.pdf  可以一看

http://www.codeproject.com/Articles/69270/Better-exception-handling-for-C  很长的文章，可以一看

http://www.codeproject.com/Articles/2126/How-a-C-compiler-implements-exception-handling  可以一看

http://www.open-std.org/jtc1/sc22/wg21/docs/TR18015.pdf   technical  report

http://gcc.gnu.org/onlinedocs/libstdc++/manual/using_exceptions.html  讲了怎么使用exception  guide line



一些stackoverflow的答案，
http://stackoverflow.com/questions/307610/how-do-exceptions-work-behind-the-scenes-in-c    有汇编级别的代码
其他
http://stackoverflow.com/questions/490773/how-is-the-c-exception-handling-runtime-implemented
http://stackoverflow.com/questions/106586/what-are-the-principles-guiding-your-exception-handling-policy
http://stackoverflow.com/questions/1331220/c-try-throw-catch-machine-code
http://stackoverflow.com/questions/87220/how-does-gcc-implement-stack-unrolling-for-c-exceptions-on-linux
http://stackoverflow.com/questions/4975504/zero-cost-exception-handling-vs-setjmp-longjmp
http://stackoverflow.com/questions/691168/how-much-footprint-does-c-exception-handling-add