---
# MUST HAVE BEG
layout: post
disqus_identifier: 20151222-unicode-and-python # DO NOT CHANGE THE VALUE ONCE SET
title: Python and Unicode
# MUST HAVE END

is_short: false
subtitle:
tags: 
- python
date: 2015-12-22 15:36:00
image: 
image_desc: 
---


<!--more-->



http://calvin1978.blogcn.com/articles/murmur.html
看Jedis的主键分区哈希时，看到了名字很萌很陌陌的MurmurHash，谷歌一看才发现Redis，Memcached，Cassandra，HBase，Lucene都用它。
与MD5这些讲究安全性的摘要算法比，Redis们内部为主键做个Hash而已，就不需要安全性了，因此Google家的MurmurHash这种non-cryptographic的速度会快几十倍。
以后要多用MurmurHash。在Java的实现，Guava的Hashing类里有，上面提到的Jedis，Cassandra里都有Util类。

Java的HashCode
那Java自己的String的hashCode()呢？ 用的是Horner法则， s[0]*31^(n-1) + s[1]*31^(n-2) + ... + s[n-1]
for (int i = 0; i < str.length(); i++) { 
hash = 31*hash + str.charAt[i]; 
}

31有个很好的特性，就是用移位和减法来代替乘法，可以得到更好的性能：31*i==(i<<5)-i。现在的VM可以自动完成这种优化。

那为什么不选简单直白的Horner法则呢？
性能，有个评测用js来跑的，还是murmur好些。

Java自己的HashMap，会在调用Key的hashCode()得到一个数值后，用以下算法再hash一次，免得Key自己实现的hashCode()质量太差。
static int hash(int h) {
h ^= (h >>> 20) ^ (h >>> 12);
return h ^ (h >>> 7) ^ (h >>> 4);
}

变化不够激烈，比如"abc"是96354， "abd"就比它多1。而用 murmur"abc"是1118836419，"abd"是413429783。

murmur的结果还能均匀的落在一致性哈希环上，用Honer法则就不行了。




http://www.oschina.net/translate/state-of-hash-functions
http://blog.reverberate.org/2012/01/state-of-hash-functions-2012.html
Hash 函数概览
非加密散列函数将字符串作为输入，通过计算输出一个整数。理想的散列函数的一个特性是输出非常均匀分布在可能的输出域，特别是当输入非常相似的时候。
加密散列函数有这个特性但是要慢的多


http://www.burtleburtle.net/bob/hash/doobs.html

https://en.wikipedia.org/wiki/MurmurHash

http://www.cs.princeton.edu/courses/archive/fall05/cos226/lectures/hash.pdf





## 一致性哈希环  Consistent hashing

## crc ，可以做hash？
http://carlosfu.iteye.com/blog/2254571
客户端的hash(key)有问题，造成分配不均。（redis使用的是crc16, 不会出现这么不均的情况）
https://en.wikipedia.org/wiki/Cyclic_redundancy_check
http://www.zlib.net/crc_v3.txt







