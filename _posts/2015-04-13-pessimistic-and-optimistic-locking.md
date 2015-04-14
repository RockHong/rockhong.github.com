---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150413-pessimistic-and-optimistic-locking # DO NOT CHANGE THE VALUE ONCE SET
title: 数据库中的乐观锁和悲观锁
# MUST HAVE END

subtitle:
tags: 
- database
- JPA
date: 2015-04-13 19:13:00
image:
image_desc:
---

数据库的锁/加锁策略（lock/locking)和数据库的隔离级别（isolation level）不是同一个
概念（虽然有关联）。隔离级别主要关心的是一个transaction对其它transaction修改的可见性。
锁/加锁策略主要关心如何控制多个transaction对某个资源（row or page）的并发访问。

### 加锁策略 Locking
数据库有两种加锁的策略，optimistic locking以及pessimistic locking。它们也经常被
翻译成或者叫成“乐观锁”和“悲观锁”。实际上，不是说一个锁有”乐观“和”悲观“之分；而是说在使用
锁的”态度“上有”乐观“和”悲观“之分。下面可以看到optimistic locking根本不会使用锁。

#### 悲观的加锁策略 Pessimistic Locking
通过使用锁（不同类型的锁）来防止数据（row or page）被其它的用户修改。用户A在执行操作（比如读或者
更新操作）前加上锁，如果其它用户对数据的操作和锁有冲突，那么在用户A释放锁之前，其它用户的这些
操作将不能执行。

因为用户在执行操作前不管未来是否会有冲突发生总是加锁，所以叫pessimistic locking。这种加锁
策略适用于数据竞争（data contention）发生的概率很高的情景。因为在这种情景下，如果采用
乐观的加锁策略，transaction的回滚概率高，使得回滚的总开销比加锁带来的开销还大。

#### 乐观的加锁策略 Optimistic Locking
采用optimistic locking时，用户在读数据时不会使用锁。当用户A更新数据时，数据库会检查其它
用户有没有修改过这份数据（比如通过对比内存中用户A的数据的版本信息和更新时数据库中的版本
信息）。如果用户A要更新的数据已经被其它用户更新过，数据库会报错。通常用户收到错误消息后会
回滚并重试。

为什么是乐观的？因为采用这种策略时，用户倾向于认为数据之间是没有竞争的。这种策略适用于数据
竞争很少的场景。这种场景下，偶尔的回滚（并重试）带来的开销要低于加锁防止冲突的开销。

### 不同的锁
如果决定了使用pessimistic locking，那么有不同类型的锁可供使用。这篇[微软的文档][1]讲了
SQL Server提供的不同类型的锁。其它的数据库应该也会提供类似的锁。
<!--more-->

#### 共享锁 Shared (S) Locks
共享锁允许多个transaction同时对一个资源进行读（SELECT）操作，但是不允许其它transaction对
加锁的资源进行修改。读操作完成后，共享锁会被立即释放（除非隔离级别是Read Repeatable或者更高，
或者显式地通过locking hint要求在transaction期间保持这个共享锁）。

#### 排它锁 Exclusive (X) Locks
当一个transaction在一个资源上加上排它锁之后，其它的transaction不能对这个资源进行修改操作以及
读操作（除非隔离级别是Read Uncommitted或者使用了NOLOCK hint，才允许读操作）。
修改数据的语句常常同时包括修改操作和读操作。比如一个UPDATE语句可能要基于另一个join table的内容
来修改数据。这时，UPDATE语句除了请求一个排它锁加在要更新的行上之外，还要请求一个共享锁加在要读取
的join table的行上。

#### 更新锁 Update (U) Locks
更新锁主要是为了避免一种常见的死锁。
在隔离级别为Read Repeatable或者Serializable时，假设有两个transaction在一个资源上都持有共享锁，
然后它们同时尝试去更新这个资源。更新时，需要把共享锁转换成排他锁。当一个transaction在做这种转换时，
因为另一个transaction正在这个资源上持有共享锁，所以它只好先处于等待状态。当两个transaction同时
尝试进行转换，只能互相等待，形成死锁。
使用更新锁来避免这种类型的死锁。一个时刻只允许一个transaction在一个资源上持有更新锁。当需要修改
资源时，更新锁就会被转换成排它锁。

#### 其它类型的锁
SQL Server还提供了其它类型的锁。比如，schema lock用于对表定义的并发修改，key-range lock用于
防止幻读（phantom read）。

### JPA中的加锁策略 Locking in JPA
JPA 2支持optimistic locking和pessimistic locking ，用于避免多个用户同时修改同一份数据时产生的
冲突。

#### Optimistic Locking
在某些JPA实现中（不确定是不是所有JPA实现），默认是开启optimistic locking的，而且是自动支持（通过自带
的versioning）不需要额外的代码。

某些JPA实现内部会默认地为每个实体（entity）对象维护一个版本号（version number）。也可以显式地在
实体里定义一个version字段，比如

    @Entity public class EntityWithVersionField {
        @Version long version;
    }

如果当前transaction执行更新操作时，发现内存中的entity的版本号比数据库里对应的数据的版本号要低，这意味着其它的
transaction已经修改了这份数据，所以当前的transaction所做的修改是基于过时数据的，这时系统就会抛一个
异常（`OptimisticLockException`）。

JPA会在transaction提交时应用optimistic locking。对于大多数应用，optimistic locking应该作为第一选择，因为
相比于pessimistic locking，它更易用、更高效。

#### Pessimistic Locking
Pessimistic locking是在transaction提交时应用，相比而言pessimistic locking可以更早地发现冲突。

应用pessimistic locking时，JPA支持不同种类的锁，主要是下面两种：

- `PESSIMISTIC_READ` 共享锁
- `PESSIMISTIC_WRITE` 排它锁

一个entity可以这么加锁：

	//em是一个EntityManager对象
	em.lock(employee, LockModeType.PESSIMISTIC_WRITE);

如果`lock()`操作没有在transaction里执行，会抛一个`TransactionRequiredException`异常。     
如果不能得到请求的锁，会抛一个`LockTimeoutException`异常。比如，请求`PESSIMISTIC_READ`锁时，如果其它用户在同一个
数据库对象上持有`PESSIMISTIC_WRITE`锁，那么就会请求失败；同样，请求`PESSIMISTIC_WRITE`锁时，如果其它用户持有
`PESSIMISTIC_WRITE`锁或者`PESSIMISTIC_READ`锁，请求也会失败。    
一般而言，`LockTimeoutException`异常会在加锁失败后立即抛出。但是也可以指定请求锁的等待时间，如果等待超时
在抛异常。

锁会在transaction结束时（比如提交或者回滚）被释放，也可以显式地释放锁：

	em.lock(employee, LockModeType.NONE);

除了上面两种锁，JPA也支持其它的锁，比如`OPTIMISTIC_FORCE_INCREMENT`，`PESSIMISTIC_FORCE_INCREMENT`等。

JPA也提供了一些便利函数，可以使得retrieval操作和locking操作被包在一个“原子操作”里。
 
    Employee employee = em.find(
      Employee.class, 1, LockModeType.PESSIMISTIC_WRITE, properties);
 
    ...
 
    em.refresh(employee, LockModeType.PESSIMISTIC_WRITE, properties);


### 参考
[Lock Modes][1]      
[Locking in JPA][2]      
[Types of Concurrency Control][3]         

[1]: https://technet.microsoft.com/en-us/library/ms175519(v=sql.105).aspx "Lock Modes"
[2]: http://www.objectdb.com/java/jpa/persistence/lock "Locking in JPA"
[3]: https://technet.microsoft.com/en-us/library/ms189132(v=sql.105).aspx "Types of Concurrency Control"
[5]: https://technet.microsoft.com/en-us/library/ms189122(v=sql.105).aspx "Isolation Levels in the Database Engine"