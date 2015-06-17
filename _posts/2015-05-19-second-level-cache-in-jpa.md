---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150519-second-level-cache-in-jpa # DO NOT CHANGE THE VALUE ONCE SET
title: JPA里的Second Level Cache
# MUST HAVE END

is_short: false
subtitle:
tags: 
- JPA
- java
date: 2015-05-19 22:15:00
image:
image_desc:
---

### 基本概念
`Persistence context`和`EntityManager`实际上是同一个东西。`Persistence context`更多地
是表示一种概念（concept）或者一个名词（term）；`EntityManager`就是`Persistence context`
在java代码里相应的类。

`Persistence context/EntityManager`管理着一个entity的集合。`EntityManager`提供了管理
entity的接口：

	persist()   //把entity放到pc里管理
	merge()     //把传进来的entity拷贝一份，把拷贝放到pc里管理
	detach()    //把entity从pc中移出来，pc不再管理这个entity
	remove()    //删除entity，交易提交时，数据库相应的列也会删除
	flush()     //把pc里的entity同步到数据库里
	find()
	createQuery()
	...
	
new出来的entity不会直接放到EntityManager里，需要调一下`persist()`或者`merge()`。     
只有被EntityManager管理的entity在transaction提交时才会写到数据库里。

一般一个transaction有一个persistence context；但是，persistence context也可以配置成
跨多个transaction的。

### 不同的缓存

#### First Level Cache
Persistence context就是一个缓存，叫first level cache（L1 cache）。数据库的一行（row）在一个
persistence context只有一个对应的entity。对一个entity的CRUD都是先作用在first level cache
上，等transaction提交时再写到数据库里。First level cache可以减少对数据库的操作。比如查找某
个行时，先看first level cache里是不是已经有对应的entity存在了；如果存在就不用再查询数据库了。
同样，对entity的（多次）更新等操作也是先写到这个缓存里，最后再（一次）提交到数据库里。

因为可能有多个persistence context（比如一个transaction有一个persistence context），数据
库的同一行可能在多个persistence context里都有对应的entity。这时候，就要通过加锁策略（locking）
来保证数据的一致性（乐观锁/悲观锁）。

#### Second Level Cache
可以看到first level cache的生命周期是和一个persistence context/transaction绑定的；而且
不同的first level cache之间是互相隔离的。Second level cache（L2 cache）则是一个application
级别的缓存；不同的persistence context共享同一个second level cache。查找一个entity时，
会先看L1 cache；找不到再看L2 cache；最后才真正去数据库里找。

不同的JPA实现有不同的L2 cache实现。有些JPA实现（比如EclipseLink）会默认打开L2 cache，另外一些
可能默认是关闭的。

L2 cache的好处是减少数据库操作，可以读得更快。

L2 cache的缺点是：
<!--more-->

- 对象多了占内存；
- 并发写需要加锁（悲观锁排队，乐观锁需要重试）；
- 缓存中数据stale的问题；（TODO：如何produce）
- 等等

#### Query Cache
对于那些经常运行的，且参数和涉及到的表都没有变化的query，query cache会有助提高性能。

### L2 Cache的配置

JPA 2.0提供了一些L2 cache相关的API。比如，`javax.persistence.Cache`接口，包含了`contains()`，
`evict()`等方法；`@Cacheable`可以标注一个entity是不是要被缓存。另外，persistence.xml提供了
`<shared-cache-mode>`标签，可以指定缓存的策略；它可以是下列值：

- ALL，所以entity都缓存
- NONE，关闭L2缓存
- ENABLE_SELECTIVE，把@Cacheable(true)的entity放到L2缓存里
- DISABLE_SELECTIVE，把没有标记@Cacheable(false)的放到L2缓存里
- UNSPECIFIED，采用JPA实现的默认行为

除了在persistence.xml静态地配置，也可以通过设置entity manager factory来动态地配置。

另外，一些JPA实现还提供了自己的（更丰富的）API来配置L2 cache。比如EclipseLink和Hibernate都提供
了@Cache（EclipseLink的文档还推荐使用[@Cache][5]来替代标准的@Cacheable）。

[这篇文章][6]推荐为以读为主、不常修改、不关心是否stale的entity打开L2 cache。（对于那些经常
写的entity，即使你没打开L2 cache，它还是会发生并发冲突的问题，只是冲突发生在数据库级别而已；
所以前一句的话真正论据是什么？）      
对于并发写冲突问题，文章还提到了

>“configure expiration, refresh policy to minimize lock failures”
（why & how?）


[1]: http://www.developer.com/java/using-second-level-caching-in-a-jpa-application.html "Using Second Level Caching in a JPA Application"
[2]: http://stackoverflow.com/questions/1069992/jpa-entitymanager-why-use-persist-over-merge "persist vs merge"
[3]: http://www.objectdb.com/java/jpa/persistence/delete "remove()"
[5]: http://eclipse.org/eclipselink/documentation/2.4/jpa/extensions/a_cache.htm "@Cache"
[6]: https://blogs.oracle.com/carolmcdonald/entry/jpa_caching "JPA Caching"
