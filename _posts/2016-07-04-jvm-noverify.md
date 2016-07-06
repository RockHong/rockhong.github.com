---
# MUST HAVE BEG
layout: post
disqus_identifier: 20160704-jvm-noverify # DO NOT CHANGE THE VALUE ONCE SET
title: JVM的noverify选项
# MUST HAVE END

is_short: true
tags: 
- java
date: 2016-07-04 08:36:00
image: 
image_desc: 
---                    

最近在CI上运行测试代码的时候遇到一个`java.lang.VerifyError`错误。

    Tests run: 1, Failures: 0, Errors: 1, Skipped: 0, Time elapsed: 0.129 sec <<< FAILURE! - in com.example.CustomerTest
    runTest(com.example.CustomerTest)  Time elapsed: 0.009 sec  <<< ERROR!
    java.lang.VerifyError: (class: au/com/dius/pact/consumer/PactProviderRule, method: findPactVerification, signature: (Lau/com/dius/pact/consumer/PactVerifications;)Ljava/util/Optional;, offset: 12) Illegal type 262144 in constant pool
	    at com.example.CustomerTest.<init>(CustomerTest.java:32)
	
JVM加载class文件时会做字节码校验（bytecode verification）。这篇[文档][1]非常详细地讲了JVM会做哪些校验。
如果你的class文件是由java源文件通过javac编译出来的，那么基本上不用担心bytecode verification。
如果class文件是由asm、cglib等动态生成出来的或者由其它编译器生成的，那么JVM在校验它的bytecode时就有可能失败。
失败的原因可能是你生成的bytecode有bug，也可能是由于新版本的JVM加入了[新的验证条件][2]后导致原来可以通过验证的bytecode现在不能通过了。

很多Java框架都会动态生成class文件，再加上JVM版本也会时不时地修改它的bytecode verification行为。
所以，运行代码时偶尔会遇到`java.lang.VerifyError`错误。
在不能修改框架代码或者切换JVM实现的情况下，JVM提供了一些选项可以让你改变或者绕过bytecode verification。

### -XX:-UseSplitVerifier
`-XX:-UseSplitVerifier`可以让JVM不开启“type-checking verifier”。
这样就不强制要求class文件含有StackMapTable（所有Java 7 version 51之后的class文件默认要求含有StackMapTable）。

### -noverify
`-noverify`选项可以关闭bytecode verification。

[有的观点][6]认为某些bytecode verification除了给动态生成bytecode增加麻烦之外，并没有什么大用。
但是这篇[文章][8]强烈建议不要关闭bytecode verification，特别是在生产环境里。
因为bytecode verification可以检测到恶意代码或者代码中的bug。
特别是代码中的bug，因为没有人可以保证（动态产生的）字节码是百分百bug free的。

回到我的问题，由于`PactProviderRule`类来自于外部依赖，CI上的JVM也不能替换
（CI上用的是非oracle的JVM实现，该测试代码在本地的官方JVM上是可以运行通过，所以CI上的失败有一定可能是其用的JVM实现的原因），
所以一个简单的方法是在maven跑测试代码时，给JVM加上`-noverify`选项。

{% highlight xml %}
  <plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <configuration>
      <argLine>-noverify</argLine>
    </configuration>
  </plugin>
{% endhighlight %}
  

更多的参考文档：

- [Java SE 7 and JDK 7 Compatibility][5]


[1]: https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html#jvms-4.10 "bytecode verification"
[2]: http://blog.takipi.com/oracles-latest-java-8-update-broke-your-tools-how-did-it-happen/ "Latest Java 8 Update Broke Your Tools"
[3]: http://stackoverflow.com/a/16467026/1080041 "-XX:-UseSplitVerifier"
[5]: http://www.oracle.com/technetwork/java/javase/compatibility-417013.html "Java SE 7 and JDK 7 Compatibility"
[6]: http://chrononsystems.com/blog/java-7-design-flaw-leads-to-huge-backward-step-for-the-jvm "Java 7 Bytecode Verifier: Huge backward step for the JVM"
[8]: https://blogs.oracle.com/buck/entry/never_disable_bytecode_verification_in "Never Disable Bytecode Verification in a Production System"

<!-- 
http://stackoverflow.com/questions/13489388/how-does-junit-rule-work
rule 会有aop，会动态生成类   ?

+ mvn -X -pl app/xxx-test clean test -Dmaven.repo.local=.m2
Apache Maven 3.3.9 (bb52d8502b132ec0a5a3f4c09453c07478323dc5; 2015-11-10T16:41:47+00:00)
Maven home: /opt/maven
Java version: 1.8.0_77, vendor: SAP AG
Java home: /opt/sapjvm_8/jre

http://maven.apache.org/surefire/maven-surefire-plugin/test-mojo.html
argLine


http://stackoverflow.com/questions/300639/use-of-noverify-when-launching-java-apps
   kankan
   
http://blog.takipi.com/oracles-latest-java-8-update-broke-your-tools-how-did-it-happen/
  kankan
  
http://stackoverflow.com/questions/15253173/how-safe-is-it-to-use-xx-usesplitverifier


http://stackoverflow.com/questions/100107/reasons-of-getting-a-java-lang-verifyerror

-->


