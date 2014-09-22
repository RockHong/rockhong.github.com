---
# MUST HAVE BEG
layout: post
disqus_identifier: 20130706-name-space-in-c-language # DON'T CHANGE THE VALUE ONCE SET
title: C语言中的名字空间
# MUST HAVE END

subtitle:
tags: 
- C
date: 2013-07-07 00:30:00
image:
image_desc:
---
《The Standard C Library》（《C标准库》）中有一道习题，0.2 编写一个包含下面这行代码的（正确的）程序：    
`x: ((struct x*)x)->x = x(8);`    
描述x的5个不同的用途。

下面是一个答案，

    #include <stdlib.h>
    #include <stdio.h>
	
	#define x(a) ((a)*(a))
	
	struct x {
	    int x;
	};
	
	int main(int argc, char **argv)
	{
	    void *x = malloc(sizeof(struct x)); 
	    goto x;
	
	    x: ((struct x*)x)->x = x(8); /* THE LINE */
	    
	    printf("%d\n", ((struct x*)x)->x);
	    return 0;
	}
    	
这个程序能正确地编译、运行，其结果为64。     

可以看到程序中，同一个标识符（identifier）“x”在“行THE LINE”中出现了5次，但是编译器能正确地找出每个“x”标识符所指定实体（entity）。这是因为5个“x”（用于预处理器对宏的展开，实际上是4个“x”）分别属于不同的名字空间（name space）。不同名字空间中的实体可以使用相同的标识符；当然，同一名字空间里的不同实体也有可能使用相同的标识符，比如，

	int foo()
	{
		int bar;
		{
			double bar;
		}
	}
	
只是在inner scope里，int类型的`bar`是不可见的。

根据C语言的标准，有四种不同的名字空间。    
>If more than one declaration of a particular identifier is visible at any point in a 
>translation unit, the syntactic context disambiguates uses that refer to different 
>entities. Thus, there are separate name spaces for various categories of identifiers, 
>as follows:    
>如果在一个翻译单元（比如一个.c文件）里的某个点（比如某行代码），一个标识符出现了多次，那么编译器会尝试
>消除歧义，去找到每次出现所对应的实体。

>label names (disambiguated by the syntax of the label declaration and use);    
>所有标签名组成一个名字空间。编译器通过标签的语法（label:）来确认一个标识符是不是属于该名字空间。

>the tags of structures, unions, and enumerations (disambiguated by following any>of the keywords struct, union, or enum);    
>所有结构体、联合、枚举的名字组成一个名字空间。编译器通过关键字`struct`,`union`,`enum`来消除歧义。    

>the members of structures or unions; each structure or union has a separate name >space for its members (disambiguated by the type of the expression used to access the >member via the . or -> operator);    
>一个结构体或者联合里的成员的名字组成一个名字空间。编译器通过`.`或者`->`来消除歧义。

>all other identifiers, called ordinary identifiers (declared in ordinary >declarators or as enumeration constants).    >所有其它的标识符组成一个名字空间。

现在解释下编译器是怎么对`x: ((struct x*)x)->x = x(8);`消除歧义的。     
第一个“x”：     
看到x:，编译器知道这个“x”是一个标签名字。     
第二个“x”：    
看到struct x，编译器知道这个“x”是一个结构体名字。    
第四个“x”：    
看到`->`，编译器知道这个“x”是结构体中的某个成员名字。    
第五个“x”：    
通过`gcc -E file.c`，可以看到经过预处理后已经没有这个“x”了，预处理后的代码如下，    
`x: ((struct x*)x)->x = ((8)*(8));`    
第三个“x”：    
属于普通的名字空间中的一个标识符。    
可以看到编译器清楚地知道每个“x”的含义，所以编译能顺利地进行下去。    

如果把宏定义换成函数定义，即把    
`#define x(a) ((a)*(a))`    
换成    
`int x(a) { return a*a;}`    
那么编译会出错。    
因为在“行THE LINE”所在的scope中，指针“x”会令函数名“x”变得不可见。编译器会认为你把一个void \*指针当成了函数，于是报错：    
`error: called object ‘x’ is not a function`

C标准里说：

>Different entities designated by the same identifier either have different scopes, or are in different name spaces.     
>同一个标识符可以指定不同的实体，只要它们在不同的scope里，或者它们在不同的名字空间里。
所以定义两个都叫“x”的结构体，或者一个叫“x”的结构体和一个叫“x”的联合是错误的。同样的，在file scope里定义,

	int x;
	void x() { /* … */ }
也是错误的。

其它相关的C标准：

>There are four kinds of scopes: function, file, block, and function prototype.
>
>An identifier can denote an object; a function; a tag or a member of a structure, union, or enumeration; a typedef name; a label name; a macro name; or a macro parameter.
>
>Each subsequent instance of the function-like macro name followed by a ( as the next preprocessing token introduces the sequence of preprocessing tokens that is replaced by the replacement list in the definition (an invocation of the macro).    

上面的程序里定义的宏是一个“类函数”的宏，在预处理时当编译器看到`x(8)`形式的代码会进行展开；仅仅看到x不会展开。

《The Standard C Library》有一张表，

	+---+---+ INNERMOST BLOCK         FILE LEVEL
	|   |   |-----------------+     +----------------+
	|   |   |type definitions |     |type definitions|
	|   |   |functions        |     |functions       |
	| M | K |data objects     |     |data objects    |
	| A | E |enumeration      | ... |enumeration     |
	| C | Y +-----------------+     +----------------+
	| R | W |enumeration tag  |     |enumeration tag |
	| O | O |structure tag    |     |structure tag   |
	| S | R |union tag        |     |union tag       |
	|   | D +-----------------+-----+----------------+
	|   | S |members of a structure or union         |
	|   |   |parameters within a function prototype  |
	|   |   +----------------------------------------+
	|   |   |members of a structure or union         |
	|   |   |parameters within a function prototype  |
	|   |   +----------------------------------------+
	|   |   |                   ...
	|   |   +---------------------+
	|   |   | goto labels         |
	+---+---+---------------------+
>You can use a name only one way within a given name space. If the translator recognizes a name as belonging to a given name space, it may fail to see another use of the name in a different name space. In the figure, a name space box masks any name space box to its right.

左边盒子里的名字（标识符）会“覆盖”右边的名字。宏总是有最大的优先级，因为程序总是先进行预处理。其次是关键字，所以你不能将一个变量的标识符命名成某个关键字。另外，不同的scope中的名字也有不同的优先级，最里层的scope中的名字会“覆盖”外围scope中的同名标识符。


