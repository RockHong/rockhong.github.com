---
# MUST HAVE BEG
layout: post
disqus_identifier: 2015-05-16-java-concurrency-in-practice-notes-1 # DO NOT CHANGE THE VALUE ONCE SET
title: Java Concurrency in Practice 读书笔记1
# MUST HAVE END

is_short: false
subtitle:
tags: 
- java
date: 2015-05-16 15:15:00
image:
image_desc:
---



### 第4章 Composing Objects

####4.1 Designing a thread-safe class

The design process for a thread-safe class should include these three basic elements:
• Identify the variables that form the object’s state;
• Identify the invariants that constrain the state variables;
• Establish a policy for managing concurrent access to the object’s state.

4.1.1 Gathering synchronization requirements

The smaller this state space, the easier it is to reason about. By using final fields wherever practical, you make it simpler to analyze the possible states an object can be in.

You cannot ensure thread safety without understanding an object’s invariants and postconditions. Constraints on the valid values or state transitions for state variables can create atomicity and encapsulation requirements.

4.1.2 State-dependent operations

Operations with state-based preconditions are called state-dependent

Concurrent programs add the possibility of waiting until the precondition becomes true, and then proceeding with the operation

The built-in mechanisms for efficiently waiting for a condition to become true—wait and notify—are tightly bound to intrinsic locking, and can be difficult to use correctly

it is often easier to use existing library classes, such as blocking queues or semaphores, to provide the desired state-dependent behavior.

Blocking library classes such as BlockingQueue, Semaphore, and other synchronizers are covered in Chapter 5; creating state-dependent classes using the low-level mechanisms provided by the platform and class library is covered in Chapter 14.

4.1.3 State ownership

涉及到share

4.2 Instance confinement

Encapsulating data within an object confines access to the data to the object’s methods, making it easier to ensure that the data is always accessed with the appropriate lock held.
把不安全的对象限制起来；提供可控的访问接口；然后在这个接口上加个锁，可以让它变得安全

例子
@ThreadSafe
public class PersonSet {
     @GuardedBy("this")
     private final Set<Person> mySet = new HashSet<Person>();
     public synchronized void addPerson(Person p) {
          mySet.add(p);
     }
     public synchronized boolean containsPerson(Person p) {
          return mySet.contains(p);
     }
}

The basic collection classes such as ArrayList and HashMap are not thread-safe, but the class library provides wrapper factory methods (Collections. synchronizedList and friends) so they can be used safely in multithreaded environments. These factories use the Decorator pattern (Gamma et al., 1995) to wrap the collection with a synchronized wrapper object;
库里的例子

4.2.1 The Java monitor pattern
An object following the Java monitor pattern encapsulates all its mutable state and guards it with the object’s own intrinsic lock.

The Java monitor pattern is used by many library classes, such as Vector and Hashtable

The primary advantage of the Java monitor pattern is its simplicity

例子
public class PrivateLock {
     private final Object myLock = new Object();  用一个private lock的好处是：
     @GuardedBy("myLock") Widget widget;
     void someMethod() {
          synchronized(myLock) {
               // Access or modify the state of widget
          }
     }
}

用一个private lock的好处是：
Making the lock object private encapsulates the lock so that client code cannot acquire it, whereas a publicly accessible lock allows client code to participate in its synchronization policy—
correctly or incorrectly

4.2.2 Example: tracking fleet vehicles

4.3 Delegating thread safety

The Java monitor pattern is useful when building classes from scratch or composing classes out of objects that are not thread-safe  上面讲的是把不安全的变安全

But what if the components of our class are already thread-safe? Do we need to add an additional layer of thread safety? The answer is . . . “it depends”
In some cases a composite made of thread-safe components is thread-safe (Listings 4.7 and 4.9), and in others it is merely a good start (Listing 4.10).

4.3.1 Example: vehicle tracker using delegation
delegation的意思就是把安全交给它的‘组件’来实现；

4.3.2 Independent state variables
The delegation examples so far delegate to a single, thread-safe state variable. We can also delegate thread safety to more than one underlying state variable as long as those underlying state variables are independent, meaning that the composite class does not impose any invariants involving the multiple state variables.
也可以delegate到多个安全的‘组件’；只要invariant不涉及到多个‘组件’就行

4.3.3 When delegation fails
讲了一个失败的例子
一个range；有setup；setlow；如果一个线程setup到3；另一个setlow到5

If a class is composed of multiple independent thread-safe state variables and has no operations that have any invalid state transitions, then it can delegate thread safety to the underlying state variables.

4.3.4 Publishing underlying state variables

If a state variable is thread-safe, does not participate in any invariants that constrain its value, and has no prohibited state transitions for any of its operations, then it can safely be published.

4.3.5 Example: vehicle tracker that publishes its state
this.unmodifiableMap
= Collections.unmodifiableMap(this.locations);

4.4 Adding functionality to existing thread-safe classes

4.4.1 Client-side locking

错误的例子
@NotThreadSafe
public class ListHelper<E> {
     public List<E> list =
          Collections.synchronizedList(new ArrayList<E>());   public的。。。
     ...
     public synchronized boolean putIfAbsent(E x) {
          boolean absent = !list.contains(x);
          if (absent)
               list.add(x);
          return absent;
     }
}
因为putIfAbsent是在ListHelper上加锁的；加入list被暴露出去了；list的其它操作实际上是在另外一个锁上加锁的（可能是list自己，取决于list的实现；但是肯定不是ListHelper）

To make this approach work, we have to use the same lock that the List uses by using client-side locking or external locking. Client-side locking entails guarding client code that uses some object X with the lock X uses to guard its own state. In order to use client-side locking, you must know what lock X uses.

The documentation for Vector and the synchronized wrapper classes states, albeit obliquely, that they support client-side locking, by using the intrinsic lock for the Vector or the wrapper collection (not the wrapped collection).
文档说了list用的是哪个锁

改进版本
@ThreadSafe
public class ListHelper<E> {
     public List<E> list =
          Collections.synchronizedList(new ArrayList<E>());
     ...
     public boolean putIfAbsent(E x) {
          synchronized (list) {
               boolean absent = !list.contains(x);
               if (absent)
                    list.add(x);
               return absent;
          }
     }
}

4.4.2 Composition

There is a less fragile alternative for adding an atomic operation to an existing class: composition.

@ThreadSafe
public class ImprovedList<T> implements List<T> {
private final List<T> list;
public ImprovedList(List<T> list) { this.list = list; }
public synchronized boolean putIfAbsent(T x) {
boolean contains = list.contains(x);
if (contains)
list.add(x);
return !contains;
}
public synchronized void clear() { list.clear(); }
// ... similarly delegate other List methods
}
这里list是没有暴露的。。。

4.5 Documenting synchronization policies

Document a class’s thread safety guarantees for its clients; document its synchronization policy for its maintainers.

4.5.1 Interpreting vague documentation

## 第五章  Building Blocks
Where practical, delegation is one of the most effective strategies for creating thread-safe classes: just let existing thread-safe classes manage all the state.

5.1 Synchronized collections
The synchronized collection classes include Vector and Hashtable, part of the original JDK, as well as their cousins added in JDK 1.2, the synchronized wrapper classes created by the Collections.synchronizedXxx factory methods.

5.1.1 Problems with synchronized collections
The synchronized collections are thread-safe, but you may sometimes need to use additional client-side locking to guard compound actions.

Common compound actions on collections include iteration (repeatedly fetch elements until the collection is exhausted), navigation (find the next element after this one according to
some order), and conditional operations such as put-if-absent (check if a Map has a mapping for key K, and if not, add the mapping (K,V)).

With a synchronized collection, these compound actions are still technically thread-safe even without client-side locking, but they may not behave as you might expect when other
threads can concurrently modify the collection.

不安全的
public static Object getLast(Vector list) {
     int lastIndex = list.size() - 1;
     return list.get(lastIndex);
}
public static void deleteLast(Vector list) {
     int lastIndex = list.size() - 1;
     list.remove(lastIndex);
}

用client-side locking
安全的
public static Object getLast(Vector list) {
     synchronized (list) {
          int lastIndex = list.size() - 1;
          return list.get(lastIndex);
     }
}
public static void deleteLast(Vector list) {
     synchronized (list) {
          int lastIndex = list.size() - 1;
          list.remove(lastIndex);
     }
}

5.1.2 Iterators and ConcurrentModificationException
We use Vector for the sake of clarity in many of our examples, even though it is considered a “legacy” collection class.
vector是老旧的

But the more “modern” collection classes do not eliminate the problem of compound actions

The iterators returned by the synchronized collections are not designed to deal with concurrent modification, and they are fail-fast—meaning that if they detect that the collection has changed since
只是fail fast

they are designed to catch concurrency errors on a “good-faith-effort” basis and thus act only as early-warning indicators for concurrency problems.

They are implemented by associating a modification count with the collection: if the modification count changes during iteration, hasNext or next throws ConcurrentModificationException.

However, this check is done without synchronization, so there is a risk of seeing a stale value of the modification count and therefore that the iterator does not realize a modification has been made.

An alternative to locking the collection during iteration is to clone the collection and iterate the copy instead. Since the clone is thread-confined, no other thread can modify it during iteration, eliminating the possibility of ConcurrentModificationException.

5.1.3 Hidden iterators

While locking can prevent iterators from throwing ConcurrentModificationException, you have to remember to use locking everywhere a shared collection might be iterated.
如果对iterator加锁了，那么所有迭代可能发生的地方都有加锁；要不ConcurrentModificationException还是有可能抛的

隐含的iterate
public void addTenThings() {
     Random r = new Random();
     for (int i = 0; i < 10; i++)
     add(r.nextInt());
     System.out.println("DEBUG: added ten elements to " + set);
}
对set的增加也会引起其他地方的迭代抛异常。。

比如Set.toString()也会导致迭代。。

5.2 Concurrent collections
Java 5.0 improves on the synchronized collections by providing several concurrent collection classes. Synchronized collections achieve their thread safety by serializing all access to the collection’s state. The cost of this approach is poor concurrency;
synchronized collection不好

The concurrent collections, on the other hand, are designed for concurrent access from multiple threads. Java 5.0 adds ConcurrentHashMap, a replacement for synchronized hash-based Map implementations, and CopyOnWriteArrayList, a replacement for synchronized List implementations for cases where traversal is the dominant operation. The new ConcurrentMap interface adds support for common compound actions such as put-if-absent, replace, and conditional remove.

Replacing synchronized collections with concurrent collections can offer dramatic scalability improvements with little risk.
用Concurrent能增加点并发度

Java 5.0 also adds two new collection types, Queue and BlockingQueue.
ConcurrentLinkedQueue,
PriorityQueue, a (non concurrent) priority ordered
queue
Queue operations do not block; if the queue is empty, the retrieval operation returns null.
the Queue classes were added because eliminating the random-access requirements of List admits more efficient concurrent implementations.
BlockingQueue extends Queue to add blocking insertion and retrieval operations.
If the queue is empty, a retrieval blocks until an element is available, and if the queue is full (for bounded queues) an insertion blocks until there is space available.
Blocking queues are extremely useful in producer-consumer designs
Java 6 adds ConcurrentSkipListMap and ConcurrentSkipListSet, which are concurrent replacements for a synchronized SortedMap or SortedSet (such as TreeMap or TreeSet wrapped with synchronizedMap).

5.2.1 ConcurrentHashMap
The synchronized collections classes hold a lock for the duration of each operation.
ConcurrentHashMap is a hash-based Map like HashMap, but it uses an entirely
different locking strategy that offers better concurrency and scalability.

Instead of synchronizing every method on a common lock, restricting access to a single thread at a time, it uses a finer-grained locking mechanism called lock striping (see Section 11.4.3) to allow a greater degree of shared access.

Arbitrarily many reading threads can access the map concurrently, readers can access the map concurrently with writers, and a limited number of writers can modify the map concurrently.

The result is far higher throughput under concurrent access, with little performance penalty for single-threaded access.

ConcurrentHashMap, along with the other concurrent collections, further improve on the synchronized collection classes by providing iterators that do not throw ConcurrentModificationException, thus eliminating the need to lock the collection during iteration. The iterators returned by ConcurrentHashMap are weakly consistent instead of fail-fast. A weakly consistent iterator can tolerate concurrent modification, traverses elements as they existed when the iterator was constructed, and may (but is not guaranteed to) reflect modifications to the collection after the construction of the iterator.

As with all improvements, there are still a few tradeoffs. The semantics of methods that operate on the entire Map, such as size and isEmpty, have been slightly weakened to reflect the concurrent nature of the collection. Since the result of size could be out of date by the time it is computed, it is really only an estimate, so size is allowed to return an approximation instead of an exact count

in reality methods like size and isEmpty are far less useful in concurrent environments because these quantities are moving targets

The one feature offered by the synchronized Map implementations but not by ConcurrentHashMap is the ability to lock the map for exclusive access
没有大强度的锁

5.2.2 Additional atomic Map operations
Since a ConcurrentHashMap cannot be locked for exclusive access, we cannot use client-side locking to create new atomic operations such as put-if-absent, as we did for Vector in Section 4.4.1. Instead, a number of common compound operations such as put-if-absent, remove-if-equal, and replace-if-equal are implemented as atomic operations and specified by the ConcurrentMap interface, shown in Listing
5.7.
不能加client side lock；
提供了put if absent之类的实现

5.2.3 CopyOnWriteArrayList
CopyOnWriteArrayList is a concurrent replacement for a synchronized List that offers better concurrency in some common situations and eliminates the need to lock or copy the collection during iteration.

The copy-on-write collections derive their thread safety from the fact that aslong as an effectively immutable object is properly published, no further synchronization is required when accessing it.

Obviously, there is some cost to copying the backing array every time the collection is modified

the copy-on-write collections are reasonable to use only when iteration is far more common than modification. This criterion exactly describes many event-notification systems
场景

5.3 Blocking queues and the producer-consumer pattern
Blocking queues provide blocking put and take methods as well as the timed equivalents offer and poll.

Blocking queues support the producer-consumer design pattern

Bounded queues are a powerful resource management tool for building reliable applications: they make your program more robust to overload by throttling activities that threaten to produce more work than can be handled.

Build resource management into your design early using blocking queues—it is a lot easier to do this up front than to retrofit it later.

LinkedBlockingQueue and ArrayBlockingQueue are FIFO queues, analogous to LinkedList and ArrayList but with better concurrent performance than a synchronized List

PriorityBlockingQueue is a priority-ordered queue

SynchronousQueue, is not really a queue at all, in that it maintains no storage space for queued elements. Instead, it maintains a list of queued threads waiting to enqueue or dequeue an element

5.3.1 Example: desktop search

The producer-consumer pattern also enables several performance benefits.
Producers and consumers can execute concurrently; if one is I/O-bound and the other is CPU-bound, executing them concurrently yields better overall throughput than executing them sequentially. If the producer and consumer activities are parallelizable to different degrees, tightly coupling them reduces parallelizability to that of the less parallelizable activity.

看看例子

5.3.2 Serial thread confinement

The blocking queue implementations in java.util.concurrent all contain sufficient internal synchronization to safely publish objects from a producer thread to the consumer thread.

A thread-confined object is owned exclusively by a single thread, but that ownership can be “transferred” by publishing it safely where only one other thread will gain access to it and ensuring that the publishing thread does not access it after the handoff.

One could also use other publication mechanisms for transferring ownership of a mutable object, but it is necessary to ensure that only one thread receives the object being handed off. Blocking queues make this easy; with a little more work, it could also done with the atomic remove method of ConcurrentMap or the compareAndSet method of AtomicReference.

5.3.3 Deques and work stealing
Java 6 also adds another two collection types, Deque (pronounced “deck”) and BlockingDeque, that extend Queue and BlockingQueue.

A Deque is a double ended queue that allows efficient insertion and removal from both the head and the tail. Implementations include ArrayDeque and LinkedBlockingDeque

deques lend themselves to a related pattern called work stealing

in a work stealing design, every consumer has its own deque. If a consumer exhausts the work in its own deque, it can steal work from the tail of someone else’s deque. Work stealing can be more scalable than a traditional producer-consumer design because workers don’t contend for a shared work queue; most of the time they access only their own deque, reducing contention.

Work stealing is well suited to problems in which consumers are also producers— when performing a unit of work is likely to result in the identification of more work. For example, processing a page in a web crawler usually results in the identification of new pages to be crawled.

When a worker identifies a new unit of work, it places it at the end of its own deque (or alternatively, in a work sharing design, on that of another worker); when its deque is empty, it looks for work at the end of someone else’s deque, ensuring that each worker stays busy.

5.4 Blocking and interruptible methods
Threads may block, or pause, for several reasons: waiting for I/O completion, waiting to acquire a lock, waiting to wake up from Thread.sleep, or waiting for the result of a computation in another thread. When a thread blocks, it is usually suspended and placed in one of the blocked thread states (BLOCKED, WAITING, or TIMED_WAITING).

When that external event occurs, the thread is placed back in the RUNNABLE state and becomes eligible again for scheduling

When a method can throw InterruptedException, it is telling you that it is a blocking method, and further that if it is interrupted, it will make an effort to stop blocking early.

Thread provides the interrupt method for interrupting a thread and for querying whether a thread has been interrupted. Each thread has a boolean property that represents its interrupted status; interrupting a thread sets this status

Interruption is a cooperative mechanism.

One thread cannot force another to stop what it is doing and do something else; when thread A interrupts thread B, A is merely requesting that B stop what it is doing when it gets to a convenient stopping point—if it feels like it

the most sensible use for interruption is to cancel an activity

For library code, there are basically two choices:
Propagate the InterruptedException. This is often the most sensible policy if you can get away with it—just propagate the InterruptedException to your caller. This could involve not catching InterruptedException, or catching it and throwing it again after performing some brief activity-specific cleanup.
Restore the interrupt. Sometimes you cannot throw InterruptedException, for instance when your code is part of a Runnable. In these situations, you must catch InterruptedException and restore the interrupted status by calling interrupt on the current thread, so that code higher up the call stack can see that an interrupt was issued, as demonstrated in Listing 5.10.

You can get much more sophisticated with interruption, but these two approaches should work in the vast majority of situations. But there is one thing you should not do with InterruptedException—catch it and do nothing in response.

Cancellation and interruption are covered in greater detail in Chapter 7.

5.5 Synchronizers
synchronizer is any object that coordinates the control flow of threads based on its state. Blocking queues can act as synchronizers; other types of synchronizers include semaphores, barriers, and latches.

There are a number of synchronizer classes in the platform library; if these do not meet your needs, you can also create your own using the mechanisms described in Chapter 14.

All synchronizers share certain structural properties: they encapsulate state that determines whether threads arriving at the synchronizer should be allowed to pass or forced to wait, provide methods to manipulate that state, and provide methods to wait efficiently for the synchronizer to enter the desired state.

5.5.1 Latches
A latch is a synchronizer that can delay the progress of threads until it reaches its terminal state

A latch acts as a gate: until the latch reaches the terminal state the gate is closed and no thread can pass, and in the terminal state the gate opens, allowing all threads to pass

Once the latch reaches the terminal state, it cannot change state again, so it remains open forever

例子
• Ensuring that a computation does not proceed until resources it needs have been initialized. A simple binary (two-state) latch could be used to indicate
“Resource R has been initialized”, and any activity that requires R would wait first on this latch.
• Ensuring that a service does not start until other services on which it depends have started. Each service would have an associated binary latch; starting service S would involve first waiting on the latches for other services on which S depends, and then releasing the S latch after startup completes so any services that depend on S can then proceed.
• Waiting until all the parties involved in an activity, for instance the players in a multi-player game, are ready to proceed. In this case, the latch reaches the terminal state after all the players are ready.

CountDownLatch is a flexible latch implementation that can be used in any of these situations; it allows one or more threads to wait for a set of events to occur

The latch state consists of a counter initialized to a positive number, representing the number of events to wait for

有例子

5.5.2 FutureTask
FutureTask also acts like a latch. (FutureTask implements Future, which describes an abstract result-bearing computation

computation represented by a FutureTask is implemented with a Callable, the result-bearing equivalent of Runnable, and can be in one of three states: waiting to run, running, or completed.

Once a FutureTask enters the completed state, it stays in that state forever.

FutureTask is used by the Executor framework to represent asynchronous tasks, and can also be used to represent any potentially lengthy computation that can be started before the results are needed

看看例子

5.5.3 Semaphores
Counting semaphores are used to control the number of activities that can access a certain resource or perform a given action at the same time

Counting
semaphores can be used to implement resource pools or to impose a bound on a collection

5.5.4 Barriers

Barriers are similar to latches in that they block a group of threads until some event has occurred [CPJ 4.4.3]. The key difference is that with a barrier, all the threads must come together at a barrier point at the same time in order to proceed

Latches are for waiting for events; barriers are for waiting for other threads.

CyclicBarrier

看看例子

5.6 Building an efficient, scalable result cache
一个例子 todo 看看


## Summary of Part I
• It’s the mutable state, stupid.1
All concurrency issues boil down to coordinating access to mutable state. The less mutable state, the easier it is to ensure thread safety.
• Make fields final unless they need to be mutable.
• Immutable objects are automatically thread-safe.
Immutable objects simplify concurrent programming tremendously.
They are simpler and safer, and can be shared freely without locking or defensive copying.
• Encapsulation makes it practical to manage the complexity.
You could write a thread-safe program with all data stored in global variables, but why would you want to? Encapsulating data within objects makes it easier to preserve their invariants; encapsulating
synchronization within objects makes it easier to comply with their synchronization policy.
• Guard each mutable variable with a lock.
• Guard all variables in an invariant with the same lock.
• Hold locks for the duration of compound actions.
• A program that accesses a mutable variable from multiple threads without synchronization is a broken program.
• Don’t rely on clever reasoning about why you don’t need to synchronize.
• Include thread safety in the design process—or explicitly document that your class is not thread-safe.

-->

[1]: http://book.douban.com/subject/1888733/ "Java Concurrency in Practice"
