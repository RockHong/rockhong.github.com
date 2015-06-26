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
- 读书笔记
date: 2015-05-16 15:15:00
image:
image_desc:
---

好记性不如烂笔头，所以做一下<[Java Concurrency in Practice][1]>的小抄和笔记，省得又忘记了。这本书目前
在豆瓣的评分是9.4分。推荐👍。

对于书里面显而易见的话，就不直接列出原文了；在HTML注释里可以看到原文。

### Chapter 1 Introduction
<!-- Since threads share the memory address space of their owning process, all threads within a process have access to the same variables and allocate objects from the same heap -->
一个进程的所有线程共享这个进程的地址空间，所以所有的线程都能看到heap上的变量和对象。每个线程都有自己的stack，
stack上的变量和对象是互相隔离的。

<!-- the implementation of the JVM—the garbage collector usually runs in one or more dedicated threads. -->
JVM的垃圾回收器也是跑在另外的线程（一个或多个）里的。

<!-- Since the basic unit of scheduling is the thread -->
操作系统调度的单位是线程。

<!-- On a two-processor system, a single-threaded program is giving up access to half the available CPU resources -->
<!-- If a program is single-threaded, the processor remains idle while it waits for a synchronous I/O operation to complete -->
<!-- Simplicity of modeling
This benefit is often exploited by frameworks such as servlets or RMI (Remote Method Invocation).-->
多线程的好处：      

- 有效地利用多处理器的资源     
- 在某个线程等待I/O完成时，其它的线程可以利用CPU      
- 简化建模（modeling）。比如像servlets或者RMI这样的框架利用了多线程来简化建模。

<!-- Java class libraries acquired a set of packages (java.nio) for nonblocking I/O；这个类似linux的select，poll
However, operating system support for larger numbers of threads has improved significantly, making the thread-per-client model practical even for large numbers of clients on some platforms. -->
对于非阻塞I/O，Java也提供了多个包（`java.nio`）；类似于linux中的select和poll（有多类似则待确认）。
由于操作系统提升，在某些平台上即使是在client数目非常多的情况下，thread-per-client模型也是实际可行的。

<!-- 1.2.4 More responsive user interfaces -->

<!-- 在这本书里，作者用@NotThreadSafe表示示例的代码是不安全的；同理的，有@ThreadSafe and @Immutable等 -->

#### 1.3.2 Liveness hazards
<!-- While safety means “nothing bad ever happens”, liveness concerns the complementary goal that “something good eventually happens” -->
`thread safety`侧重于“nothing bad ever happens”，程序不会出错。`liveness`侧重于“something good
eventually happens”，程序不会卡住，能运行下去。

#### 1.3.3 Performance hazards
<!--threads nevertheless carry some degree of runtime overhead. Context switches
significant costs: saving and restoring execution context, loss of locality, and CPU time spent scheduling threads instead of running them
When threads share data, they must use synchronization mechanisms that can inhibit compiler optimizations, flush or invalidate memory caches, and create synchronization traffic on the shared memory bus. -->
线程对性能的影响：

- 上下文切换（context switch）的成本：保留和恢复上下文，缓存的失效（loss of locality），话费在调度上的
CPU时间等。
- 线程间同步（synchronization）带来的影响：失去编译器的优化，flush or invalidate memory caches（应该是
保证可见性带来的副作用）和create synchronization traffic on the shared memory bus。

<!-- 1.4 线程无处不在 -->
<!-- When the JVM starts, it creates threads for JVM housekeeping tasks (garbage collection, finalization) and a main thread for running the main method. -->
JVM启动时会创建多个线程来执行JVM housekeeping tasks (garbage collection, finalization)，以及一个
主线程来执行`main`方法。

>Frameworks introduce concurrency into applications by calling application components from
>framework threads. Components invariably access application state, thus requiring that all 
>code paths accessing that state be thread-safe.     

在引入了多线程的框架里，你的代码一般会在框架控制的（多个）线程里被调用。如果你的代码会访问一个被多个线程共享
的state，那么需要保证对这个state的所有访问都是线程安全的。

<!-- The facilities described below all cause application code to be called from threads not managed by the application.
    举了一些例子；这些例子，用户的代码被框架控制的线程所调用

Timer
TimerTasks are executed in a thread managed by the Timer, not the application.
If a TimerTask accesses data that is also accessed by other application threads, then not only must the TimerTask do so in a thread-safe manner, but so must any other classes that access that data.
the easiest way to achieve this is to ensure that objects accessed by the TimerTask are themselves thread-safe, thus encapsulating the thread safety within the shared objects.

Servlets and JavaServer Pages (JSPs). 
When a servlet accesses objects shared across servlets or requests, it must coordinate access to these objects properly, since multiple requests could be accessing them simultaneously from separate threads. 
Servlets and JSPs, as well as servlet filters and objects stored in scoped containers like ServletContext and HttpSession, simply have to be thread-safe.

Remote Method Invocation.
When the RMI code calls your remote object, in what thread does that call happen? You don’t know, but it’s definitely not in a thread you created—your object gets called in a thread managed by RMI. -->

书里举了一些引入了多线程的框架的例子，比如Timer/TimerTasks，Servlets和RMI。（见注释）


### Chapter 2 Thread Safety
<!-- But these are just mechanisms—means to an end. Writing thread-safe code is, at its core, about managing access to state, and in particular to shared, mutable state
    锁之类的概念不是全部；重要的是要了解机制。 -->  
<!-- Informally, an object’s state is its data, stored in state variables such as instance or static fields. -->
<!-- By shared, we mean that a variable could be accessed by multiple threads; by mutable, we mean that its value could change during its lifetime. -->
编写thread-safe的代码的核心是管理对（对象的）state的访问，特别是那些共享的、可变的state。    
简单点说，state就是一个对象的data/变量。      
“共享的”意为一个变量可以/可能被多个线程访问；“可变的”意为一个变量的值可能会被改变。

<!-- Whether an object needs to be thread-safe depends on whether it will be accessed from multiple threads. This is a property of how the object is used in a program, not what it does. -->
一个对象是不是需要成为一个thread-safe对象取决于这个对象会不会被多个线程访问。所以，这主要取决于程序怎么
使用一个对象，而不是这个对象的功能是什么。

<!-- Whenever more than one thread accesses a given state variable, and one of them might write to it, they all must coordinate their access to it using synchronization. -->
当有多个线程访问一个state，且其中有一个线程可能会修改这个state时，那么这些线程就要使用同步（synchronization）
来协调好它们对这个state的访问。并发的读不需要同步。
<!--more-->

<!-- The primary mechanism for synchronization in Java is the synchronized keyword, which provides exclusive locking, but the term “synchronization” also includes the use of volatile variables, explicit locks, and atomic variables. -->
Java里最简单的同步机制是`synchronized`关键字；它是一种互斥的锁机制。“同步”（synchronization）还
包括`volatile`变量的使用、explicit locks和原子（atomic）变量等机制。

<!-- If multiple threads access the same mutable state variable without appropriate synchronization, your program is broken. There are three ways to fix it:
• Don’t share the state variable across threads;
• Make the state variable immutable; or
• Use synchronization whenever accessing the state variable. -->
如果多个线程没有使用合适的同步机制就去访问同一个可变的state，那么你的程序就是有问题的。三种解决方法：      
 
- 不要在线程间共享这个state
- 把这个state对应的变量变成不可变的（immutable），或者
- 不管什么时候，只要访问这个state就加上合适的同步操作

<!-- It is far easier to design a class to be thread-safe than to retrofit it for thread safety later. -->
事先就把一个类设计成thread-safe比事后再把它修改成thread-safe要容易得多。

<!-- When designing thread-safe classes, good object-oriented techniques—encapsulation, immutability, and clear specification of invariants—are your best friends. -->
在设计thread-safe类时，封装（encapsulation），不变性（immutability），清晰的不变式（invariants）会有助于
设计。

#### 2.1 What is thread safety?
<!--
At the heart of any reasonable definition of thread safety is the concept of correctness. Correctness means that a class conforms to its specification. A good specification defines invariants constraining an object’s state and postconditions describing the effects of its operations. -->
线程安全的定义中最核心的是“正确性”（correctness）。“正确”的意思是一个类遵守它的规格说明（specification）。
好的规格说明定义了invariants和postconditions。invariants用来约束对象的state；postconditions用来
描述操作的效果（effects of its operations）。

<!--A class is thread-safe if it behaves correctly when accessed from multiple threads, regardless of the scheduling or interleaving of the execution of those threads by the runtime environment, and with no additional synchronization or other coordination on the part of the calling code. -->
<!-- Thread-safe classes encapsulate any needed synchronization so that clients need not provide their own. -->
如果一个类在被多个线程调用，且调用方不需要加额外的同步代码的情况下，能保持正确性，那么这个类就是thread-safe的。
Thread-safe类已经把任何需要的同步操作都封装在它的内部了，所以调用方不需要再加任何的同步代码。

<!-- 2.1.1 Example: a stateless servlet
Stateless objects are always thread-safe. -->
没有state的对象（stateless objects）永远是线程安全的。

<!-- 2.2 Atomicity
@NotThreadSafe
public class UnsafeCountingFactorizer implements Servlet {
     private long count = 0;            估计多个请求会共同访问同一个servlet对象，所以这里引入一个count成员会产生thread not safe的问题
     public long getCount() { return count; }
     public void service(ServletRequest req, ServletResponse resp) {
          BigInteger i = extractFromRequest(req);
          BigInteger[] factors = factor(i);
          ++count;
          encodeIntoResponse(resp, factors);
     }
} -->

#### 2.2.1 Race conditions
<!--A race condition occurs when the correctness of a computation depends on the relative timing or interleaving of multiple threads by the runtime; in other words, when getting the right answer relies on lucky timing. -->
当程序的正确性取决于运行时多个线程的调用时机或者顺序（relative timing or interleaving of multiple
threads），那么我们就说程序出现了race condition。换句话说，正确性全靠运气。

<!-- The most common type of race condition is check-then-act, where a potentially stale observation is used to make a decision on what to do next. -->
最常见的race condition类型是check-then-act，在这种情况下“check”可能会观察到一个过时的状态（stale state），
这会使得程序可能基于错误的条件做了“action”。

#### 2.2.2 Example: race conditions in lazy initialization
<!--A common idiom that uses check-then-act is lazy initialization -->
一个不线程安全的check-then-act的例子。这里使用check-then-act做lazy initialization。

	public class LazyInitRace {
	     private ExpensiveObject instance = null;
	     public ExpensiveObject getInstance() {
	          if (instance == null)       // 非线程安全
	          	instance = new ExpensiveObject();
	          return instance;
	     }
	}

#### 2.2.3 Compound actions

>To avoid race conditions, there must be a way to prevent other threads from using a variable
>while we’re in the middle of modifying it,

为了避免race condition，如果一个操作使用到了一个变量，那么必须要防止其它线程在这个操作的中间时刻使用这个变量。

<!-- Operations A and B are atomic with respect to each other if, from the perspective of a thread executing A, when another thread executes B, either all of B has executed or none of it has. An atomic operation is one that is atomic with respect to all operations, including itself, that operate on the same state. -->
原子性（atomic）指的是在其它操作看来，一个操作要么所有步骤全部完成，要么所有步骤都没完成。（这些操作作用在
同一个state上。）

<!-- To ensure thread safety, check-then-act operations (like lazy initialization) and read-modify-write operations (like increment) must always be atomic. -->
为了线程安全，check-then-act操作，（比如lazy initialization）和read-modify-write操作（比如
increment）都应该是原子操作。

<!-- The java.util.concurrent.atomic package contains atomic variable classes for effecting atomic state transitions on numbers and object references. -->
我们可以用java.util.concurrent.atomic包中的一些类对numbers和对象引用做一些原子操作。
可以利用这些类来保证操作的原子性；当然也可以用锁

     private final AtomicLong count = new AtomicLong(0);
     count.incrementAndGet();

<!-- When a single element of state is added to a stateless class, the resulting class will be thread-safe if the state is entirely managed by a thread-safe object. -->
如果向stateless类里加**一个**thread-safe的对象，那么这个类仍然线程安全。

<!-- Where practical, use existing thread-safe objects, like AtomicLong, to manage your class’s state. It is simpler to reason about the possible states and state transitions for existing thread-safe objects than it is for arbitrary state variables, and this makes it easier to maintain and verify thread safety. -->
如果可能的话，用已经存在的thread-safe对象，比如AtomicLong，来维护一个类的state，会使得这个类在保持或者验证
thread-safey时变得简单一点。

<!-- 2.3 Locking
To preserve state consistency, update related state variables in a single atomic operation. -->
如果一个对象的state的一致性涉及到多个state，那么所有相关的state变量都要在一个原子操作里更新。

#### 2.3.1 Intrinsic locks
<!--Java provides a built-in locking mechanism for enforcing atomicity: the synchronized block.

A synchronized block has two parts: a reference to an object that will serve as the lock, and a block of code to be guarded by that lock

A synchronized method is a shorthand for a synchronized block that spans an entire method body, and whose lock is the object on which the method is being invoked. (Static synchronized methods
use the Class object for the lock.) -->
Java提供了内建的locking机制来保证原子性：synchronized block。       
一个synchronized块有两个部分：一个对象引用，这个对象会被当成锁；已经被这个锁保护的一个代码块。      
当synchronized块的范围是整个方法，且整个块的锁就是this对象时，可以简写成synchronized方法。      
static的synchronized方法用这个类的`Class`对象当锁。

	synchronized (lock) {
	     // Access or modify shared state guarded by lock
	}

	public synchronized void service(ServletRequest req, ServletResponse resp) {
	
	}

<!-- Every Java object can implicitly act as a lock for purposes of synchronization;
these built-in locks are called intrinsic locks or monitor locks. 

The fact that every object has a built-in lock is just a convenience so that you needn’t explicitly create lock objects
-->
每个Java对象都可以当锁；这种锁也叫intrinsic locks或者monitor locks。      
每个对象都可以当锁（或者说都有一个锁）只是为了方便，这样我们就不需要再显式地创建“锁对象”了。

<!-- The lock is automatically acquired by the executing thread before entering a synchronized block and automatically released when control exits the synchronized block, whether by the normal control path or by throwing an exception out of the block. -->
一个线程进入synchronized块前需要得到锁；当这个线程退出这个synchronized块（正常退出或者抛异常退出）时，
释放这个锁。

<!-- Intrinsic locks in Java act as mutexes (or mutual exclusion locks), which means that at most one thread may own the lock. -->
Java里intrinsic lock和mutex一样，在一个时刻只有一个线程能得到它。

#### 2.3.2 Reentrancy
<!--But because intrinsic locks are reentrant, if a thread tries to acquire a lock that it already holds, the request succeeds.
Reentrancy means that locks are acquired on a per-thread rather than per-invocation basis.
Reentrancy is implemented by associating with each lock an acquisition count and an owning thread.

Without reentrant locks, the very natural-looking code in Listing 2.7, in which a subclass overrides a synchronized method and then calls the superclass method, would deadlock. -->
intrinsic lock是可以重入的（reentrant）；就是说，如果一个线程已经得到了锁，那么当它再去请求这个锁时，
请求会成功。      
Reentrancy意味着获得锁是基于每个线程的，而不是基于每个调用。在实现时，锁会记住拥有它的线程以及一个计数
（acquisition count）。（每获得一次锁这个计数会加一，每释放一次锁这个技术减一？）      
如果intrinsic lock不是重入的，那么在子类重载的synchronized方法里调用父类的方法就会死锁。

#### 2.4 Guarding state with locks
<!--
However, just wrapping the compound action with a synchronized block is not sufficient;if synchronization is used to coordinate access to a variable, it is needed everywhere that variable is accessed -->
如果使用同步来协调对一个变量的访问，那么所有访问到这个变量的地方都需要加上同步代码。比如，只在写操作地方加同步
代码是不够的，也要在所有读操作的地方加同步代码；要不读到的可能是过时的状态或者中间状态。

<!-- Further, when using locks to caoordinate access to a variable, the same lock must be used wherever that variable is accessed. 

For each mutable state variable that may be accessed by more than one thread, all accesses to that variable must be performed with the same lock held. In this case, we say that the variable is guarded by that lock.
-->
另外，如果用锁来协调对一个变量的访问，那么所有访问这个变量的地方都要用同一个锁。

<!-- Every shared, mutable variable should be guarded by exactly one lock. Make it clear to maintainers which lock that is. -->

     if (!vector.contains(element))
          vector.add(element);
          
<!-- This attempt at a put-if-absent operation has a race condition, even though both contains and add are atomic. -->
上面的代码中，虽然`contains`和`add`都是原子操作，但是整个put-if-absent操作仍然不是原子的。

#### 2.5 Liveness and performance
<!--
narrowing the scope of the synchronized block. 
You should be careful not to make the scope of the synchronized block too small; you would not want to divide an operation that should be atomic into more than one synchronized block.

But it is reasonable to try to exclude from synchronized blocks long-running operations that do not affect shared state, so that other threads are not prevented from accessing the shared state while the long-running operation is in progress.

Acquiring and releasing a lock has some overhead, so it is undesirable to break down synchronized blocks too far

Deciding how big or small to make synchronized blocks may require tradeoffs among competing design forces, including safety (which must not be compromised), simplicity, and performance.

There is frequently a tension between simplicity and performance. When implementing a synchronization policy, resist the temptation to prematurely sacrifice simplicity (potentially compromising safety) for the sake of performance.

Avoid holding locks during lengthy computations or operations at risk of not completing quickly such as network or console I/O. -->

同步对liveness和性能的影响：      
同步会影响liveness。       
缩小synchronized块可以提高liveness。但是也不要把synchronized块分得太细；例如不要把一个原子操作分成
多个synchronized块。        
synchronized块里最好不要放运行时间很长的操作；如果这个操作不会影响相关的state，可以吧它移到块外以提高
liveness。       
得到和释放锁也是有成本的，所以synchronized块也不要分得太细。      
synchronized块的大小需要在thread-safety，代码简洁和性能间做权衡。      
在权衡代码简介和性能时，要避免过早地优化；先保持代码简洁，真有了性能上的需要再考虑优化。      

### Chapter 3 Sharing Objects
<!--it is a common misconception that synchronized is only about atomicity or demarcating “critical sections”. Synchronization also has another significant, and subtle, aspect: memory visibility. -->
synchronized关键字不仅仅是关于atomicity或者标出“critical sections”；
synchronized/synchronization也会影响内存可见性（memory visibility）。

<!-- You can ensure that objects are published safely either by using explicit synchronization or by taking advantage of the synchronization built into library classes.
可以用同步来保证对象都是被‘完整地’publish（看不到中间状态）；也可以利用java提供的类的帮助 -->

#### 3.1 Visibility
<!--
In general, there is no guarantee that the reading thread will see a value written by another thread on a timely basis, or even at all. In order to ensure visibility of memory writes across threads, you must use synchronization -->
一般情况下（不加额外的同步代码），java不能保证一个线程可以**及时地**看到另一个线程对一个变量做的修改，甚至
有可能根本看不到（而不仅仅是不及时）。为了在线程之间保证内存写操作的可见性（visibility of memory writes），
必须要加同步代码。

	public class NoVisibility {
	    private static boolean ready;
	    private static int number;
	    private static class ReaderThread extends Thread {
	        public void run() {
	            while (!ready)
	                Thread.yield();
	            System.out.println(number);
	        }
	    }
	    public static void main(String[] args) {
	        new ReaderThread().start();
	        number = 42; 
	        ready = true;
	    }
	}

<!-- While it may seem obvious that NoVisibility will print 42, it is in fact possible that it will print zero, or never terminate at all! Because it does not use adequate synchronization, there is no guarantee that the values of ready and number written by the main thread will be visible to the reader thread. -->
这里主线程对`number`和`ready`变量做写操作；另外一个线程去读这两个变量。程序可能会打印出42（显而易见）；
程序也可能会打印出0（就是说另一个线程看到主线程对`ready`的修改，却没看到对`number`的修改）；程序也有可能
一直循环下去（另一个线程完全没看到主线程对`ready`的修改）。这是因为程序没有使用足够的同步代码，所以内存的可见性
在线程间没有什么保证。

<!-- NoVisibility could loop forever because the value of ready might never become visible to the reader thread. Even more strangely, NoVisibility could print zero because the write to ready might be made visible to the reader thread before the write to number, a phenomenon known as reordering.

In the absence of synchronization, the compiler, processor, and runtime can do some downright weird things to the order in which operations appear to execute. Attempts to reason about the order in which memory actions “must” happen in insufficiently synchronized multithreaded programs will almost certainly be incorrect.

Fortunately, there’s an easy way to avoid these complex issues: always use the proper synchronization whenever data is shared across threads. -->
上面的程序可能打印出0是因为`ready`变量的修改先于`number`变量被看见；即使在代码上`number`先于`ready`被
写。这个现象叫reordering。在没有同步的情况下，编译器、处理器和runtime都可以改变执行顺序。     
为了防止上述的问题，最简单的方法是，无论何时当需要跨线程共享数据时都加上合适的同步代码。

#### 3.1.1 Stale data
<!--
NoVisibility demonstrated one of the ways that insufficiently synchronized programs can cause surprising results: stale data.

Worse, staleness is not all-or-nothing: a thread can see an up-to-date value of one variable but a stale value of another variable that was written first. -->
上面的NoVisibility例子展示了缺少必要同步的后果：过时的数据（stale data）。      
糟糕的是，staleness不是要么修改全可见，要么全不可见。一个线程可能看到对某个变量的修改，却看不到对另外一个变量的
修改，即使另一个变量是先被修改的。

	public class MutableInteger {
	    private int value;
	    public int get() { return value; }
	    public void set(int value) { this.value = value; }
	}
	
<!-- if one thread calls set, other threads calling get may or may not see that update. -->
如果一个线程调用set，另一个线程可能看到，也可能看不到相应的修改。

	public class SynchronizedInteger {
	    private int value;
	    public synchronized int get() { return value; }
	    public synchronized void set(int value) { this.value = value; }
	}

加上同步代码，可以解决问题。

#### 3.1.2 Nonatomic 64-bit operations
<!--When a thread reads a variable without synchronization, it may see a stale value, but at least it sees a value that was actually placed there by some thread rather than some random value. This safety guarantee is called out-of-thin-air safety.

Out-of-thin-air safety applies to all variables, with one exception: 64-bit numeric variables (double and long) that are not declared volatile (see Section 3.1.4).
因为 the JVM is permitted to treat a 64-bit read or write as two separate 32-bit operations；可能一半更新了，一半没有。。

Thus, even if you don’t care about stale values, it is not safe to use shared mutable long and double variables in multithreaded programs unless they are declared volatile or guarded by a lock. -->
如果不加同步代码，线程可能会看到stale value，但是java至少可以保证这个值是被某个线程在之前写入的，而不是
一个随机值。这种保证叫out-of-thin-air safety。       
Out-of-thin-air safety适用于所有变量，除了64位的数字变量（numeric variables），比如没有被`volatile`
修饰的double和long。因为JVM是运行把64位的读写操作分成两个32位的操作（是不是只有32位处理器上的JVM才这样？待
确认）；所以，64位数可能会只更新了一半。       
所以，即使你不在乎值是否是stale，在线程间不加同步代码（volatile或者锁）就共享可变的long和double变量也是
不安全的。

#### 3.1.3 Locking and visibility
<!--
In other words, everything A did in or prior to a synchronized block is visible to B when it executes a synchronized block guarded by the same lock. Without synchronization, there is no such guarantee.

Locking is not just about mutual exclusion; it is also about memory visibility. To ensure that all threads see the most up-to-date values of shared mutable variables, the reading and writing threads must synchronize on a common lock. -->
锁和可见性（locking and visibility）       
线程A在synchronized块里或者synchronized块前做的任何事情在线程B执行被同一个锁保护的synchronized块时都会
对B可见。在没有同步的情况下，是没有这种保证的。       
所以锁不仅仅是互斥，锁也影响内存的可见性。为了保证所有线程都能看到共享变量的最新状态，线程需要在同一个锁上做
同步。

#### 3.1.4 Volatile variables
<!--weaker form of synchronization,
volatile variables

When a field is declared volatile, the compiler and runtime are put on notice that this variable is shared and that operations on it should not be reordered with other memory operations. Volatile variables are not cached in registers or in caches where they are hidden from other processors, so a read of a volatile variable always returns the most recent write by any thread -->
`volatile`是一种“稍弱”一点的同步方式。      
如果一个变量被声明成`volatile`，那么编译器和runtime会保证：      

- 不会把对这个变量的操作和其它内存操作做reorder
- 不会把这个变量缓存在寄存器里，也不会把这个变量放在其它处理器看不到的cache里；线程总是能看到这个变量的最新值      

> The visibility effects of volatile variables extend beyond the value of the volatile variable itself.
> When thread A writes to a volatile variable and subsequently thread B reads that same variable, the
> values of all variables that were visible to A prior to writing to the volatile variable become visible
> to B after reading the volatile variable.

当线程A写一个`volatile`变量，之后线程B读到这个变量时，在A写`volatile`变量之前所有对A可见的变量在B读这个`volatile`
变量时也会对B可见。（所以为了使多个变量都可见，只要令最后/晚被写的那个变量为`volatile`就可以了，而不用全部声明成
`volatile`？待确认）

<!-- 38页 -->
访问一个`volatile`不会阻塞线程，所以可以把它看成是一种比`synchronized`更轻量级的同步方式。

>So from a memory visibility perspective, writing a volatile variable is like exiting a synchronized block
>and reading a volatile variable is like entering a synchronized block. 

从内存可见性角度看，写一个`volatile`变量就好像（应该只是“好像”，不是“等于”）离开一个synchronized块，而读一个`volatile`
变量就好像进入一个synchronized块。

<!-- However, we do not recommend relying too heavily on volatile variables for visibility; code that relies on volatile variables for visibility of arbitrary state is more fragile and harder to understand than code that uses locking.

Use volatile variables only when they simplify implementing and verifying your synchronization policy; avoid using volatile variables when veryfing correctness would require subtle reasoning about visibility. Good uses of volatile variables include ensuring the visibility of their own state, that of the object they refer to, or indicating that an important lifecycle event (such as initialization or shutdown) has occurred.

Volatile variables are convenient, but they have limitations. The most common use for volatile variables is as a completion, interruption, or status flag, such as the asleep flag in Listing 3.4. -->
不要太依赖volatile变量来完成visibility；相比于用锁，太依赖volatile可能会使得代码更脆弱（不好写对），更难理解。只有当
用volatile可以简化同步的实现和验证时才去用它。       
使用volatile变量的好的用例包括：      

> ensuring the visibility of their own state, that of the object they refer to, or indicating that an
> important lifecycle event (such as initialization or shutdown) has occurred

> The most common use for volatile variables is as a completion, interruption, or status flag

一个用例，下面的`asleep`变量：

    volatile boolean asleep;
    ...
    while (!asleep)
        countSomeSheep();

<!--For example, the semantics of volatile are not strong enough to make the increment operation (count++) atomic, unless you can guarantee that the variable is written only from a single thread.

Locking can guarantee both visibility and atomicity; volatile variables can only guarantee visibility. -->
volatile变量可以带来一些便利，也有一些限制。比如volatile变量不足以让自增操作（count++）变成原子操作，**除非**你能保证
只有一个线程会写这个volatile变量，其它线程都只做读操作。      
锁能同时保证visibility和atomicity；volatile只能保证visibility。

#### 3.2 Publication and escape
<!--Publishing an object means making it available to code outside of its current scope, such as by storing a reference to it where other code can find it, returning it from a nonprivate method, or passing it to a method in another class. -->
Publishing一个对象就是让这个对象在“外层scope”可见/可用。Publish就是发布、暴露的意思。      
某些时候，我们希望暴露对象和对象的内部状态；有些时候，暴露又是必须的（为了线程安全，可能需要额外的同步）。        
暴露对象可能会使得invariants更难维护。

<!-- An object that is published when it should not have been is said to have escaped. -->
不该暴露的对象却被暴露了，这叫escape。      
escaped对象都可能导致线程安全问题；因为你不知道使用者是怎么使用escaped对象的。

有很多暴露对象的途径：       

- 把变量声明成public的       
- 在非private的方法里返回一个对象      
- 把一个对象传给其它类的方法     
- 等等

对象可能会被**间接地**暴露（只要一个对象可以被直接暴露的对象间接地引用到），比如下面的Secret对象。

	 public static Set<Secret> knownSecrets;	 public void initialize() {        knownSecrets = new HashSet<Secret>();    }

<!-- Passing an object to an alien method must also be considered publishing that object. -->
把一个对象传给一个alien方法也是一种publish。alien方法是指其它类的方法，或者overrideable的方法（那些非private非
final的方法）。因为alien方法怎么使用传入的对象是不可控的，所以可能会有线程安全的问题。

>A final mechanism by which an object or its internal state can be published is to publish an inner
>class instance ... because inner class instances contain a hidden reference to the enclosing instance.

还有一种暴露对象的方式是：如果一个对象的inner class instance被暴露出去了，那么这个对象也会被间接地暴露出去。
因为inner class的对象总是可以通过`OutterClass.this`来引用它的外层类的对象。

#### 3.2.1 Safe construction practices
<!--
If the this reference escapes during construction, the object is considered not properly constructed.

publishing an object from within its constructor can publish an incompletely constructed object. This is true even if the publication is the last statement in the constructor.-->
不要让`this`引用在对象构造期间escape出去，因为那个时候对象并完全被构造好，它还没处于一个consistent state。     
即使publication发生在构造函数的最后一个语句也是不可以的；这个时候对象仍然是未构造完成的。     
总之：“Do not allow the this reference to escape during construction.”

>A common mistake that can let the this reference escape during construction is to start a thread from
>a constructor. When an object creates a thread from its constructor, it almost always shares its this
>reference with the new thread, either explicitly (by passing it to the constructor) or implicitly
>(because the Thread or Runnable is an inner class of the owning object).

>There’s nothing wrong with creating a thread in a constructor, but it is best not to start the
>thread immediately. Instead, expose a start or initialize method that starts the owned thread.

不要在构造函数里**启动（start）**一个线程。因为对象创建线程时会把`this`共享给这个线程（TODO：how it possible？）     
可以在构造函数里**创建**一个线程。

>Calling an overrideable instance method (one that is neither private nor final) from the constructor
>can also allow the this reference to escape.

在构造函数里调用可重载的方法也会escape `this`引用。

`this`引用escape的例子，

	public class ThisEscape {
	  public ThisEscape(EventSource source) {
	    source.registerListener ( 
	      new EventListener() {
	        public void onEvent(Event e) { 
	          doSomething(e);
	        }
	      });
	  }
	}

>If you are tempted to register an event listener or start a thread from a constructor, you can avoid
>the improper construction by using a private constructor and a public factory method

通过private的构造函数和public的工厂方法改造上面的例子（TODO：体会一下），

	public class SafeListener {
	  private final EventListener listener;
	  
	  private SafeListener() {
	    listener = new EventListener() {
	      public void onEvent(Event e) { 
	        doSomething(e);
	      }
	    };
	  }
	  
	  public static SafeListener newInstance(EventSource source) {
	    SafeListener safe = new SafeListener(); 
	    source.registerListener (safe.listener);
	    return safe;
	  }
	}

#### 3.3 Thread confinement
<!--
Accessing shared, mutable data requires using synchronization; one way to avoid this requirement is to not share. If data is only accessed from a single thread, no synchronization is needed. This technique, thread confinement, is one of the simplest ways to achieve thread safety.-->
在线程间共享可变的data需要同步；为了避免同步，可以让data只能被一个线程访问。这种技术叫“thread confinement”。

<!--the use of pooled JDBC
The JDBC specification does not require that Connection objects be thread-safe the pool will not dispense the same connection to another thread until it has been returned-->
一个这样的例子是：the use of pooled JDBC (Java Database Connectivity) Connection objects。    
Connection对象不是线程安全的。但是在典型的应用场景下，一个线程（一个请求）从pool里得到一个Connection对象后，
只会在这个线程里使用；pool也不会把同一个Connection对象分配给另外的请求/线程。

<!--Thread confinement is an element of your program’s design that must be enforced by its implementation. The language and core libraries provide mechanisms that can help in maintaining thread confinement—local variables and the ThreadLocal class—but even with these, it is still the programmer’s responsibility to ensure that thread-confined objects do not escape from their intended thread.-->
虽然java提供了一些机制，比如local变量和`ThreadLocal`类，但是thread confinement更多的是一种程序上的design。
开发者需要保证thread-confined对象不从指定的线程里escape出去。

#### 3.3.1 Ad-hoc thread confinement
>Ad-hoc thread confinement describes when the responsibility for maintaining thread confinement
>falls entirely on the implementation. 

Ad-hoc thread confinement是指把维护thread confinement的责任交给程序员；不依赖/使用特定的语言工具来实现thread
confinement。

<!--Ad-hoc thread confinement can be fragile because none of the language features,-->
把一个特定的子系统，比如GUI，设计成单线程的，以此来保证thread confinement。虽然由于没使用任何额外的手段会
使程序变得脆弱（可能会不经意间打破thread confinement而不自知），但是简单的设计可能会使程序开发变得容易。

<!--A special case of thread confinement applies to volatile variables. It is safe to perform read-modify-write operations on shared volatile variables as long as you ensure that the volatile variable is only written from a single thread. In this case, you are confining the modification to a single thread to prevent race conditions, and the visibility guarantees for volatile variables ensure that other threads see the most up-to-date value.-->
推荐少用ad-hoc thread confinement，因为代码会变得脆弱；尽量用更健壮的thread confinement手段，比如
stack confinement或者ThreadLocal。

#### 3.3.2 Stack confinement
<!--Stack confinement is a special case of thread confinement in which an object can only be reached through local variables.

Local variables are intrinsically confined to the executing thread; they exist on the executing thread’s stack, which is not accessible to other threads.

There is no way to obtain a reference to a primitive variable, so the language semantics ensure that primitive local variables are always stack confined.

Maintaining stack confinement for object references requires a little more assistance from the programmer to ensure that the referent does not escape.-->
Stack confinement是指一个对象仅能通过（stack上的）local变量引用到。local变量存在于线程的stack上，而各个
线程的stack是互相不可见的。       
如果local变量是primitive类型的，那么这个local变量是不会被其它线程引用到的。       
如果local变量是引用类型，那么要保证这个引用不要escape。      
如果一个对象是stack confined，那么即使这个对象不是线程安全的，程序仍然是线程安全的。

使用stack confinement时，最好有一个清晰的文档；否则可能不知不觉被维护者违法。

#### 3.3.3 ThreadLocal
<!--A more formal means of maintaining thread confinement is ThreadLocal, which allows you to associate a per-thread value with a value-holding object
Thread- Local provides get and set accessor methods that maintain a separate copy of the value for each thread that uses it, so a get returns the most recent value passed to set from the currently executing thread.-->
另一种更formal的维持thread confinement的方式是`ThreadLocal`；使用它可以associate a per-thread value with a
value-holding object。

<!--Thread-local variables are often used to prevent sharing in designs based on mutable Singletons or global variables.
If you are porting a single-threaded application to a multithreaded environment, you can preserve thread safety by converting shared global variables into ThreadLocals, if the semantics of the shared globals permits this; an application－wide cache would not be as useful if it were turned into a number of thread-local caches.-->
可变的Singleton或者global变量都不是线程安全，这时可以考虑使用thread-local变量。      
在把单线程程序移植为多线程程序是，可以考虑用ThreadLocal来替代共享的全局变量以达到线程安全。但是在porting时，把application
level的cache变成thread-local的cache可能会使得cache失去了原来的意义。所以要视具体情况而定。

	private static ThreadLocal<Connection> connectionHolder 
	    = new ThreadLocal<Connection>() {
	        public Connection initialValue() {
	            return DriverManager.getConnection(DB_URL);
	        }
	    };
	    
	public static Connection getConnection() { 
	    return connectionHolder.get();
	}

<!--This technique can also be used when a frequently used operation requires a temporary object such as a buffer and wants to avoid reallocating the temporary object on each invocation. -->
如果某个方法需要一个buffer，且这个方法经常被调用，为了避免反复reallocate这个buffer，可以使用ThreadLocal。
在单线程的程序中，则可以用一个“全局”变量来做buffer。

<!--When a thread calls ThreadLocal.get for the first time, initialValue is consulted to provide the initial value for that thread. -->

<!--The thread-specific values are stored in the Thread object itself; when the thread terminates, the thread-specific values can be garbage collected.-->
线程终止时，ThreadLocal变量会被垃圾回收。

<!--ThreadLocal is widely used in implementing application frameworks.
J2EE containers associate a transaction context with an executing thread for the duration of an EJB call. This is easily implemented using a static Thread- Local holding the transaction context-->
ThreadLocal常常用来实现application framework；比如一些J2EE的框架。

不要滥用ThreadLocal；不要把ThreadLocal当成可以随便增加global变量和某些“隐藏”变量的执照。这会减少reusability，
增加couplings。

#### 3.4 Immutability
<!--An immutable object is one whose state cannot be changed after construction.

their invariants are established by the constructor, and if their state cannot be changed, these invariants always hold.

Immutable objects are always thread-safe.
-->
构造后就不变的对象叫immutable对象。       
immutable对象的invariants在它们的构造函数里建立，之后就再也不会违反这些invariants了。      
immutable对象永远是线程安全的。

<!--but immutability is not equivalent to simply declaring all fields of an object final. An object whose fields are all final may still be mutable, since final fields can hold references to mutable objects.-->
简单把一个对象的所有field都声明成final的并不等于immutability。final的引用变量所指向的对象还是可能改变内容的。

<!--An object is immutable if:
• Its state cannot be modified after construction;
• All its fields are final;12 and
• It is properly constructed (the this reference does not escape during construction).-->
当满足下面三个条件时，对象就是immutable的：

- 构造之后对象的state都不能变；       
- 所有的field都是final的；       
- 构造期间，this引用没有escape。

<!--Program state stored in immutable objects can still be updated by “replacing” immutable objects with a new instance holding new state; the next section offers an example of this technique. -->
可以通过immutable对象存储程序的state；想要改变程序的state，可以替换一个新的immutable对象。

#### 3.4.1 Final fields
<!--Just as it is a good practice to make all fields private unless they need greater visibility [EJ Item 12], it is a good practice to make all fields final unless they need to be mutable. -->
如果field不是可变就把它声明成final，这是一个good practice。

#### 3.4.2 Example: Using volatile to publish immutable objects
<!--
However, immutable objects can sometimes provide a weak form of atomicity.

Whenever a group of related data items must be acted on atomically, consider creating an immutable holder class for them, such as OneValueCache14 in Listing 3.12.

Race conditions in accessing or updating multiple related variables can be eliminated by using an immutable object to hold all the variables. 

with an immutable one, once a thread acquires a reference to it, it need never worry about another thread modifying its state. If the variables are to be updated, a new holder object is created, but any threads working with the previous holder still see it in a consistent state.

This combination of an immutable holder object for multiple state variables related by an invariant, and a volatile reference used to ensure its timely visibility, allows VolatileCachedFactorizer to be thread-safe even though it does no explicit locking.-->
immutable对象某些时候可以保证一种较弱的原子性（a weak form of atomicity）。        
当一组相关的data需要以原子操作的方式被更新时，可以考虑把这些相关的data包在一个immutable对象里。          
使用immutable对象可以消除访问和更新一组相关变量时潜在的race condition。             
需要更新状态时，就用一个新的immutable对象来替换老的。虽然其它线程看到的有可能仍然是老的immutable对象，那么至少数据
都是一致的。为了保证其它线程看到最新的immutable对象，可以在声明这个immutable对象的引用时加上volatile关键字。      
通过immutable对象和volatile，可以不用显式地locking就达到线程安全。

一个使用immutable对象和volatile的例子，

	class OneValueCache {
	    private final BigInteger lastNumber; 
	    private final BigInteger[] lastFactors;

	    public OneValueCache(BigInteger i, BigInteger[] factors) {
		     lastNumber = i;
			  lastFactors = Arrays.copyOf(factors, factors.length); 
	    }
	    
	    public BigInteger[] getFactors(BigInteger i) {
	        if (lastNumber == null || !lastNumber.equals(i))
	            return null;
	        else
	            return Arrays.copyOf(lastFactors, lastFactors.length);
	    }
	}

	public class VolatileCachedFactorizer implements Servlet {
	    private volatile OneValueCache cache = new OneValueCache(null, null);

	    public void service(ServletRequest req, ServletResponse resp) { 
	        BigInteger i = extractFromRequest(req);
	        BigInteger[] factors = cache.getFactors(i);
	        if (factors == null) {
	            factors = factor(i);
	            cache = new OneValueCache(i, factors); 
	        }
	        encodeIntoResponse(resp, factors); 
	    }
	}

#### 3.5 Safe publication
<!--
Unfortunately, simply storing a reference to an object into a public field, as in Listing 3.14, is not enough to publish that object safely.

This improper publication could allow another thread to observe a partially constructed object.
-->

#### 3.5.1 Improper publication: when good objects go bad

一个improper publication的例子，

	public class Holder {       private int n;       public Holder(int n) { this.n = n; }       public void assertSanity() { 
	        if (n != n)
	            throw new AssertionError("This statement is false.");￼￼       }
	}	// Unsafe publication
	public Holder holder;
	public void initialize() { 
	    holder = new Holder(42);
	}

一个线程A用上面的“unsafe publication”来publish一个Holder的引用；另外一个线程B使用这个published的Holder引用
来调用Holder的assertSanity()方法，这时有可能会抛AssertionError异常😱。

虽然在Holder的构造函数已经完全构建好了invariants，但是由于improper publication另外的线程仍然可能看到一个
partially constructed object。

上面的代码（因为没有加同步）可能会导致以后的问题：     

- 其它的线程可能会看到一个stale的`holder`引用，也就是说线程A虽然已经设置了`holder`，但是线程B可能还是会看到null。       
- 更糟的是，其它线程可能能看到`holder`的最新值，但是看到`holder`对应的对象的state却是stale的。       
- 另外，一个线程可能在某个时刻看到stale值，在下一个时刻却看到更新后的值；这就是上面代码有可能会抛异常的原因。对于
`if (n != n)`，两次看到的n是不同的值。

<!--3.4.1 Final fields

Final fields can’t be modified (although the objects they refer to can be modified if they are mutable), but they also have special semantics under the Java Memory Model. It is the use of final fields that makes possible the guarantee of initialization safety (see Section 3.5.2) that lets immutable objects be freely accessed and shared without synchronization. -->

#### 3.5.2 Immutable objects and initialization safety

<!-- Because immutable objects are so important, the Java Memory Model offers a special guarantee of initialization safety for sharing immutable objects.

As we’ve seen, that an object reference becomes visible to another thread does not necessarily mean that the state of that object is visible to the consuming thread.

Immutable objects, on the other hand, can be safely accessed even when synchronization is not used to publish the object reference. 
For this guarantee of initialization safety to hold, all of the requirements for immutability must be met: unmodi- fiable state, all fields are final, and proper construction.

mmutable objects can be used safely by any thread without additional synchronization, even when synchronization is not used to publish them. -->
上面的`Holder`例子可以看到，多线程环境下对象的reference是visible的，不代表对象的state是visible的。       
但是对于immutable对象（满足之前提到的immutable对象的三个要求），它可以不需要额外的同步代码就能被安全的访问。JVM能
保证initialization safety for sharing immutable objects。      

<!--This guarantee extends to the values of all final fields of properly constructed objects; final fields can be safely accessed without additional synchronization. However, if final fields refer to mutable objects, synchronization is still required to access the state of the objects they refer to. -->
另外，如果一个properly constructed object被标记成final，JVM也会作同样的保证；所以final field可以不加同步代码
就能安全的访问。       
但是，如果final field指向的对象是可变的，那么访问这个对象的state还是需要同步的。

#### 3.5.3 Safe publication idioms
<!--Objects that are not immutable must be safely published, which usually entails synchronization by both the publishing and the consuming thread. For the moment, let’s focus on ensuring that the consuming thread can see the object in its as－published state; 

To publish an object safely, both the reference to the object and the object’s state must be made visible to other threads at the same time. A properly constructed object can be safely published by:
• Initializing an object reference from a static initializer;
• Storing a reference to it into a volatile field or AtomicReference;
• Storing a reference to it into a final field of a properly constructed object; or
• Storing a reference to it into a field that is properly guarded by a lock.-->
可变对象必须要safely published；通常要在publishing线程和consuming线程上都加上同步代码。这里先关心consuming线程，
讨论如何让consuming线程看到对象的正确state（就是让consuming线程看到publishing线程想要publish的state）。      

要safely publish对象，对象的引用和对象的state都要对另外的线程visible。一个properly constructed object可以
通过以下的方式来safely publish：        

- Initializing an object reference from a static initializer;       
- Storing a reference to it into a volatile field or AtomicReference;      
- Storing a reference to it into a final field of a properly constructed object; or      
- Storing a reference to it into a field that is properly guarded by a lock.       

<!--The internal synchronization in thread-safe collections means that placing an object in a thread-safe collection, such as a Vector or synchronizedList, fulfills the last of these requirements. If thread A places object X in a thread-safe collec- tion and thread B subsequently retrieves it, B is guaranteed to see the state of X as A left it, even though the application code that hands X off in this manner has no explicit synchronization.

The thread-safe library collections offer the following safe publication guarantees, even if the Javadoc is less than clear on the subject:
• Placing a key or value in a Hashtable, synchronizedMap, or Concurrent- Map safely publishes it to any thread that retrieves it from the Map (whether directly or via an iterator);
• Placing an element in a Vector, CopyOnWriteArrayList, CopyOnWrite- ArraySet, synchronizedList, or synchronizedSet safely publishes it to any thread that retrieves it from the collection;
• Placing an element on a BlockingQueue or a ConcurrentLinkedQueue safely publishes it to any thread that retrieves it from the queue. -->
另外，也可以利用java自带的thread-safe collections来safely publish一个对象。publishing线程把对象放到一个
这样的collection里，consuming线程再去取这个对象；这种方式可以保证consuming线程得到的对象都是safely published。
因为这些collection内部加了同步代码。      
Java自带的线程安全的collection有`Hashtable`，`synchronizedMap`，`ConcurrentMap`，`Vector`，`CopyOnWriteArrayList`
，`CopyOnWriteArraySet`， `synchronizedList`，`synchronizedSet`，`BlockingQueue`，`ConcurrentLinkedQueue`等。

<!--Using a static initializer is often the easiest and safest way to publish objects that can be statically constructed:
public static Holder holder = new Holder(42);
Static initializers are executed by the JVM at class initialization time; because of internal synchronization in the JVM, this mechanism is guaranteed to safely publish any objects initialized in this way-->
如果对象可以被静态地构造，那么使用static是最简单的方式：

    public static Holder holder = new Holder(42);
    
JVM会在类初始化的时候执行上面的这个static initializer；JVM内部会有一些同步来保证statically initialized的对象被
safely publish。

#### 3.5.4 Effectively immutable objects
<!--Safe publication is sufficient for other threads to safely access objects that are not going to be modified after publication without additional synchronization. The safe publication mechanisms all guarantee that the as-published state of an object is visible to all accessing threads as soon as the reference to it is visible, and if that state is not going to be changed again, this is sufficient to ensure that any access is safe.

Objects that are not technically immutable, but whose state will not be modified after publication, are called effectively immutable. 

Safely published effectively immutable objects can be used safely by any thread without additional synchronization.-->
如果一个对象被safely published之后再也不会做任何修改，那么publish之后再访问它就不需要额外的同步代码了。      
因为safe publication保证了其它线程都能看到对象引用和对象state的最新值，且后续也不会修改这个对象，所以没必要加同步。     
我们把那些虽然可变，但是一旦publish之后就不会再改的对象叫做effectively immutable对象。      
effectively immutable对象safely published之后就不用再同步了。          
利用这一点可以简化程序的开发和性能。        

书中讲了一个例子，

    public Map<String, Date> lastLogin = Collections.synchronizedMap(new HashMap<String, Date>());

这里Date是可变的；通过上面提过的利用线程安全的collection来safely publish Date对象；如果publish之后，Date再也
不会被改变了，那么后续使用Date的时候就不用加额外的同步代码了。

<!--3.5.5 Mutable objects
If an object may be modified after construction, safe publication ensures only the visibility of the as-published state. Synchronization must be used not only to publish a mutable object, but also every time the object is accessed to ensure visibility of subsequent modifications. -->
如果对象是可变的，那么safe publication只保证让其它线程看到这个对象publish时的最新状态（only the visibility of
the as-published state）。后续访问这个对象时也要加同步代码；要不如果这个对象被修改了，修改的可见性却不能保证。

<!--The publication requirements for an object depend on its mutability:-->
对于可变性不同的对象，publication的要求也不相同：    
    
- Immutable objects can be published through any mechanism;       
- Effectively immutable objects must be safely published;      
- Mutable objects must be safely published, and must be either thread-safe or guarded by a lock.

#### 3.5.6 Sharing objects safely
<!--
The most useful policies for using and sharing objects in a concurrent program are:
Thread-confined. A thread-confined object is owned exclusively by and confined to one thread, and can be modified by its owning thread.
Shared read-only. A shared read-only object can be accessed concur- rently by multiple threads without additional synchronization, but cannot be modified by any thread. Shared read-only objects include immutable and effectively immutable objects.
Shared thread-safe. A thread-safe object performs synchronization in- ternally, so multiple threads can freely access it through its public interface without further synchronization.
Guarded. A guarded object can be accessed only with a specific lock held. Guarded objects include those that are encapsulated within other thread-safe objects and published objects that are known to be guarded by a specific lock.-->
总结一下，在多线程环境中使用和共享对象的policy有：       

- Thread-confined；不会被分享，所以也不需要同步。        
- Shared read-only；对于immutable或者effectively immutable对象，访问时不需要加同步。       
- Shared thread-safe；A thread-safe object performs synchronization internally, so multiple threads can freely access it through its public interface without further synchronization.      
- Guarded；A guarded object can be accessed only with a specific lock held. Guarded objects include those that are encapsulated within other thread-safe objects and published objects that are known to be guarded by a specific lock.

<!--## 第4章 Composing Objects

4.1 Designing a thread-safe class

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
