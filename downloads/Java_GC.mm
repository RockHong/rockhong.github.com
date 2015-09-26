
<map version="0.9.0">
    <node TEXT="Java GC" FOLDED="false">
        <edge COLOR="#b4b4b4" />
        <font NAME="Helvetica" SIZE="10" />
        <node TEXT="JVM的相关参数" FOLDED="false" POSITION="left">
            <edge COLOR="#e68782" />
            <font NAME="Helvetica" SIZE="10" />
            <node TEXT="-XX:SurvivorRatio=6" FOLDED="false">
                <edge COLOR="#e79584" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="-XX:NewRatio=3，NewSize，MaxNewSize" FOLDED="false">
                <edge COLOR="#e5827e" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="-XX:MinHeapFreeRatio=&lt;minimum&gt;，-XX:MaxHeapFreeRatio=&lt;maximum&gt;" FOLDED="false">
                <edge COLOR="#e68f7f" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="-XX:+DisableExplicitGC，禁用System.gc()" FOLDED="false">
                <edge COLOR="#e7a38b" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="-XX:+UseConcMarkSweepGC" FOLDED="false">
                <edge COLOR="#e59788" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="-XX:+UseSerialGC" FOLDED="false">
                <edge COLOR="#e7a188" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="‑XX:MaxPermSize，默认64M （64位时，85M）" FOLDED="false">
                <edge COLOR="#e59c82" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="–XX:MaxTenuringThreshold" FOLDED="false">
                <edge COLOR="#e4827b" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="size of heap, **-Xms** initial size, **-Xmx** maximum size" FOLDED="false">
                <edge COLOR="#e4867d" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="-XX:+PrintGCApplicationStoppedTime 
某些JVM支持这个参数。如果支持的话，report GC pause time时会把reach to global safe point的时间也考虑在内" FOLDED="false">
                <edge COLOR="#e7927e" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="-XX:PretenureSizeThreshold=n
和大对象的创建有关" FOLDED="false">
                <edge COLOR="#e89089" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="‑XX:+UseParallelOldGC和‑XX:+UseParallelGC
用哪个parallel collector" FOLDED="false">
                <edge COLOR="#e69d83" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="gc log相关的参数" FOLDED="false">
                <edge COLOR="#e78c82" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="-Xloggc:&lt;filename&gt;，输出gc log到文件" FOLDED="false">
                    <edge COLOR="#e79c85" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="-XX:+PrintGCDetails，gc相关的统计信息" FOLDED="false">
                    <edge COLOR="#e8a08a" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="-XX:+PrintGCDateStamps，gc发生时的时间信息" FOLDED="false">
                    <edge COLOR="#e88986" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="-XX:+PrintTenuringDistribution，打印tenuring-age info" FOLDED="false">
                    <edge COLOR="#e79587" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="-XX:+PrintGCApplicationConcurrentTime" FOLDED="false">
                    <edge COLOR="#e6837a" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="-XX:+PrintGCApplicationStoppedTime， stop point相关" FOLDED="false">
                    <edge COLOR="#e37979" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="-XX:+PrintAdaptiveSizePolicy" FOLDED="false">
                    <edge COLOR="#e7918b" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="-XX:MaxGCPauseMillis" FOLDED="false">
                    <edge COLOR="#e6997e" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="-XX:InitiatingHeapOccupancyPercent" FOLDED="false">
                    <edge COLOR="#e48d78" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="-XX:ConcGCThreads" FOLDED="false">
                    <edge COLOR="#e67b78" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="-XX:G1ReservePercent" FOLDED="false">
                    <edge COLOR="#e99185" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
            </node>
        </node>
        <node TEXT="其它" FOLDED="false" POSITION="right">
            <edge COLOR="#988ee3" />
            <font NAME="Helvetica" SIZE="10" />
            <node TEXT="可以通过程序打印出程序当前使用的collector
ManagementFactory.getGarbageCollectorMXBeans()" FOLDED="false">
                <edge COLOR="#9887e1" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
        </node>
        <node TEXT="collector的种类" FOLDED="false" POSITION="right">
            <edge COLOR="#67d7c4" />
            <font NAME="Helvetica" SIZE="10" />
            <node TEXT="C4" FOLDED="false">
                <edge COLOR="#6bdac5" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="G1" FOLDED="false">
                <edge COLOR="#64d9ac" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="HotSpot CMS" FOLDED="false">
                <edge COLOR="#64d7be" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="[1] p64, 减少了full gc，但是pause（应该是minor gc引起的）会变多" FOLDED="false">
                    <edge COLOR="#64d6b8" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
            </node>
            <node TEXT="HostSpot" FOLDED="false">
                <edge COLOR="#6dd8b7" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="minor collection是STW的" FOLDED="false">
                    <edge COLOR="#6fd9b1" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
            </node>
        </node>
        <node TEXT="参考资料" FOLDED="false" POSITION="right">
            <edge COLOR="#9ed56b" />
            <font NAME="Helvetica" SIZE="10" />
            <node TEXT="[Java Garbage Collection Distilled](http://www.infoq.com/articles/Java_Garbage_Collection_Distilled) [3]" FOLDED="false">
                <edge COLOR="#96d66d" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="[G1: One Garbage Collector To Rule Them All](http://www.infoq.com/articles/G1-One-Garbage-Collector-To-Rule-Them-All) [1]" FOLDED="false">
                <edge COLOR="#9dd774" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="The Garbage Collection Handbook by Richard Jones et al." FOLDED="false">
                <edge COLOR="#8ad265" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="[The Java Garbage Collection Mini-Book](http://www.infoq.com/minibooks/java-garbage-collection) 主要参考" FOLDED="false">
                <edge COLOR="#99d871" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="[Tips for Tuning the Garbage First Garbage Collector](http://www.infoq.com/articles/tuning-tips-G1-GC) [2]" FOLDED="false">
                <edge COLOR="#9fd360" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
        </node>
        <node TEXT="基础知识、**术语**" FOLDED="false" POSITION="left">
            <edge COLOR="#efa670" />
            <font NAME="Helvetica" SIZE="10" />
            <node TEXT="**Key Term**" FOLDED="false">
                <edge COLOR="#eeae68" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="**tracking**
precise的垃圾回收器（包括现在所有的回收器）在collection时都用了tracking mechanism" FOLDED="false">
                    <edge COLOR="#ec9361" />
                    <font NAME="Helvetica" SIZE="10" />
                    <node TEXT="对于tracking来说，循环引用不要紧；一个cyclic object graph没有被tracking，那么它就会整个丢弃" FOLDED="false">
                        <edge COLOR="#eb765d" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                    <node TEXT="Tracing collectors use three techniques: **mark/sweep/compact** collection,
**copying** collection, and **mark/compact** collection
一般的商业回收器会3种技术都用
可能heap的一部分区域用一个技术，另外一部分区域用另外一个技术" FOLDED="false">
                        <edge COLOR="#eb9b59" />
                        <font NAME="Helvetica" SIZE="10" />
                        <node TEXT="trade-offs
copying collector回收时是single pass的；没有fragment；需要double heap size；但是，很多商业的collector仍然会用到copy；
mark/sweep collector只要一点额外的空间；" FOLDED="false">
                            <edge COLOR="#e98f52" />
                            <font NAME="Helvetica" SIZE="10" />
                        </node>
                        <node TEXT="**Mark(also known as trace)**" FOLDED="false">
                            <edge COLOR="#e98354" />
                            <font NAME="Helvetica" SIZE="10" />
                            <node TEXT="目的是找到**所有**living对象
从**root**开始找，root包括static variables，registers，thread stacks等" FOLDED="false">
                                <edge COLOR="#e87e52" />
                                <font NAME="Helvetica" SIZE="10" />
                            </node>
                            <node TEXT="花费的时间
linearly with the size of the live set rather than the size of the heap." FOLDED="false">
                                <edge COLOR="#e88654" />
                                <font NAME="Helvetica" SIZE="10" />
                            </node>
                        </node>
                        <node TEXT="**Compact/relocate**" FOLDED="false">
                            <edge COLOR="#eaac53" />
                            <font NAME="Helvetica" SIZE="10" />
                            <node TEXT="dead object回收后会产生碎片，所以要**periodically** relocate live object，使得碎片可以合并起来
relocate live object的过程中，live object的位置变了，那么所有指向这个object的引用就要更新一下，这个过程叫做**remapping**
remapping花费的时间和live set成正比" FOLDED="false">
                                <edge COLOR="#e79e57" />
                                <font NAME="Helvetica" SIZE="10" />
                            </node>
                            <node TEXT="compacting collector分两种：in-place compactor（不需要额外空间，一般把live object从一端移到另一端），evacuating compactor（借助额外空间）" FOLDED="false">
                                <edge COLOR="#eca75c" />
                                <font NAME="Helvetica" SIZE="10" />
                            </node>
                        </node>
                        <node TEXT="**copy**" FOLDED="false">
                            <edge COLOR="#ea9d5d" />
                            <font NAME="Helvetica" SIZE="10" />
                            <node TEXT="把heap分成大小相等的两个区域：from和to
新对象在form里分配
回收时，把from里所有活的移到to里，更新引用，交换from和to的职责
花费的时间和live set成正比" FOLDED="false">
                                <edge COLOR="#ea9560" />
                                <font NAME="Helvetica" SIZE="10" />
                            </node>
                            <node TEXT="当copying collector和generational collector相结合时
（HotSpot-based）把young generation的区域分成3个的部分：1个Eden和2个比Eden小很多的survivor；
Eden永远是“from”，两个survivor会在from和to之间互相切换；
回收（young）时，把from的对象移到“to survivor”里或者promote到old generation区域里（“from survivor”里的对象可能会promote）；
survivor空间小没关系，如果“to survivor”装不下，会移到old generation里；这个叫做**premature promotion**；
old generation的大小要和Eden一样大" FOLDED="false">
                                <edge COLOR="#ec8c60" />
                                <font NAME="Helvetica" SIZE="10" />
                            </node>
                        </node>
                        <node TEXT="**Sweep**" FOLDED="false">
                            <edge COLOR="#ea9c5b" />
                            <font NAME="Helvetica" SIZE="10" />
                            <node TEXT="sweep包括：scan through the entire heap, identify all the dead objects
, and recycle their space in some way
扫描整个heap，标识dead对象，准备回收这些dead对象" FOLDED="false">
                                <edge COLOR="#ecb65e" />
                                <font NAME="Helvetica" SIZE="10" />
                            </node>
                            <node TEXT="花费的时间和heap的大小成正比" FOLDED="false">
                                <edge COLOR="#ecb85a" />
                                <font NAME="Helvetica" SIZE="10" />
                            </node>
                        </node>
                    </node>
                </node>
                <node TEXT="**Generational collection**" FOLDED="false">
                    <edge COLOR="#edb264" />
                    <font NAME="Helvetica" SIZE="10" />
                    <node TEXT="针对short-lived和long-lived对象，heap被分成了两个部分
young(or &quot;new&quot;) generation
old(or &quot;tenured&quot;) generation
如果一个对象活得够久，那么它会**promote**到old generation
对young generation的回收叫做**“minor garbage-collection event”**" FOLDED="false">
                        <edge COLOR="#ec9158" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                    <node TEXT="几乎所有的Java collector都或多或少地用到 generational collection" FOLDED="false">
                        <edge COLOR="#ecad5a" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                    <node TEXT="基于**“the weak generational hypothesis”**假设，就是新创建的对象只会live很短的时间" FOLDED="false">
                        <edge COLOR="#eda163" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                    <node TEXT="因为young object dies young，所以GC把重点放在young generation区域。
减少回收old generation的频率（因为很多时候对young generation的回收就够用了，没必要回收old？）" FOLDED="false">
                        <edge COLOR="#eb9459" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                    <node TEXT="**Remembered sets**" FOLDED="false">
                        <edge COLOR="#e9b35b" />
                        <font NAME="Helvetica" SIZE="10" />
                        <node TEXT="**write barrier**" FOLDED="false">
                            <edge COLOR="#ea995b" />
                            <font NAME="Helvetica" SIZE="10" />
                            <node TEXT="a write barrier that intercepts the storing of every Java reference in order to track potential references from old objects into the young generation.
通过一个write barrier来拦截所有的reference的storing
这是一个**blind** barrier，就是会拦截所有的reference，而不仅仅是从old到young的reference；因为条件判断费时间" FOLDED="false">
                                <edge COLOR="#ea9656" />
                                <font NAME="Helvetica" SIZE="10" />
                            </node>
                        </node>
                        <node TEXT="“remembered set” as a way of keeping track of all references pointing from the old generation into the young generation.
它记住所有从old到young的引用" FOLDED="false">
                            <edge COLOR="#eab55f" />
                            <font NAME="Helvetica" SIZE="10" />
                        </node>
                        <node TEXT="considered to be **part of the roots** for young-generation collecting
在检查young generation的对象有没有被引用时，remembered set作为root的一部分（另一部分应该是stack frame之类的）
有了remembered set，可以避免扫描整个old generation" FOLDED="false">
                            <edge COLOR="#ebba62" />
                            <font NAME="Helvetica" SIZE="10" />
                        </node>
                        <node TEXT="remembered set is tracked in a **card table** which may use a byte or a bit to indicate that a range of words in the old-generation heap may contain a reference to the young generation" FOLDED="false">
                            <edge COLOR="#e79658" />
                            <font NAME="Helvetica" SIZE="10" />
                        </node>
                    </node>
                </node>
                <node TEXT="Parallel vs. serial, concurrent vs. stop-the-world" FOLDED="false">
                    <edge COLOR="#ee976b" />
                    <font NAME="Helvetica" SIZE="10" />
                    <node TEXT="**single-threaded or parallel**
collector可以单线程，也可以是parallel的
单线程的只能用一个cpu core
parallel的使用多个线程来进行collection，可以利用多核的优势" FOLDED="false">
                        <edge COLOR="#ee9f64" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                    <node TEXT="**stop-the-world or concurrent**
stop-the-world (STW) 的collector在GC时会停止程序的执行
concurrent的collector在GC期间允许程序继续执行" FOLDED="false">
                        <edge COLOR="#ef8e6f" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                    <node TEXT="**Incremental vs. monolithic**
Incremental的collector把GC操作分成多个small discrete steps；每个step之间可能有large gap
monolithic的collector会“一次性”把GC做完" FOLDED="false">
                        <edge COLOR="#ed9977" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                    <node TEXT="**Precise vs. conservative**" FOLDED="false">
                        <edge COLOR="#efa867" />
                        <font NAME="Helvetica" SIZE="10" />
                        <node TEXT="A collector is **precise** if it can fully identify and process all object references at the time of collection.
A collector has to be precise if it is to **move** objects，因为一个对象被移动后要重建**所有**原来指向它的引用" FOLDED="false">
                            <edge COLOR="#ee995f" />
                            <font NAME="Helvetica" SIZE="10" />
                            <node TEXT="**OopMaps** in HotSpot-based JVM
OopMaps是structures that record where object references (OOPs) are located on the Java stack for every piece of code it is safe to do a GC in." FOLDED="false">
                                <edge COLOR="#ed8d57" />
                                <font NAME="Helvetica" SIZE="10" />
                            </node>
                        </node>
                        <node TEXT="A collector is termed **conservative** if it is unaware of some object references at collection time, or is unsure about whether a field is a reference or not" FOLDED="false">
                            <edge COLOR="#edbb62" />
                            <font NAME="Helvetica" SIZE="10" />
                        </node>
                        <node TEXT="**All commercial server JVMs use precise collectors** and use a form of moving collector at some point in the garbage collection cycle." FOLDED="false">
                            <edge COLOR="#ed9960" />
                            <font NAME="Helvetica" SIZE="10" />
                        </node>
                    </node>
                </node>
                <node TEXT="**safe points**" FOLDED="false">
                    <edge COLOR="#ee9c73" />
                    <font NAME="Helvetica" SIZE="10" />
                    <node TEXT="理想情况下，safe point应该经常出现。STW发生时，所有的线程都要到达safe point。如果某一个线程没到，那就要等待。" FOLDED="false">
                        <edge COLOR="#ed9373" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                    <node TEXT="A **global safe point** involves bringing **all** threads to a safe point" FOLDED="false">
                        <edge COLOR="#ec946c" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                    <node TEXT="Garbage-collection events occur at safe points" FOLDED="false">
                        <edge COLOR="#ed9271" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                    <node TEXT="safe point is a **point or range** in **a thread**’s execution **when** the collector can **identify all the references** in that thread’s execution stack" FOLDED="false">
                        <edge COLOR="#ee9376" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                    <node TEXT="Bringing a thread to safe point is the act of getting a thread to reach a safe point and then not executing past it
一个线程到了safe point不意味着它应该停止执行，比如JNI的代码可以执行，因为它不影响safe point" FOLDED="false">
                        <edge COLOR="#ed8c6d" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                    <node TEXT="除了GC涉及到safe point，其它场景也可能需要到达safe point。比如JVM de-optimise code时；比如当JVM发现一个类不属于继承体系时，它会优化这个类的方法的调用；当JVM发现后续这个类被加入到一个继承体系时，JVM需要de-optimise code；
de-optimise code需要的safe point和GC需要的safe point“内涵”不同" FOLDED="false">
                        <edge COLOR="#ee9a6c" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                </node>
            </node>
            <node TEXT="an **object** is either a class instance or an array" FOLDED="false">
                <edge COLOR="#f1a175" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="The **reference** values (often called only “references”) logically point to these objects from **stack frames** or other objects. 
reference逻辑上来说是从stack或者其它object指向一个object。" FOLDED="false">
                <edge COLOR="#edc173" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="object存在**heap**上
all object instances (including arrays) is allocated in heap
heap memory can be shared between threads
All instance fields, static fields, and array elements are stored in the Java heap" FOLDED="false">
                <edge COLOR="#f0bb68" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="**但是**，local variables, formal-method parameters, and exception handler
parameters reside outside heap; they are never shared
between threads and are unaffected by the memory model" FOLDED="false">
                    <edge COLOR="#f19e66" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="除了heap， java会用一些其它的内存来storing material other
than Java objects, such as the code cache, VM threads, VM and garbagecollection
structures and so on" FOLDED="false">
                    <edge COLOR="#f1bc70" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
            </node>
        </node>
        <node TEXT="Common misconceptions" FOLDED="false" POSITION="right">
            <edge COLOR="#7aa3e5" />
            <font NAME="Helvetica" SIZE="10" />
            <node TEXT="can’t have memory leaks in Java (you can)" FOLDED="false">
                <edge COLOR="#76a4e2" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="garbage collection is inefficient (it’s not; actually it’s far more efficient than C’s malloc() for example)" FOLDED="false">
                <edge COLOR="#78a1e4" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="can tune the HotSpot CMS collector so that it won’t
ever stop the world (you can’t)" FOLDED="false">
                <edge COLOR="#768ee2" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
        </node>
        <node TEXT="gc带来的最大问题，unpredictable pause during collection，也叫“stop the world event”" FOLDED="false" POSITION="right">
            <edge COLOR="#ebd95f" />
            <font NAME="Helvetica" SIZE="10" />
            <node TEXT="mitigate这个问题的方法有" FOLDED="false">
                <edge COLOR="#e9c854" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="breaking programs down into smaller units and distributing them" FOLDED="false">
                    <edge COLOR="#ebe953" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="object pooling" FOLDED="false">
                    <edge COLOR="#e6b54a" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="having fixedsized objects to avoid fragmentation" FOLDED="false">
                    <edge COLOR="#e7af5e" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="using off-heap storage" FOLDED="false">
                    <edge COLOR="#e8c350" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
            </node>
        </node>
        <node TEXT="**General monitoring and tuning advice**" FOLDED="false" POSITION="right">
            <edge COLOR="#7aa3e5" />
            <font NAME="Helvetica" SIZE="10" />
            <node TEXT="任何tuning都是**throughput**，**latency**和**footprint**之间的trade-off

一般来说，improve一个会影响另外两个；调优的时候先决定，对于一个程序，应该关注三者中的哪个" FOLDED="false">
                <edge COLOR="#75b1e3" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="**footprint**
gc对内存的影响" FOLDED="false">
                    <edge COLOR="#77c2e3" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="**throughput**
gc对cpu资源的影响" FOLDED="false">
                    <edge COLOR="#72aae3" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="**latency**
gc对程序的执行所造成的pause" FOLDED="false">
                    <edge COLOR="#71c0e4" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
            </node>
            <node TEXT="选哪种collector
选collector的一些“rule”" FOLDED="false">
                <edge COLOR="#7598e5" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="Tuning a collector" FOLDED="false">
                <edge COLOR="#6ea9e4" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="logging
tuning时应该打开gc的log；一般来说gc的log对应用程序没什么影响" FOLDED="false">
                    <edge COLOR="#77c1e6" />
                    <font NAME="Helvetica" SIZE="10" />
                    <node TEXT="gc log相关的jvm参数" FOLDED="false">
                        <edge COLOR="#7baee5" />
                        <font NAME="Helvetica" SIZE="10" />
                    </node>
                    <node TEXT="**理解gc log，会“读”gc log**
不同的collector的gc log可能会有不同，但是都会有下面的信息：
回收后的heap大小，回收占用的时间，回收得到的空间" FOLDED="false">
                        <edge COLOR="#79b9e5" />
                        <font NAME="Helvetica" SIZE="10" />
                        <node TEXT="Parallel collector的log" FOLDED="false">
                            <edge COLOR="#7eafe5" />
                            <font NAME="Helvetica" SIZE="10" />
                        </node>
                        <node TEXT="CMS的log" FOLDED="false">
                            <edge COLOR="#79cee6" />
                            <font NAME="Helvetica" SIZE="10" />
                        </node>
                        <node TEXT="G1的log" FOLDED="false">
                            <edge COLOR="#7ab4e5" />
                            <font NAME="Helvetica" SIZE="10" />
                        </node>
                    </node>
                    <node TEXT="分析log file的工具" FOLDED="false">
                        <edge COLOR="#7cb1e6" />
                        <font NAME="Helvetica" SIZE="10" />
                        <node TEXT="Chewiebug，for OpenJDK collectors" FOLDED="false">
                            <edge COLOR="#75b3e2" />
                            <font NAME="Helvetica" SIZE="10" />
                        </node>
                        <node TEXT="jClarity’s Censum" FOLDED="false">
                            <edge COLOR="#84a7e5" />
                            <font NAME="Helvetica" SIZE="10" />
                        </node>
                        <node TEXT="VisualVM，oracle jdk自带的" FOLDED="false">
                            <edge COLOR="#83bfe8" />
                            <font NAME="Helvetica" SIZE="10" />
                        </node>
                    </node>
                </node>
                <node TEXT="**Memory footprint vs. CPU cycles**

增加内存可以减少gc对cpu的影响（内存增了，需要gc的频率也少了，gc需要的cpu资源也少了）" FOLDED="false">
                    <edge COLOR="#67a6e4" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="Setting the size of the heap" FOLDED="false">
                    <edge COLOR="#688ce3" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="Survivor ratio" FOLDED="false">
                    <edge COLOR="#71a2e4" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
            </node>
        </node>
        <node TEXT="**Two-region collectors**
应该是指分成old和young的collector" FOLDED="false" POSITION="left">
            <edge COLOR="#e096e9" />
            <font NAME="Helvetica" SIZE="10" />
            <node TEXT="**heap的结构**
分成**“young/new”**和**tenured**两个区域
young又分成**Eden**和**survivor**；大部分对象都在Eden中分配；回收Eden时继续存活的对象放到survivor里；
Eden满了之后会发生**minor GC event**；把对象移到survivor或者tenured叫做**promotion**；移到tenured也叫**tenuring**；
两个**reserved areas**，它们的目的是To allow a degree of resizing of the pools without having to move everything" FOLDED="false">
                <edge COLOR="#d98be7" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="**PermGen**" FOLDED="false">
                <edge COLOR="#e28ce8" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="里面存着objects that it believed were effectively immortal, along with per-class metadata such as hierarchy information, method data, stack and variable sizes, the runtime constant pool, resolved symbolic reference, and Vtables." FOLDED="false">
                    <edge COLOR="#d98fea" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="java8里没有PermGen里，取而代之的是放在native memory里的**Metaspace**" FOLDED="false">
                    <edge COLOR="#e393ea" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="如果class的metadata的大小超过了PermGen，那么就会out of memory" FOLDED="false">
                    <edge COLOR="#ce8ae5" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="只要old generation或者PermGen中的任意一个满了，就会触发对它们俩的回收" FOLDED="false">
                    <edge COLOR="#e691ea" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
            </node>
            <node TEXT="**Serial collector**" FOLDED="false">
                <edge COLOR="#e095e7" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="最简单的collector；适合单处理器；内存的footprint很小；
minor collection和major collection都是单线程的
在young generation区域用的是copying collector，对old用的是mark/sweep collection algorithm；
sweep时用的是**sliding compaction**，就是把old区域的对象都移到一端，让free space集中在另一端；sweep好了之后，就可以**bump-the-pointer**了；" FOLDED="false">
                    <edge COLOR="#d295e6" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
            </node>
            <node TEXT="**Parallel collector**" FOLDED="false">
                <edge COLOR="#e692df" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="它是server-side的默认collector
monolithic, stop-the-world copying collector for the new generation
monolithic, stop-the-world mark/sweep for the old generation
它有两种，分布叫：**Parallel**和**Parallel Old**

**Parallel**会多线程地跑young-generation-collection algorithm used by the Serial collector；所以虽然STW但是影响小，一般几百ms或者更少
对old回收和Serial Collector一样

**Parallel Old**则不管old还是young都是多线程的；自Java 7u4之后默认会用“Parallel Old”；
如果你内存多，想要高throughput，有可以忍受偶尔的长pause，那么推荐这个

Parallel collector只在STW时才处理weak和soft reference

相关选项‑XX:+UseParallelOldGC和‑XX:+UseParallelGC" FOLDED="false">
                    <edge COLOR="#e596db" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
            </node>
            <node TEXT="对象是怎么分配的" FOLDED="false">
                <edge COLOR="#e996e2" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="如果对象很大，比如大数组，而且TLAB里放下这个对象，那么会在old generation区域分配
相关选项，-XX:PretenureSizeThreshold=n" FOLDED="false">
                    <edge COLOR="#eb9be1" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="**bump-the-pointer**
tracks the last object allocated to the Eden space, which is always allocated at the top.
If another object is created afterwards, it checks only that the size of that object is suitable for
the Eden space, and if it is, it will be placed at the top of the Eden space." FOLDED="false">
                    <edge COLOR="#e88de9" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="**TLAB**
thread-local allocation buffers
每个线程都有个TLAB用来创建对象；如果一个线程用完了TLAB，这个线程会从Eden里再请求一个新的" FOLDED="false">
                    <edge COLOR="#ea96e5" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
            </node>
            <node TEXT="**Concurrent Mark Sweep (CMS)**" FOLDED="false">
                <edge COLOR="#e78fe6" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="目标是reduce, or delay, the **old**-generation pauses
对young区域的回收和Parallel collector一样

程序在执行的同时，concurrent multipass marker也在跑；会有竞争，叫**concurrent marking race**；CMS用**SATB（snapshot at the beginning）**来处理这种race；marking开始的时候，记下所有的live object的snapshot；SATB用到了**pre-write barrier**，它和blind write barrier结合起来用；

“concurrent mode failure”，mark的速度没有程序修改的速度快

CMS的sweep也是并发的；sweep时用到了free list；old generation allocation会先尝试从free list分配；如果free list碎片太多，会STW来compact

promote到tenured时，也会先放到free list里；如果“promotion failure”会STW然后再promote" FOLDED="false">
                    <edge COLOR="#df88e5" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="CMS会消耗CPU资源，minor collection更expensive，需要内存更多" FOLDED="false">
                    <edge COLOR="#e487d8" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="G1是作为CMS的replacement而产生的" FOLDED="false">
                    <edge COLOR="#e68bd2" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
            </node>
        </node>
        <node TEXT="**Programming for less garbage**" FOLDED="false" POSITION="right">
            <edge COLOR="#67d7c4" />
            <font NAME="Helvetica" SIZE="10" />
            <node TEXT="各个影响因素" FOLDED="false">
                <edge COLOR="#61d8cc" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="**Number of weak or soft references**" FOLDED="false">
                    <edge COLOR="#6cd8cd" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="**Fragmentation and compaction**" FOLDED="false">
                    <edge COLOR="#68dcbd" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="**live-set size**
gc的某些操作和它的大小成正比" FOLDED="false">
                    <edge COLOR="#58d6c7" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="**heap size**" FOLDED="false">
                    <edge COLOR="#61dbcb" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="**mute rate**" FOLDED="false">
                    <edge COLOR="#57d7cd" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="**Object lifetime**" FOLDED="false">
                    <edge COLOR="#57d5bd" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
            </node>
            <node TEXT="**Reducing allocation rate**" FOLDED="false">
                <edge COLOR="#6ddacf" />
                <font NAME="Helvetica" SIZE="10" />
                <node TEXT="**String**
a+b这样的操作，会产生临时对象
用StringBuffer稍微好一点
如果程序中要大量处理string，可以考虑实现自己的string handling类
考虑用那些直接修改对象的方法，而不是返回新拷贝的方法" FOLDED="false">
                    <edge COLOR="#6cd8cb" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="**Array-capacity planning**
HashMap等内部用到了数组，为了减少数组的重分配，可以在new HashMap时指定初始大小" FOLDED="false">
                    <edge COLOR="#75d9c8" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="**Avoid creating unnecessary objects**
减少“中间对象”
用static方法直接生成最终对象
反复使用同一个对象
不要在loop里生成大量对象" FOLDED="false">
                    <edge COLOR="#6cdabd" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
                <node TEXT="**Using primitives**
回收基本类型的cost相对小一点
一些临时的基本类型对象会存在于stack上，不需要回收
如果基本类型可以表示，那么可以考虑尽量用基本类型

数组
有些类，比如HashMap，内部使用到了数组；这些数组可能会因空间不足重分配

Integer.valueOf()会对小整数做cache" FOLDED="false">
                    <edge COLOR="#6bd7b8" />
                    <font NAME="Helvetica" SIZE="10" />
                </node>
            </node>
            <node TEXT="**Weak references**" FOLDED="false">
                <edge COLOR="#66d5b2" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="**Try-with-resources**
可以通过这个机制来帮助释放资源" FOLDED="false">
                <edge COLOR="#66d5d4" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="**Distributing programs**
还提到了“rolling restarts”" FOLDED="false">
                <edge COLOR="#6cd5d9" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
            <node TEXT="**Other common techniques**
object pooling，可以重用expensive的对象
用固定大小的对象，防止碎片
using off-heap storage" FOLDED="false">
                <edge COLOR="#69d2d4" />
                <font NAME="Helvetica" SIZE="10" />
            </node>
        </node>
    </node>
</map>