---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150317-jit-in-simple # DO NOT CHANGE THE VALUE ONCE SET
title: JIT是怎么实现的
# MUST HAVE END

is_short: true
subtitle:
tags: 
- JIT
date: 2015-03-17 21:32:00
image:
image_desc:
---

JIT，Just In Time的缩写，就是在运行时把代码（字节码）编译成机器指令，然后直接执行机器指令来
提高运行效率。比如，如果一个函数在运行时被反复执行，那么可以把这个函数（对应的字节码）编译成
机器指令后直接执行对应的机器指令。

如何实现JIT？

一个可执行程序对应的机器指令是放在代码段（.text section）里的，运行时会被加载到内存里。CPU从
内存里取得机器指令，然后去执行。类似地，JIT就是把字节码转换成机器指令，放到一块内存里，然后
去执行这块内存里的指令。[这篇文章][1]给出了一个实现。

    //通过mmap分配一块内存
    //把权限设置成可读/写/执行，实际上为了安全应该是：刚刚分配的内存设置成可写的，
    //    等往里面写入机器指令后去掉可写权限，只保留可读和可执行权限
    //用mmap而不是malloc的原因是权限设置信息（protection bits）只能放在内存页的边界上，
    //    mmap分配的内存是从内存页边界开始的，而malloc分配则不一定。如果用malloc的话，
    //    要自己处理权限问题，会麻烦一点。
    void* alloc_executable_memory(size_t size) {
      void* ptr = mmap(0, size,
                       PROT_READ | PROT_WRITE | PROT_EXEC,
                       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
      if (ptr == (void*)-1) {
        perror("mmap");
        return NULL;
      }
      return ptr;
    }

    void emit_code_into_memory(unsigned char* m) {
      //机器指令
      unsigned char code[] = {
        0x48, 0x89, 0xf8,                   // mov %rdi, %rax
        0x48, 0x83, 0xc0, 0x04,             // add $4, %rax
        0xc3                                // ret
      };
      memcpy(m, code, sizeof(code));
    }

    const size_t SIZE = 1024;
    typedef long (*JittedFunc)(long);

    void run_from_rwx() {
      void* m = alloc_executable_memory(SIZE);
      emit_code_into_memory(m);

      JittedFunc func = m;
      //把内存地址当成函数地址直接去执行它
      int result = func(2);
      printf("result = %d\n", result);
    }


[1]: http://eli.thegreenplace.net/2013/11/05/how-to-jit-an-introduction/ "How to JIT - an introduction"
