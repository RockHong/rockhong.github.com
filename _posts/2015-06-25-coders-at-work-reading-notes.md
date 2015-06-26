---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150625-coders-at-work-reading-notes # DO NOT CHANGE THE VALUE ONCE SET
title: 《Coders at Work》读后感
# MUST HAVE END

is_short: true
subtitle: 
tags: 
- 读书笔记
date: 2015-06-25 13:00:00
image: 
image_desc: 
---

没事的时候翻了《Coders at Work》的几个章节。看看对大师们的采访还是挺有意思的。《[Masterminds of Programming][1]》
也是一本很不错的采访录，不过它的主题偏向于语言设计；相比之下，《Coders at Work》的采访主题更宽泛一点。

### Joshua Bloch
*Google的首席Java架构师，设计和实现了Java Collections Framework，等等等等……*

> Seibel: Are there any books that every programmer should read?
> 
> Bloch: ... I still think everyone should read, is **Design Patterns**. It gives us a common vocabulary.
> There are a lot of good ideas in there.
>
> Another is **Elements of Style**, which isn’t even a programming
> book. ... for two reasons: The first is that a large part of every software engineer’s job is writing prose. 
>
> ... **The Art of Computer Programming**. In truth, I haven’t read the whole series or anything close to
> it. When I’m working on a particular algorithm, though, I go there to see what he has to say about it.
>
> Another old one is Frederick Brooks’s **The Mythical Man Month**. It’s 40 years old and still as true
> today as when it was written. ... Everyone should read that. The main message of the book is
> **“adding people to a late software project makes it later,”** and it’s still true.
> 
> These days, everybody has to learn about concurrency. So **Java Concurrency in Practice** is another good bet.
> 
> **Merriam-Webster’s Collegiate Dictionary, 11th Edition**. ... It’s not something you actually read,
> but as I said, when you’re writing programs you need to be able to name your identifiers well.

Bloch推荐了《设计模式》、《Java并发编程实战》；也推荐了一本写作相关的书（《[Elements of Style](http://book.douban.com/subject/1433835/)》，豆瓣上的评分是9.1/10）
和韦氏词典。优美、简洁的注释、文档和API需要良好的写作能力；同时一本词典可以让程序员在给类、变量、方法起名字时减少“词穷”
的尴尬。书里的很多被采访者都说没通读过《The Art of Computer Programming》，Bloch也是把它当成工具书和参考书；估计
Bloch在实现Java Collections Framework里的算法部分时翻了不少《The Art of Computer Programming》。

Bloch还推荐了《人月神话》。“adding people to a late software project makes it later” ，看来“C?O”或者每个有
power来分配资源和管理项目的人都应该好好读读。

>Seibel: What about other tools?
>
>Bloch: I’m not good with programming tools. I wish I were. The build and source-control tools change
>more than I would like, and it’s hard for me to keep up. So I bother my more tool-savvy colleagues
>each time I set up a new environment. 
>
>I’m not proud of this. Engineers have things that they’re good at and things they’re not so good at.

估计Bloch对maven、git之类的工具不熟、貌似也不想尝试精通他们，所以搞不定工具时就去问他的同事😅。对average people才
会要求每样都会点；如果你在某些点足够闪光，人们不会太关心那些你不擅长的东西。另外，就掌握一个工具而言，能满足daily usage
应该就可以了；时间总是一定的，可以把精通工具的时间花在“更有价值的”地方。

>Seibel: What’s your short list of ones you want to play with more?
>
>Bloch: I want to try Scala ... I should also play with Python

又一次说明了不用样样精通。Be focus，be specialised.

>Seibel: I was reading [Java Puzzlers](http://book.douban.com/subject/1882469/) 
>and [Effective Java](http://book.douban.com/subject/3998727/) and it struck me that there are a lot
of little weird corners for a language that started out so simple.
>
>Bloch: There are weird corners, yes, but that’s just a fact of life; all languages have them.
You haven’t seen a book called C Puzzlers. Why not?

*TODO: 有空看看这两本书，观摩一下java的“weird corners”。*

另外，Bloch在谈到他的编程风格、编程哲学时推荐了他自己的一个演讲，
“[How to Design a Good API and Why It Matters](https://www.youtube.com/watch?v=aAb7hSCtvGw)”；
在谈到测试时，推荐了Bentley的一篇论文，
“[Engineering a Sort Function](http://cs.fit.edu/~pkc/classes/writing/samples/bentley93engineering.pdf)”。
有空可以看看。 


### Ken Thompson
*发明了Unix、C语言、UTF-8编码……*

>Seibel: You print out invariants; do you also use asserts that check invariants?
>
>Thompson: Rarely. I convince myself it’s correct and then either comment out the prints or throw them away.

大师也是人，怎么方便怎么来。

>Seibel: You were at AT&T with Bjarne Stroustrup. Were you involved at all in the development of C++?
>
>Thompson: I’m gonna get in trouble. 
>
>Seibel: That’s fine.
>
>Thompson: I would try out the language as it was being developed and make comments on it. It was part of the work atmosphere there. And you’d write something and then the next day it wouldn’t work because the language changed. It was very unstable for a very long period of time. At some point I said, no, no more.
>
>In an interview I said exactly that, that I didn’t use it just because it wouldn’t stay still for two days in a row. **When Stroustrup read the interview he came screaming into my room about how I was undermining him and what I said mattered and I said it was a bad language.** I never said it was a bad language. On and on and on. Since then I kind of avoid that kind of stuff.

有人的地方就有江湖，all human live in social society, you cannot avoid it.

>Seibel: And are there development tools that just make you happy to program?
>
>Thompson: I love yacc. I just love yacc. It just does exactly what you want done. Its complement, Lex, is horrible. It does nothing you want done.
>
>Seibel: Do you use it anyway or do you write your lexers by hand? 
>
>Thompson: I write my lexers by hand. Much easier.

*待续*

[1]: http://book.douban.com/subject/2258023/ "Masterminds of Programming"


