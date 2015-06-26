---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150626-connect-java-and-cpp-using-jni # DO NOT CHANGE THE VALUE ONCE SET
title: Java JNI简介
# MUST HAVE END

is_short: true
subtitle: Connect Java and C++ Using JNI
tags: 
- java
date: 2015-06-26 13:24:00
image: 
image_desc: 
---

*整理电脑时发现之前写的一篇关于JNI的文档，放在以供参考。*

Our (old) product uses JNI(Java Native Interface) to call C++ code from Java side.

### JNI Basic
Using JNI, you only declare a method in Java, while implement that method in C++
Code. Follow below steps, so that when you invoke that Java method, Java/JVM will
help invoke corresponding C++ implementation.

1. Declare method to be `native` in java     
     
{% highlight java %}
public class ProxyService {
    // ...
    public native void execute(long cmdCode);
    //...
}
{% endhighlight %}

2. Generate header files for C++      
Java provides command to help generate header files.

    $ javac com/abc/def/ghi/jkl/xyzserver/*.java # compile first  
    $ javah -jni com.abc.def.ghi.jkl.xyzserver.ProxyService 

It generates a header file called
`com\_abc\_def\_ghi\_jkl\_xyzserver\_ProxyService.h`. You can find below lines there,

{% highlight cpp %}
JNIEXPORT void JNICALL Java_com_abc_def_ghi_jkl_xyzserver_ProxyService_execute
  (JNIEnv *, jobject, jlong);
{% endhighlight %}

3. Implement that C++ function

{% highlight cpp %}
JNIEXPORT void JNICALL Java_com_abc_def_ghi_jkl_xyzserver_ProxyService_execute
    (JNIEnv * env, jobject instance, jlong commandCode)
{
    // C++ code for your "native" java method
}
{% endhighlight %}

The above is a very simple example of JNI. Usually, you already have an existing C++ class,
and just want to "wrap" the C++ class into a Java class. To do this, let Java object have a
member of `long` type, which holds the address of a C++ object of your C++ class.

{% highlight java %}
public class ProxyService {
    long nativeInstanceAddr;
    public native void newCppObj();
    public native void delCppObj();
    public native void execute(long cmdCode);
}
{% endhighlight %}

In C++ code,

{% highlight cpp %}
JNIEXPORT void JNICALL Java_com_abc_def_ghi_jkl_xyzserver_ProxyService_newCppObj
    (JNIEnv * env, jobject instance)
{
    jclass c = env->getobjectclass(obj);
    jfieldid jfid = env->getfieldid(c, "nativeInstanceAddr", "j");
    jlong naddr = env->getlongfield(obj, jfid);
    naddr = // new some c++ object
}

JNIEXPORT void JNICALL Java_com_abc_def_ghi_jkl_xyzserver_ProxyService_delCppObj
    (JNIEnv * env, jobject instance)
{
    jlong naddr = // get the value of nativeInstanceAddr field like in newCppObj()
    delete (SomeCPPClass *)naddr;
}

JNIEXPORT void JNICALL Java_com_abc_def_ghi_jkl_xyzserver_ProxyService_execute
    (JNIEnv * env, jobject instance, jlong commandCode)
{
    jlong naddr = // get the value of nativeInstanceAddr field like in newCppObj()
    (SomeCPPClass *)naddr->execute(commandCode);
}
{% endhighlight %}

4. Load C++ library in Java     

{% highlight java %}
public class DLLLoader {
    public synchronized static void loadDll() {
                //...
                System.loadLibrary(libName);
    }
}
{% endhighlight %}

### When to Release C++ Object
Java objects are taken care by JVM. However, for the C++ objects which are created via JNI,
the JVM doesn't manage (garbage-collect) them automatically (them live in their "own heap").
You have to delete C++ objects manually.

For example, C++ objects can be released when a transaction is committed or rolled back,
or when a HTTP request finishes.

{% highlight java %}
public void commit() {
    try
    {
        //...
    }
    catch(Exception e)
    {
        //...
    }
    finally
    {
        // delete c++ objects here
        // for example, call ProxyService::delCppObj() here
    }
}
{% endhighlight %}

<!-- 

consider creating a base class for 'native java class'
	public abstract class NativeClass implements Releaseable {
		long cppObjAddr;
		//...
	}

	public interface Releaseable {
		public void release();
		public boolean isReleased(); 
        //...
	}

consider creating macros in c++ code
you may find yourself write too many following code
			jclass c = env->getobjectclass(obj);
			jfieldid jfid = env->getfieldid(c, "nativeInstanceAddr", "j");
			jlong naddr = env->getlongfield(obj, jfid);
you can consider create some macros for this kind of code. macro is a little
efficient than function

-->
 