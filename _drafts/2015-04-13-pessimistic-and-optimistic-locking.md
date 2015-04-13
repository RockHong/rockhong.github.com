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










--------------------

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

Shared Locks

Shared (S) locks allow concurrent transactions to read (SELECT) a resource under pessimistic concurrency control. For more information, see Types of Concurrency Control. No other transactions can modify the data while shared (S) locks exist on the resource. Shared (S) locks on a resource are released as soon as the read operation completes, unless the transaction isolation level is set to repeatable read or higher, or a locking hint is used to retain the shared (S) locks for the duration of the transaction.
Update Locks

Update (U) locks prevent a common form of deadlock. In a repeatable read or serializable transaction, the transaction reads data, acquiring a shared (S) lock on the resource (page or row), and then modifies the data, which requires lock conversion to an exclusive (X) lock. If two transactions acquire shared-mode locks on a resource and then attempt to update data concurrently, one transaction attempts the lock conversion to an exclusive (X) lock. The shared-mode-to-exclusive lock conversion must wait because the exclusive lock for one transaction is not compatible with the shared-mode lock of the other transaction; a lock wait occurs. The second transaction attempts to acquire an exclusive (X) lock for its update. Because both transactions are converting to exclusive (X) locks, and they are each waiting for the other transaction to release its shared-mode lock, a deadlock occurs.
To avoid this potential deadlock problem, update (U) locks are used. Only one transaction can obtain an update (U) lock to a resource at a time. If a transaction modifies a resource, the update (U) lock is converted to an exclusive (X) lock.
Exclusive Locks

Exclusive (X) locks prevent access to a resource by concurrent transactions. With an exclusive (X) lock, no other transactions can modify data; read operations can take place only with the use of the NOLOCK hint or read uncommitted isolation level.
Data modification statements, such as INSERT, UPDATE, and DELETE combine both modification and read operations. The statement first performs read operations to acquire data before performing the required modification operations. Data modification statements, therefore, typically request both shared locks and exclusive locks. For example, an UPDATE statement might modify rows in one table based on a join with another table. In this case, the UPDATE statement requests shared locks on the rows read in the join table in addition to requesting exclusive locks on the updated rows.

还讲了其他的锁

http://www.objectdb.com/java/jpa/persistence/lock
乐观锁和悲观锁是应用在database object level上的；
time out

JPA 2 supports both optimistic locking and pessimistic locking. Locking is essential to avoid update collisions resulting from simultaneous updates to the same data by two concurrent users. 

Locking in ObjectDB (and in JPA) is always at the database object level, i.e. each database object is locked separately.

Optimistic locking is applied on transaction commit.
Any database object that has to be updated or deleted is checked. An exception is thrown if it is found out that an update is being performed on an old version of a database object, for which another update has already been committed by another transaction.

optimistic locking is enabled by default and fully automatic. Optimistic locking should be the first choice for most applications, since compared to pessimistic locking it is easier to use and more efficient.

In the rare cases in which update collision must be revealed earlier (before transaction commit) pessimistic locking can be used. When using pessimistic locking, database objects are locked during the transaction and lock conflicts, if they happen, are detected earlier.


This page covers the following topics:
Optimistic Locking
Pessimistic Locking
Other Explicit Lock Modes
Locking during Retrieval
Optimistic Locking
ObjectDB maintains a version number for every entity object. The initial version of a new entity object (when it is stored in the database for the first time) is 1. In every transaction in which an entity object is modified its version number is automatically increased by one. Version numbers are managed internally but can be exposed by defining a version field.

During commit (and flush), ObjectDB checks every database object that has to be updated or deleted, and compares the version number of that object in the database to the version number of the in-memory object being updated. The transaction fails and an OptimisticLockException is thrown if the version numbers do not match, indicating that the object has been modified by another user (using another EntityManager) since it was retrieved by the current updater.

Optimistic locking is completely automatic and enabled by default in ObjectDB, regardless if a version field (which is required by some ORM JPA providers) is defined in the entity class or not.

Pessimistic Locking
The main supported pessimistic lock modes are:

PESSIMISTIC_READ - which represents a shared lock.
PESSIMISTIC_WRITE - which represents an exclusive lock.
Setting a Pessimistic Lock
An entity object can be locked explicitly by the lock method:

  em.lock(employee, LockModeType.PESSIMISTIC_WRITE);
The first argument is an entity object. The second argument is the requested lock mode.

A TransactionRequiredException is thrown if there is no active transaction when lock is called because explicit locking requires an active transaction.

A LockTimeoutException is thrown if the requested pessimistic lock cannot be granted:

A PESSIMISTIC_READ lock request fails if another user (which is represented by another EntityManager instance) currently holds a PESSIMISTIC_WRITE lock on that database object.
A PESSIMISTIC_WRITE lock request fails if another user currently holds either a PESSIMISTIC_WRITE lock or a PESSIMISTIC_READ lock on that database object.
For example, consider the following code fragment:

  em1.lock(e1, lockMode1);
  em2.lock(e2, lockMode2);
em1 and em2 are two EntityManager instances that manage the same Employee database object, which is referenced as e1 by em1 and as e2 by em2 (notice that e1 and e2 are two in-memory entity objects that represent one database object).

If both lockMode1 and lockMode2 are PESSIMISTIC_READ - these lock requests should succeed. Any other combination of pessimistic lock modes, which also includes PESSIMISTIC_WRITE, will cause a LockTimeoutException (on the second lock request).

Pessimistic Lock Timeout
By default, when a pessimistic lock conflict occurs a LockTimeoutException is thrown immediately. The "javax.persistence.lock.timeout" hint can be set to allow waiting for a pessimistic lock for a specified number of milliseconds. The hint can be set in several scopes:

For the entire persistence unit - using a persistence.xml property:

    <properties>
       <property name="javax.persistence.lock.timeout" value="1000"/>
    </properties>
For an EntityManagerFactory - using the createEntityManagerFacotory method:

  Map<String,Object> properties = new HashMap();
  properties.put("javax.persistence.lock.timeout", 2000);
  EntityManagerFactory emf =
      Persistence.createEntityManagerFactory("pu", properties);
For an EntityManager - using the createEntityManager method:

  Map<String,Object> properties = new HashMap();
  properties.put("javax.persistence.lock.timeout", 3000);
  EntityManager em = emf.createEntityManager(properties);
or using the setProperty method:

  em.setProperty("javax.persistence.lock.timeout", 4000);
In addition, the hint can be set for a specific retrieval operation or query.

Releasing a Pessimistic Lock
Pessimistic locks are automatically released at transaction end (using either commit or rollback).

ObjectDB supports also releasing a lock explicitly while the transaction is active, as so:

  em.lock(employee, LockModeType.NONE);
Other Explicit Lock Modes
In addition to the two main pessimistic modes (PESSIMISTIC_WRITE and PESSIMISTIC_READ, which are discussed above), JPA defines additional lock modes that can also be specified as arguments for the lock method to obtain special effects:

OPTIMISTIC (formerly READ)
OPTIMISTIC_FORCE_INCREMENT (formerly WRITE)
PESSIMISTIC_FORCE_INCREMENT
Since optimistic locking is applied automatically by ObjectDB to every entity object, the OPTIMISTIC lock mode has no effect and, if specified, is silently ignored by ObjectDB.

The OPTIMISTIC_FORCE_INCREMENT mode affects only clean (non dirty) entity objects. Explicit lock at that mode marks the clean entity object as modified (dirty) and increases its version number by 1.

The PESSIMISTIC_FORCE_INCREMENT mode is equivalent to the PESSIMISTIC_WRITE mode with the addition that it marks a clean entity object as dirty and increases its version number by one (i.e. it combines PESSIMISTIC_WRITE with OPTIMISTIC_FORCE_INCREMENT).

Locking during Retrieval
JPA 2 provides various methods for locking entity objects when they are retrieved from the database. In addition to improving efficiency (relative to a retrieval followed by a separate lock), these methods perform retrieval and locking as one atomic operation.

For example, the find method has a form that accepts a lock mode:

  Employee employee = em.find(
      Employee.class, 1, LockModeType.PESSIMISTIC_WRITE);
Similarly, the refresh method can also receive a lock mode:

  em.refresh(employee, LockModeType.PESSIMISTIC_WRITE);
A lock mode can also be set for a query in order to lock all the query result objects.

When a retrieval operation includes pessimistic locking, timeout can be specified as a property. For example:

  Map<String,Object> properties = new HashMap();
  properties.put("javax.persistence.lock.timeout", 2000);
 
  Employee employee = em.find(
      Employee.class, 1, LockModeType.PESSIMISTIC_WRITE, properties);
 
  ...
 
  em.refresh(employee, LockModeType.PESSIMISTIC_WRITE, properties);
Setting timeout at the operation level overrides setting in higher scopes.