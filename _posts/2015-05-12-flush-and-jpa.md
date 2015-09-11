---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150512-flush-and-jpa # DO NOT CHANGE THE VALUE ONCE SET
title: flush() in JPA
# MUST HAVE END

is_short: true
subtitle:
tags: 
- JPA
- java
date: 2015-05-12 22:15:00
image:
image_desc:
---

部分内容搬运自[SO上的一个回答][1]。

如果managed entity有改动，那么在transaction提交时，JPA会*自动地*<del>（待确定）</del>帮你向数据库提交改动（不用显式地调用`em.flush()`）。
一般来说，调用`em.persist()`时，entity的改动不会立即写到数据库中，JPA会暂缓执行这些改动对应的SQL语句，
等到transaction提交时再去执行这些SQL语句。这样有利于提高性能，比如JPA可以把不同改动对应的SQL语句放在一次请求里发给数据库。

有时候，用户可能希望立即执行SQL（通常是想得到SQL执行的“副作用”）。比如，用户想立即向数据库里插入一条记录，
以得到一个数据库自动产生的键值（也就是自动生成主键）。`em.flush()`会立即执行之前缓存的SQL，然后清空缓存。因为`em.flush()`会涉及到数据库的操作，所以会对
性能产生一点影响。如果transaction提交失败了，`flush()`时写到数据库的操作也会回滚。        

##### 关于上面提到的“自动生成主键”
JPA可以指定entity主键的生成方式。比如，下面的代码指定了entity的主键通过数据库的某个sequence来生成，

    @Id
    @GeneratedValue(generator = "XYZSeq")
    @SequenceGenerator(name = "XYZSeq", sequenceName = "XYZ_SEQ", allocationSize = 1)
    private Long id;

如果去google `“jpa persist auto generated id”`，会发现很多sources都讲`id`只会在`em.flush()`调用后才会有值。
但是，上面的代码在EclipseLink + HANA的环境下，调用`em.persist()`后（调用`em.flush()`前）就会给`id`赋值。
调用`em.persist()`后，在EclipseLink的log里会有如下一条记录，

    ...--Connection(1849633626)--Thread(Thread[http-bio-8091-exec-8,5,main])--SELECT XYZ_SEQ.NEXTVAL FROM DUMMY
    
这意味着，EclipseLink在执行`persist()`时会调用数据库的sequence去生成主键。
JPA的API文档里并没有讲`persist()`对entity主键的影响。所以，不同的JPA provider对`persist()`可能会有不同的实现。
当然，生成主键的行为也可能受到`GenerationType`的影响；比如`GenerationType`设成`GenerationType.IDENTITY`时，JPA provider
可能在`persist()`时就生成主键了。
    
<del>还有一个使用`flush()`的场景是，用JPQL查询时只会把数据库里的内容查询出来，所以如果想把内存里的entity的改
动也一起query出来要先`flush()`一下，把entity的改动刷到数据库里后再查询。（待确定）</del>

在我的环境下，新建一个entity的对象，然后调用`persist()`，这时是可以在JPQL中query出这个新建的entity对象的（不需要调用一次`flush()`）。

    "select e from SomeEntity e where e.someField = :val"
    
不知道，对于其它（复杂的）JPQL是不是也是如此（待确定）。

还有个`clear()`函数，它可以把entity从persistence context里脱离出来；entity的改动不会被写到数据库里。


[1]: http://stackoverflow.com/questions/4275111/correct-use-of-flush-in-jpa-hibernate "Correct use of flush() in JPA/Hibernate"
[2]: http://www.developerfusion.com/article/84945/flush-and-clear-or-mapping-antipatterns/ "Flush and Clear: O/R Mapping Anti-Patterns"
