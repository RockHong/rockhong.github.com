---
# MUST HAVE BEG
layout: post
disqus_identifier: 20131104-type-casting-in-cpp # DON'T CHANGE THE VALUE ONCE SET
title: C++中的类型转换
# MUST HAVE END

subtitle:
tags: 
- c++
date: 2013-11-04 20:17:00
image:
image_desc:
---

C++在C风格的类型转换（Type Cast）之外，引入了4种新的类型转换操作符：`dynamic_cast`、`reinterpret_cast`、`static_cast`和`const_cast`，它们能完成C风格类型转换相似的功能，也有C风格类型转换所不具有的能力。最近，在面试的时候被问到了`dynamic_cast`相关的问题，所以就借机做一下总结。


### 类型和转换
类型可以简单分为3种类型，基本类型（比如int，double等）、指针类型和类类型（指C++中的class，或者C中的结构体）。     
对于C语言来说，程序员可以在基本类型之间、指针之间、或者基本类型和指针之间（比如指针和整数之间）进行隐式的或者显式的（强制的）转换。     
对于C++语言来说，由于单参数构造函数和operator函数的存在，程序员还可以在基本类型和类类型之间做隐式的或者显式的转换。

<!--more-->

### dynamic_cast
`dynamic_cast <new_type> (expression)`

有实际意义的使用情形如下：

    class Base { virtual void f() {} };
    class Derived:public Base {};
    
    int main(int argc, char** argv)
    {
        Derived d;

        Base *pb = &d;
        Base &rb = d;

        Derived *pd = dynamic_cast<Derived *>(pb); // #1
        Derived &rd = dynamic_cast<Derived &>(rb); // #2

        return 0;
    }


类是多态的，即类有至少一个虚函数       
`dynamic_cast <new_type> (expression)`中的`expression`是类类型的指针或者引用，它实际指向的对象是一个“多态类”     
我们想要知道下面这个问题的答案——*这个基类类型的指针或者引用是不是指向`new_type`类型的对象*？     
我们通过检查“#1”中的pd的是不是为NULL或者执行“#2”行有没有抛出异常来判断上面问题的答案    

####dynamic_cast的实现

`dynamic_cast`需要使用RTTI（Run-Time Type Information）来检查指针或者引用所指对象的具体型别。RTTI一般和这个类的虚函数信息存放在一起。所以，`Derived *pd = dynamic_cast<Derived *>(pb);`的实现类似如下伪代码：   
     
    if (pb->vptr->my_actual_type == "Derived *")
         pd = pb;
    else
         pd = NULL;
可以看出dynamic_cast是有一定开销的。


#### dynamic_cast的其他使用情形（相比之下，在这些情形下使用dynamic_cast没有太大的实际意义）
在普通的指针上使用，会编译错误

    int main(int argc, char **argv)
    {
        int i;
        int *pi = &i;
        double *pd = dynamic_cast<double *>(pi);

        return 0;
    }


    error: cannot dynamic_cast ‘pi’ (of type ‘int*’) to type ‘double*’ (target is not pointer or reference to class)   
因为编译器认为普通的指针不可能指向一个带有RTTI信息的对象（虽然通过强制类型转换，普通的指针也能指向一个多态类对象），所以报错。

在非多态类的指针或者引用上使用，尝试将一个基类类型的指针或者引用转换成一个子类类型的指针或者引用，会编译错误

    class Base {};
    class Derived:public Base {};
    
    int main(int argc, char **argv)
    {
        Derived d;
        Base *pb = &d;
        Derived pd = dynamic_cast<Derived *>(pb);

        return 0;
    }


    error: cannot dynamic_cast ‘pb’ (of type ‘class Base*’) to type ‘class Derived*’ (source type is not polymorphic)   
因为编译器发现pb的类型是“Base”，而Base类并不是多态类，没有RTTI，所以编译器报错。


尝试将一个子类类型的指针转换为基类类型的指针

    class Base {};
    class Derived:public Base {};
    
    int main(int argc, char **argv)
    {
        Derived *pd;
        Base *pb = dynamic_cast<Base *>(pd);

        return 0;
    }

这个时候dynamic_cast会退化到static_cast，它的值在编译期间就能决定，不会有运行时的开销。这点从上面的实例程序里可以看出，Base和Derived类并没有RTTI，所以如果dynamic_cast要在运行时发生动作的话，编译器首先会报错，运行时也会因为pd没有vptr而产生运行错误。但是，实际上编译期间和运行期间都没有报错

在两个“无关”的多态类的指针或引用间做转换

    class A {virtual void f1(){}};
    class B {virtual void f2(){}};
    
    int main(int argc, char **argv)
    {
        A *pa = new A();
        B *pb = dynamic_cast<B *>(pa);
    
        return 0;
    }
编译和运行都不会产生错误，只是转换会永远失败。

### static_cast
当`static_cast <new_type> (expression)`中的表达式是不同的类型时，会有不同的行为。

当`expression`和`new_type`都是类类型的指针，并且互相转换的类型之间有“关系”（即基类、子类关系）时，static_cast操作符就可以编译成功，且不会在运行时再有额外的检查（即编译器不会检查`expression`指向的对象是不是真的是`new_type`类型的）。在这种情况下，可以说static_cast是dynamic_cast的弱化版本；即编译器仅仅通过编译期间存在信息检查指针的类型之间是否有“表面上的关系”，不会有运行时的开销。

    #include <iostream>
    using namespace std;
    
    class Base {};
    class Derived:public Base {};
    
    int main(int argc, char **argv)
    {
        Base b;
        Derived d;
        Base *pb;
        Derived *pd;

        pd = &d;
        pb = static_cast<Base *>(pd); // #1
        cout <<"pd=" <<pd <<" " <<"pb=" <<pb <<endl;

        pb = &b;
        pd = static_cast<Derived *>(pb); // #2
        cout <<"pd=" <<pd <<" " <<"pb=" <<pb <<endl;

        return 0;
    }
对于“#1”，将子类指针转换成基类指针，static_cast毫无疑问会成功；对于“#2”，将一个实际上指向基类对象的基类指针转换成子类指针，也会编译成功，编译器不会关心运行期间pb实际上不是指向一个子类对象。


当`expression`和`new_type`都是类类型的指针，但是互相转换的类型之间没有“关系”。编译器会在编译期间发现它们并没有什么关系，然后报错。

    #include <iostream>
    using namespace std;
    
    class A {};
    class B {};
    
    int main(int argc, char **argv)
    {
        A *pa = new A();
        B *pb = static_cast<B*>(pa);

        return 0;
    }


    error: invalid static_cast from type ‘A*’ to type ‘B*’

当static_cast作用于普通类型的指针时，编译会报错。

    int main(int argc, char **argv)
    {
        int *pi = new int(0);
        double *pd = (double *)pi; // #1
        pd = reinterpret_cast<double *>(pi); // #2
        pd = static_cast<double *>(pi); // #3 
    
        return 0;
    }
“#3”行会编译出错：`error: invalid static_cast from type ‘int*’ to type ‘double*’`      
可以看出来static_cast和C风格的类型转换并不等价；实际上，这里使用reinterpret_cast才能达到C风格的类型转换的效果。


当作用于非指针类型的时候，如果隐式转换是可以的，那么使用static_cast也会成功（通过编译）。

      1 class A {};
      2
      3 class B{
      4 public:
      5         B(int i) {}
      6         operator int() { return 1;}
      7         operator A() { return A();}
      8 };
      9
     10 int main(int argc, char **argv)
     11 {
     12         int i;
     13         double d = static_cast<double>(i); // #1，非指针的基本类型
     14
     15         A a;
     16         B b = static_cast<B>(i); // #2
     17         A a2 = static_cast<A>(b); // #3
     18         int i2 = static_cast<int>(b); // #4
     19        
     20         return 0;
     21 }
上面这个程序可以通过编译。


作用于非指针类型，而且要转换的类型之间没有不存在隐式转换的桥梁，那么进行static_cast会导致编译器报错。

    class A{};
    class B{};
    
    int main(int argc, char **argv)
    {
        A a;
        B b = static_cast<B>(a);

        return 0;
    }

`error: no matching function for call to ‘B::B(A&)’`     

实际上，在C语言中也是不允许两个“类”（结构体）之间做强制类型转换的。

    struct A{};
    struct B{};
    
    int main(int argc, char **argv)
    {
        struct A a;
        struct B b = (struct B)a;

        return 0;
    }

`error: conversion to non-scalar type requested`       
只是报错信息不一样，C语言不允许在“非标量”（举例来说，结构体是一种“非标量”；int则是一种“标量”类型﻿）之间做转换。  


### reinterpret_cast 
`reinterpret_cast`可以让编译器将一种类型的指针转换成另外一种类型的指针。它不会像static_cast那样尝试在编译期间去检查两个指针之间的关系；也不会像dynamic_cast那样尝试在运行期间去检查一个指针指向的对象是不是真的指向某个类型的对象。它只是简单把一个指针的值拷贝到另一种类型的指针。     
另外，reinterpret_cast也可以在指针和整数类型之间做转换。但是将指针转换为整数得到的值是平台相关的，唯一的保证是如果用户提供的整数类型足够大可以容得下转换后的值，那么再将这个整数值转换回指针时，指针的值和原来的值是一样的。     
除此之外，使用reinterpret_cast会导致编译失败。

    #include <iostream>
    using namespace std;
    
    class A {};
    class B {};
    
    int main()
    {
        int *pi = new int(0);
        double *pd = reinterpret_cast<double *>(pi); // #1
    
        A *pa = new A();
        B *pb = reinterpret_cast<B *>(pa); // #2
    
        int i = reinterpret_cast<int>(pi); // #3
        int *pi2 = reinterpret_cast<int *>(i); // #4
        cout <<pi <<", " <<pi2 <<", equal?" << (pi == pi2 ? "yes" : "no") <<endl;
    
        A a;
        i = reinterpret_cast<int>(a); // #5
        double d = reinterpret_cast<double>(i); // #6
    
        return 0;
    }

"#1"在普通指针之间做转换，没有问题。                
"#2"在“无关”的类类型的指针之间做转换，没有问题。        
"#3"和"#4"在指针和整数类型之间做转换，没有问题，可以通过编译。        
"#5"和"#6"尝试在两个非指针类型之间做转换，编译失败。

    error: invalid cast from type A to type int，error: invalid cast from type int to type double

### const_cast
`const_cast`作用在指针或者引用上，用来去掉（或者加上）所指对象的const属性。

    int main(int argc, char **argv)
    {
        const char *pcc = "hello";
        //char *pc = pcc;
        char *pc = const_cast<char *>(pcc); // #1
    
        pcc = const_cast<const char *>(pc);  // #2
        pcc = pc; // #3
    
        const int ci = 0;
        //int i = const_cast<int>(ci); // #4
        int i = ci; // #5
        const int ci2 = i; // #6
    
        return 0;
    }

"#1"去掉所指的对象的const属性。            
"#2"加上const属性。但是，实际上这种转换是没有必要的。因为，用户总是可以直接将一个非const类型的指针赋给一个const类型的指针，见"#3"。        
"#4"如果去掉注释会导致编译失败。

    error: invalid use of const_cast with type int, which is not a pointer, reference, nor a pointer-to-data-member type
实际上，也没有必要在const对象和非const对象之间做任何的转换，实际上"#5"和"#6"这样的值拷贝总是会成功的。        


### C风格的显式（强制）类型转换和C++的4种类型转换的比较
dynamic_cast在运行时的能力是C风格类型转换所不具备的。                
static_cast在转换类类型的指针时，会在编译期间检查指针是否有“关系”，这种能力也是C风格类型转换所不具备的。            
除此之外，C风格类型转换的能力可以看成是static_cast、reinterpret_cast和const_cast的总和。但是在遇到“有风险”的类型转换时，C语言编译器和C++语言编译器会有不同的态度。    

    int main(int argc, char **argv)
    {
        const char *pcc = "hello";
        /* char *pc = pcc; */
        char *pc = (char *)pcc; // #1
    
        return 0;
    }

如果把上面C程序中的注释行解开，C编译器会在编译时给出警告， 

    warning: initialization discards qualifiers from pointer target type
但是，编译器还是可以成功地产生可执行文件。“#1”加上显式的类型转换只是告诉编译器——“我了解该类型转换存在的风险，我是有意为之，请不要给出警告”。        

但是在C++语言中，相同的程序

    int main(int argc, char **argv)
    {
        const char *pcc = "hello";
        char *pc = pcc;
    
        return 0;
    }

编译器出报错，不会产生可执行文件，

    error: invalid conversion from const char* to char*        
最后，无论是C风格的类型转换还是C++的类型转换，都不能进行“任意的”类型转换。比如，在C语言中，程序员不能在基本类型和结构体类型之间做转换（编译器会报错:

    error: aggregate value used where an integer was expected
）；同样的，如果不存在隐式转换的桥梁，C++也不能完成类似的转换。


### type_id和type_info
在dynamic_cast中会用到RTTI，type_id和type_info是RTTI相关的两个概念。            
`typeid (expression)`            
可以把`typeid`看成是函数调用或者是一个操作符，它会返回一个类型为`type_info`的const对象的引用。实际上，每种类型都只有一个const的type_info对象，对该类型的任意对象做typeid操作，都返回同一个type_info对象。
类型type_info定义在头文件`<typeinfo>`中，它的公共接口有：`operator==()`，`operator!=()`，`name()`。            
typeid的行为和`expression`的类型相关。如果expression的类型是非多态类，那么typeid操作符的返回值在编译期间就决定了，这通过下面的程序可以看出来，

    #include <typeinfo>
    #include <iostream>
    using namespace std;
    
    class A {};
    class B:public A{};
    
    int main(int argc, char **argv)
    {
        A a;
        A *pa = &a;
        cout <<typeid(a).name() <<endl; // #1
        cout <<typeid(pa).name() <<endl; // #2
        cout <<typeid(*pa).name() <<endl; // #3
    
        A *pa2 = new B();
        cout <<typeid(*pa2).name() <<endl; // #4
    
        A *pa3 = NULL;
        cout <<typeid(*pa3).name() <<endl; // #5
    
        return 0;
    }

运行结果，            

    1A
    P1A
    1A
    1A
    1A

注意，`name()`的返回值是平台相关的，不同的平台可能有不同的返回值。从“#2”可以看出，如果你传入一个指针，typeid会告诉返回一个字符串说明传入的东西是指针类型的。从“#4”和“#5”，特别是“#5”可以看出，对于非多态类类型，typeid操作符是编译时决定的，编译器仅仅会看传入参数的“字面上的类型”，然后返回该类型的type_info引用。因为，pa3是空指针，如果typeid有任何运行时行为的话，程序就会出错。        

下面看，typeid对于多态类的行为，

    #include <typeinfo>
    #include <iostream>
    using namespace std;
    
    class A {virtual void f(){}};
    class B:public A{};
    
    int main(int argc, char **argv)
    {
        A a;
        A *pa = &a;
        cout <<typeid(a).name() <<endl;
        cout <<typeid(pa).name() <<endl;
        cout <<typeid(*pa).name() <<endl;
    
        A *pa2 = new B();
        cout <<typeid(*pa2).name() <<endl; //#1
    
        A *pa3 = NULL;
        cout <<typeid(*pa3).name() <<endl; // #2
    
        return 0;
    }

运行结果，

    1A
    P1A
    1A
    1B
    terminate called after throwing an instance of 'std::bad_typeid'
      what():  std::bad_typeid
    Aborted (core dumped)

对于多态类，编译器会在类的*“虚表，virtual table”*里存储这个类的type_info信息。可以看到，对于"#1"，typeid操作符通过在运行时去找该对象的type_info信息，从而知道\*pa2虽然字面上的类型是A，但是实际上的类型是B。对于“#2”，由于pa3是空指针，typeid操作符会抛异常。所以，在使用typeid时如果需要解引指针，应该加上*try……catch*语句。


###参考资料：
[http://www.cplusplus.com/doc/tutorial/typecasting/]() 
  



