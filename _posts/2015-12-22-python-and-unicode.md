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

Python官网上有篇文档，[Unicode HOWTO][1]，对怎么在Python中处理Unicode做了详细的介绍。下面是这篇文档的一个简单笔记。

## Unicode的相关概念
Unicode为世界上的每个字符都分配了一个数值，这个数值叫做`code point`。
`code point`通常以16进制表示，比如`U+12ca`，表示值为`4810`（16进制`0x12ca`）的code point。

Code point只是个整数值，而数据在计算机内部是以二进制表示的；把code point以某种方式映射成二进制数据就叫encoding。
例如一种encoding可以把每个code point表示成两个byte（虽然两个byte不能表示所有的unicode字符）。
`UTF-8`是一种常用的encoding，它是一种“变长”的encoding，不同的code point可能占用不同长度的byte。
UTF-8可以表示所有的code point。

Python支持近100种encoding，[这里][2]有详细的列表。
一些encoding可能有多个名字，比如`utf-8`，`utf_8`，`U8`，`UTF`，`utf8`都是指同一种encoding。
Python默认的encoding是`ascii`。默认情况下，如果Python发现字符串中的某些字符不能被`ascii`表示，就会抛一个`UnicodeEncodeError`异常。

## Python中的字符串
Python里有两种类型的字符串，一种是`str`类型，一种是`unicode`类型。
两者的基类都是`basestring`；所以可以通过`isinstance(value, basestring)`来判断一个value是不是字符串。

### `unicode`字符串
字符串可以理解成数组；`unicode`类型的字符串可以理解为元素为整数（code point的值）的数组。
在Python内部，`unicode`字符串的元素以16位或者32位整数来表示（取决于Python解释器是怎么编译的）。

构造函数`unicode(string[, encoding, errors])`可以用来生成`unicode`字符串。
它的所有参数都是8-bit strings。

    >>> s = unicode('abc')
    >>> type(s)
    <type 'unicode'>
    >>> unicode('abc' + chr(255))   # 如果参数是非8-bit strings，会报错
    Traceback (most recent call last):
    ...
    UnicodeDecodeError: 'ascii' codec can't decode byte 0xff in position 6:
    ordinal not in range(128)

`unichr()`可以接收一个整数（code point），生成一个长度为1的`unicode`字符串。
`ord()`则接收一个长度为1的`unicode`字符串，返回它的code point。

    >>> unichr(40960)
    u'\ua000'
    >>> ord(u'\ua000')
    40960
    
`unicode`有着和`str`类似的方法。
    
### `str`字符串
如果把`str`也视为一个数组，那么它的每个元素都是8-bit的。
（文档中有句话，“Another important method is .encode([encoding], [errors='strict']), which returns an 8-bit string version of the Unicode string”。
`type(u'abc'.encode('utf8'))`的值是`<type 'str'>`，所以可以推断出`str`是个8-bit string。）

`str`和`unicode`可以通过`.encode([encoding], [errors='strict'])`和`.decode([encoding], [errors])`函数互相转换。

    >>> u = unichr(40960) + u'abcd' + unichr(1972)   # 构造一个unicode字符串
    >>> utf8_version = u.encode('utf-8')             # unicode.encode()返回一个str对象
    >>> type(utf8_version), utf8_version
    (<type 'str'>, '\xea\x80\x80abcd\xde\xb4')       # '\xea\x80\x80abcd\xde\xb4'的每个元素都是8 bit的
    >>> u2 = utf8_version.decode('utf-8')            # str.decode()返回一个unicode对象
    >>> u == u2                                      # The two strings match
    True

## Python源文件和unicode
如果想在Python源文件中表示一个`unicode`字符串（unicode literals），可以这样，

    u'abc'              # 前面加个u
    U'abc'              # 大写的U和小写的u是等效的
    u'abc\u1234'        # unicode字符串的某个元素的code point可以通过“\u”来指定，“\u”后接4个16进制字符
    u'abc\U12345678'    # “\U”和“\u”类似，它后面接8个16进制字符
    u'abc\x12'          # “\x”后面接两个16进制字符

上面的方式比较繁琐。可以在Python源文件里声明源文件的encoding，然后就可以“自然语言”来声明unicode literals了。

    #!/usr/bin/env python
    # -*- coding: utf-8 -*-    这是Python从Emacs借鉴来的，Python实际上只去找“coding: name”或者“coding=name”，不关心“-*-”
    
    x = u'你好'        # x是长度为2的unicode对象，一个元素是“你”对应的code point，一个是“好”对应的code point
                       # 如果源文件没有指定coding，那么执行到这句代码时会报错
    
## 输入和输出
把输入转换为unicode，内部以unicode处理，再把unicode以某种encoding输出（比如写文件）。

如果输入输出时使用到了某些库，而这些库本身就支持unicode，那么开发时就不需要自己写unicode转换相关的代码。
比如一些XML parsers常常会返回unicode形式的数据；那么，这些XML parsers的用户就不用再去关心怎么把输入转成unicode了。

输出时，一般要先把unicode以某种方式encoding，然后再输出。
不推荐自己来做这种工作。Python有`codecs`库帮你做这些工作。`codecs`提供了`open()`函数，可以返回一个file-like object。
        
    import codecs
    f = codecs.open('test', encoding='utf-8', mode='w+')
    f.write(u'\u4500 blah blah blah\n')
    f.seek(0)
    print repr(f.readline()[:1])          # 一个unicode字符可能对应多个byte，用codecs可以防止读到部分byte；比如这里的“1”，会读一个unicode字符对应的数据，而不是一个byte
    f.close()

## unicode和文件名
很多操作系统都支持文件名中带有任意的unicode字符。但是不同系统采用的encoding可能不太一样。
比如OS X用UTF-8，Windows支持用户配置的encoding，Unix看`LANG`或者`LC_CTYPE`环境变量。

一般来说，在Python程序中不需要关心上面这些细节。
<!--more-->

    filename = u'filename\u4500abc'
    f = open(filename, 'w')       # open()函数会自动把filename转换为底层系统关联的encoding
    f.write('blah\n')
    f.close()

## 建议
文档里给出了两个建议。

- Software should only work with Unicode strings internally, converting to a particular encoding on output.
程序内部使用`unicode`类型。输出时再做转换（不一定要自己转，比如可以借助`codecs`）。
- Include characters > 127 and, even better, characters > 255 in your test data.
测试的时候，使用unicode字符（大于255的code point）。
    
## 其它
Unicode规范还包括一个database，里面有每个code point相关的信息，比如name，category等。

    import unicodedata
    
    u = unichr(233) + unichr(0x0bf2) + unichr(3972) + unichr(6000) + unichr(13231)
    for i, c in enumerate(u):
        print i, '%04x' % ord(c), unicodedata.category(c),
        print unicodedata.name(c)

Encode后的字符串可能会面目全非，比如，

    def read_file (filename, encoding):
        if '/' in filename:
            raise ValueError("'/' not allowed in filenames")
        unicode_name = filename.decode(encoding)
        f = open(unicode_name, 'r')
        # ... return contents of file ...
        
这段代码的功能是检测'/'字符。例如，如果filename参数是'/etc/passwd'时，就会报错。
但是如果filename是经过`base64`编码的，那么'/etc/passwd'会被encode成'L2V0Yy9wYXNzd2Q='，上面这段代码就会失效。

<br/>
*根据[这篇文章][3]的观点，Python 2的`str/unicode`存在的问题是设计Python 3的重要原因。*

[1]: https://docs.python.org/2/howto/unicode.html "Unicode HOWTO"
[2]: https://docs.python.org/2/library/codecs.html#standard-encodings "7.8.3. Standard Encodings"
[3]: http://www.snarky.ca/why-python-3-exists "Why Python 3 exists"

