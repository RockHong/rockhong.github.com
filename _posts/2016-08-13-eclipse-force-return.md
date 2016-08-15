---
# MUST HAVE BEG
layout: post
disqus_identifier: 20160813-eclipse-force-return # DO NOT CHANGE THE VALUE ONCE SET
title: Eclipse中的Force Return
# MUST HAVE END

is_short: false      # <!--more-->
subtitle:
tags: 
- eclipse
- java
date: 2016-08-13 19:36:00
image: 
image_desc: 
---

Eclipse在debug Java代码时，可以提前从当前方法中返回。
提前返回使得在debug时可以跳过某些代码的执行，或者强迫当前方法返回某个指定值。

如果要从void方法中提前返回，只需要鼠标右键弹出菜单，然后点击`Force Return`就可以，

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/force-return-void.png" alt="force return from void method" style="max-width:267px;">
</div>

如果要让当前方法返回某个指定值，则先打开“Display View”，输入并选中返回值，然后鼠标右键弹出菜单，点击`Force Return`，

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/force-return-value.png" alt="force return a specified value" style="max-width:420px;">
</div>


另外，在debug web程序时，某些时候可能想要中止当前正在debugging的request，这时可以直接通过“Display View”抛出
一个异常来中止当前request。通过这种方式，可以避免继续执行当前request给server带来的副作用。

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/throw-exception.png" alt="throw an exception" style="max-width:484px;">
</div>

[参考文档][1]

[1]: http://help.eclipse.org/neon/index.jsp?topic=%2Forg.eclipse.jdt.doc.user%2Freference%2Fviews%2Fshared%2Fref-forcereturn.htm "Eclipse force return"











