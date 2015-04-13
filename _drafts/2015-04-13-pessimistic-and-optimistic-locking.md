---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150413-pessimistic-and-optimistic-locking # DO NOT CHANGE THE VALUE ONCE SET
title: 数据库中的乐观锁和悲观锁
# MUST HAVE END

is_short: true
subtitle:
tags: 
- database
- JPA
date: 2015-04-13 19:13:00
image:
image_desc:
---

😊😄❤️👪💯

Emoji是unicode的一部分，UTF-8编码也是可以表示Emoji的。
比如😁对应的unicode是`U+1F601`，对应的UTF-8编码是`\xF0\x9F\x98\x81`。所以我们可以在UTF-8编码存储的
文本中（比如HTML文件）保存Emoji表情。

###显示文本中的Emoji
我们需要一种字体来显示以UTF-8编码的Emoji表情。通常，一种字体不能显示所有的UTF-8编码。不能显示时，通常
会显示成一个“小方块”。在较新的OS X系统上，`Apple Color Emoji`字体可以显示Emoji表情。在较新的Windows上
（比如Windows 7/8），`Segoe UI Symbol`字体可以显示黑白的Emoji表情。Windows 8上可以用
`Segoe UI Emoji`字体来显示彩色的表情。

###显示网页上的Emoji
对于网页元素，我们可以通过CSS属性`font-family`来指定（一系列）字体。比如，

    font-family: Gill Sans Extrabold, sans-serif;

排在前面的字体优先级较后面的高。如果用户电脑上没有安装优先级高的字体，那么根据优先级依次尝试后续的
字体。如果所有的字体都没有找到，那么使用浏览器提供的字体（Initial value depends on user agent）。
在OS X上，如果font-family中没有指定可以显示Emoji的字体，Safari是可以正常显示Emoji的，而Chrome则不能。
这是因为这两个浏览器提供的默认字体有区别。

为了在Windows和OS X上都能显示Emoji表情，可以向font-family里加入`Apple Color Emoji`，`Segoe UI Emoji`，
和`Segoe UI Symbol`字体。比如，

    font-family: Helvetica, arial, freesans, clean, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol';

最后效果如下，       
Chrome on Windows 7       
<img src="../images/blog/chrome-win7-emoji.png" alt="chrome win7 emoji" title="chrome win7 emoji" style="display: block; width: 90px; margin-left: 0px; margin-right: 0px;">
IE 11 on Windows 7      
<img src="../images/blog/ie-win7-emoji.png" alt="ie win7 emoji" title="ie win7 emoji" style="display: block; width: 90px; margin-left: 0px; margin-right: 0px;">
Safari on OS X     
<img src="../images/blog/safari-osx-emoji-png.png" alt="safari osx emoji" title="safari osx emoji" style="display: block; width: 90px; margin-left: 0px; margin-right: 0px;">
Chrome on OS X      
<img src="../images/blog/chrome-osx-emoji-png.png" alt="chrome osx emoji" title="chrome osx emoji" style="display: block; width: 90px; margin-left: 0px; margin-right: 0px;">


###参考连接
[Emoji Unicode Tables](http://apps.timwhitlock.info/emoji/tables/unicode)     
[Segoe UI Symbol](https://msdn.microsoft.com/en-us/library/windows/apps/jj841126.aspx)     
[font-family MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/font-family)      
[font-family](http://www.w3schools.com/cssref/pr_font_font-family.asp)    








数据库的锁/加锁策略（lock/locking)和数据库的隔离级别（isolation level）不是同一个
概念（虽然有关联）。隔离级别主要关心的是一个transaction对其它transaction修改的可见性。
锁/加锁策略主要关心如何控制多个transaction对表上某一行（row）的并发访问。

### 加锁策略 Locking
数据库有两种加锁的策略，optimistic locking以及pessimistic locking。它们也经常被
翻译成或者叫成“乐观锁”和“悲观锁”。实际上，不是说一个锁有”乐观“和”悲观“之分；而是说在使用
锁的”态度“上有”乐观“和”悲观“之分。下面可以看到optimistic locking根本不会使用锁。

#### 悲观的加锁策略 Pessimistic Locking
通过使用锁（不同类型的锁）来防止数据（row）被其它的用户修改。用户A在执行操作（比如读或者
更新操作）前加上锁，如果其它用户对数据的操作和锁有冲突，那么在用户A释放锁之前，其它用户的这些
操作将不能执行。

因为用户在执行操作前不管未来是否会有冲突总是加锁，所以叫pessimistic locking。这种加锁
策略适用于数据竞争（data contention）发生的概率很高的情景。因为在这种情景下，如果采用
乐观的加锁策略，transaction的回滚概率高，使得回滚的总开销比加锁带来的开销还大。

#### 乐观的加锁策略 Optimistic Locking
采用optimistic locking时，用户在读数据时不会使用锁。当用户A更新数据时，数据库会检查其它
用户有没有修改过这份数据（比如通过对比内存中用户A的数据的版本信息和更新时数据库中的版本
信息）。如果用户A要更新的数据已经被其它用户更新过，数据库会报错。通常用户收到错误消息后会
回滚并重试。

为什么是乐观的？因为采用这种策略时，用户倾向于认为数据之间是没有竞争的。这种策略适用于数据
竞争很少的场景。这种场景下，偶尔的回滚带来的开销要低于加锁防止冲突的开销。

### 不同的锁


--------------------

具体锁的应用要参考具体的db
不是“乐观”乐观的锁，而是乐观的加锁策略；

https://technet.microsoft.com/en-us/library/ms189132(v=sql.105).aspx

db有两种并发控制（concurrency control）策略。控制对同一个database object的修改。
悲观的加锁（pessimistic locking）
一个用户A在一个对象上执行某些动作时（比如更新，读）会被加上锁，其它用户也对这个对象执行动作，如果
这些动作和用户A的锁发生冲突，那么就不能执行这些动作；
为什么叫悲观；
因为总是想着先加锁；
适用场景，高并发，发生“数据竞争”的可能性高；如果用乐观锁（不加锁）回滚概率高，回滚太多还不如事先先加锁，
是的操作串行化
A system of locks prevents users from modifying data in a way that affects other users. After a user performs an action that causes a lock to be applied, other users cannot perform actions that would conflict with the lock until the owner releases it. This is called pessimistic control because it is mainly used in environments where there is high contention for data, where the cost of protecting data with locks is less than the cost of rolling back transactions if concurrency conflicts occur.



乐观的加锁（optimistic locking）
In optimistic concurrency control, users do not lock data when they read it. When a user updates data, the system checks to see if another user changed the data after it was read. If another user updated the data, an error is raised. Typically, the user receiving the error rolls back the transaction and starts over. This is called optimistic because it is mainly used in environments where there is low contention for data, and where the cost of occasionally rolling back a transaction is lower than the cost of locking data when read.
读数据，时间点tA，的时候不加锁；更新的时候，如果发现其他用户已经在时间点tA之后已经修改了数据，那么更新失败；
一般来说，回滚后会重试；
为什么乐观
因为认为没什么竞争，不需要加锁，成功的可能性大
适用场景，低竞争，rollback（并重试）的代价比每个都加锁要小；


https://technet.microsoft.com/en-us/library/ms175519(v=sql.105).aspx
Applies to: SQL Server 2008 R2 and higher versions.

Shared (S) locks
Used for read operations that do not change or update data, such as a SELECT statement.
允许多个transaction同时读SELECT；是悲观加锁策略下的一种锁；
当resource上存在这种锁时，不允许其它transaction修改这个对象、资源；
读操作完成后这个锁马上就释放了；除非隔离级别是repeatable read or higher或者a locking hint is used to retain the shared (S) locks for the duration of the transaction.

Update (U) locks
Used on resources that can be updated. Prevents a common form of deadlock that occurs when multiple sessions are reading, locking, and potentially updating resources later.
prevent a common form of deadlock
怎么形成死锁
Only one transaction can obtain an update (U) lock to a resource at a time.
If a transaction modifies a resource, the update (U) lock is converted to an exclusive (X) lock.

Exclusive (X) locks
Used for data-modification operations, such as INSERT, UPDATE, or DELETE. Ensures that multiple updates cannot be made to the same resource at the same time.
prevent access to a resource by concurrent transactions； 防止并发访问
With an exclusive (X) lock, no other transactions can modify data; read operations can take place only with the use of the NOLOCK hint or read uncommitted isolation level.没有其它人可以修改数据；读操作一般也不运行；出发有NOLOCK hint和read uncommitted隔离级别


还讲了其他的锁
schema lock，
key range lock，Key-range locking prevents phantom reads
By protecting the ranges of keys between rows, it also prevents phantom insertions or deletions into a record set accessed by a transaction.


http://www.objectdb.com/java/jpa/persistence/lock
乐观锁和悲观锁是应用在database object level上的；
time out

JPA 2 supports both optimistic locking and pessimistic locking

Locking is essential to avoid update collisions resulting from simultaneous updates to the same data by two concurrent users. 

Locking in ObjectDB (and in JPA) is always at the database object level, i.e. each database object is locked separately.

Optimistic locking is applied on transaction commit.
An exception is thrown if it is found out that an update is being performed on an old version of a database object, for which another update has already been committed by another transaction.

When using ObjectDB, optimistic locking is enabled by default and fully automatic.

Optimistic locking should be the first choice for most applications, since compared to pessimistic locking it is easier to use and more efficient.

In the rare cases in which update collision must be revealed earlier (before transaction commit) pessimistic locking can be used. 
When using pessimistic locking, database objects are locked during the transaction and lock conflicts, if they happen, are detected earlier.


maintains a version number for every entity object.
In every transaction in which an entity object is modified its version number is automatically increased by one. 
Version numbers are managed internally but can be exposed by defining a version field.
@Entity public class EntityWithVersionField {
     @Version long version;
}

compares the version number of that object in the database to the version number of the in-memory object being updated.

 OptimisticLockException
 
  indicating that the object has been modified by another user (using another EntityManager) since it was retrieved by the current updater.
每个线程起一个EM？


PESSIMISTIC_READ - which represents a shared lock.
PESSIMISTIC_WRITE - which represents an exclusive lock.

An entity object can be locked explicitly by the lock method:
em.lock(employee, LockModeType.PESSIMISTIC_WRITE);

A TransactionRequiredException is thrown if there is no active transaction

A LockTimeoutException is thrown if the requested pessimistic lock cannot be granted:
A PESSIMISTIC_READ lock request fails if another user (which is represented by another EntityManager instance) currently holds a PESSIMISTIC_WRITE lock on that database object.
A PESSIMISTIC_WRITE lock request fails if another user currently holds either a PESSIMISTIC_WRITE lock or a PESSIMISTIC_READ lock on that database object.
  

By default, when a pessimistic lock conflict occurs a LockTimeoutException is thrown immediately.

The "javax.persistence.lock.timeout" hint can be set to allow waiting for a pessimistic lock for a specified number of milliseconds.

Pessimistic locks are automatically released at transaction end (using either commit or rollback).

supports also releasing a lock explicitly
em.lock(employee, LockModeType.NONE);

Other Explicit Lock Modes
OPTIMISTIC (formerly READ)
OPTIMISTIC_FORCE_INCREMENT (formerly WRITE)
PESSIMISTIC_FORCE_INCREMENT

Locking during Retrieval

