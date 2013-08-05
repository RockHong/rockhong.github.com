---
published: false


# MUST HAVE BEG
layout: post
disqus_identifier: 20130730-a-interview-question-search-on-shifted-array # DON'T CHANGE THE VALUE ONCE SET
title: 一道面试题：平移后的数组的搜索问题
# MUST HAVE END

subtitle:
tags: 
- interview
date: 2013-07-30 13:16:00
image:
image_desc:
---

##default constructor
如果用户没有定义ctor，那么一个默认构造函数会implicited declared。但是，implicited declared的ctor是trivial的。。。 实际上并没有合成出来。。通过nm是看不到的。。
（反之，只要用户随便定义了一个ctor（无论是default ctor，copy ctor，还是带参数的ctor），就不会合成ctor了。。）

class Apple {
public:
    int i;
};

Apple a;  不会有默认构造函数合成出来。。。

todo：标准是怎么说的？
todo： Apple a； 对应的汇编是怎么样的？
todo：int i会是什么值？


---
class Grape {
public:
    Grape():i(0) {}
private:
    int i;
};

class Watermelon {
    Grape g;
    int i;
};

Watermelon w；  //todo:  没有这句话，会合成默认构造函数么？估计不会。。

类（Watermelon）的数据成员有默认构造函数，这时会合成？
todo：如果类的数据成员有其他构造函数但是没有默认构造函数呢，会怎样？ 估计会error。。
合成出来的默认构造函数，只会调用Grape的默认构造函数，不会为i做任何东西

如果类已经定义了构造函数，比如，
Watermelon() {
  int i;
  }
这时，编译器会扩张、改写这个ctor，  在用户代码前before user code加上调用Grape的default ctor。
如果有多个类似g的成员变量，那么按声明顺序构造他们。。 在用户代码之前。

---
一个类是派生类，而且派生类有default ctor。  那么会合成non-trivial的default ctor


---
有虚函数的类
如果一个类有虚函数，那么这个类会有虚表，虚表里有这个类的虚函数们的地址；如果类重新定义了虚函数那么就更新一下entry。要不用基类（如果有的话）的虚函数的地址
这个类需要一个构造函数（如果用户没有定义的话），在里面让this->vptr指向这个基表。


---
带有virtual base class的class


---

总结： todo：看看p47

---

## copy ctor

## program transformation semantics

## member initialization list