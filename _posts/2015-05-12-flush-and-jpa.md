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

搬运自[SO上的一个回答][1]。（还没有仔细地看JPA的文档来验证。）

Transaction提交时，JPA会*自动地*（待确定）帮你向数据库提交所有的entity改动。     
一般来说，调用`em.persist()`后，entity的改动不会立即写到数据库中，JPA会把这些改动对应的SQL语句cache起
来，等到transaction提交时再向数据库提交这些SQL语句。这样有利于提高性能。比如JPA可以把多个SQL合并成单个
SQL来执行。

有时候，用户可能希望立即执行SQL（通常是想得到SQL执行的“副作用”）。比如，用户想立即向数据库里插入一条记录，
以得到一个数据库自动产生的键值。`em.flush()`会立即执行之前缓存的SQL，然后清空缓存。`em.flush()`可能会稍微
影响一点性能，因为影响了JPA对SQL执行做的优化。如果transaction提交失败了，flush()时写到数据库的操作也会回滚。

还有一个使用`flush()`的场景是，用JPQL查询时只会把数据库里的内容查询出来，所以如果想把内存里的entity的改
动也一起query出来要先`flush()`一下，把entity的改动刷到数据库里后再查询。（待确定）

还有个`clear()`函数，它可以把entity从persistence context里脱离出来；entity的改动不会被写到数据库里。


[1]: http://stackoverflow.com/questions/4275111/correct-use-of-flush-in-jpa-hibernate "Correct use of flush() in JPA/Hibernate"
[2]: http://www.developerfusion.com/article/84945/flush-and-clear-or-mapping-antipatterns/ "Flush and Clear: O/R Mapping Anti-Patterns"
