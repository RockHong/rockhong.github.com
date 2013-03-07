---
layout: post
title: hello ....
tag: xxx or tags?
image: none
abstract: a b c d
---

todo

make notes..

http://www.barelyfitz.com/screencast/html-training/css/positioning/
这个链接里有10个例子，有助于理解

http://wickham43.net/divboxes.php
一个不错的文章

https://developer.mozilla.org/en-US/docs/CSS/Getting_Started/Layout
一个简单介绍

https://developer.mozilla.org/en-US/docs/CSS/block_formatting_context
A block formatting context is created by one of the following:
** the root element or something that contains it
3 floats (elements where float is not none)
4 absolutely positioned elements (elements where position is absolute or fixed)
5 inline-blocks (elements with display: inline-block)
6 table cells (elements with display: table-cell, which is the default for HTML table cells)
7 table captions (elements with display: table-caption, which is the default for HTML table captions)
8 elements where overflow has a value other than visible
9 flex boxes (elements with display: flex or inline-flex)
什么时候会产生一个block formatting context？
可以看到当一个element的overflow值不是visible时，会产生出一个block formatting context，这个block formatting context会用来包含/render这个element
所以overflow有时候会有float的效果。
见链接，https://developer.mozilla.org/en-US/docs/CSS/float
However, this method only works if there are no other elements within the same block formatting context that we do want the heading to continue to appear next to horizontally. If our H2 has siblings which are a sidebars floated to the left and right, using clear will force it to appear below both sidebars, which is probably not what we want.讲了什么时候clear不好用。如果使用clear的element有处于float状态的兄弟，那么用clear是对自己的兄弟的。
If clearing floats on an element below them is not an option, another approach is to limit the block formatting context of the floats' container. Referring to the example above again, it appears that all three red boxes are within a P element. We can set the overflow property on that P to hidden or auto to cause it to expand to contain them, but not allow them to drop out the bottom of it:当clear不好用时，可以用overflow产生一个block formatting context，让之外的东西“进不来”，达到clear的效果。



todo overflow and layout
