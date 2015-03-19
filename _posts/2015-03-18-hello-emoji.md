---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150318-hello-emoji # DO NOT CHANGE THE VALUE ONCE SET
title: Hello Emoji, 😊😊😊
# MUST HAVE END

is_short: true
subtitle:
tags: 
- JIT
date: 2015-03-18 19:13:00
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
IE 11 on Windows 7      
Safari on OS X     
Chrome on OS X      



[1]: http://apps.timwhitlock.info/emoji/tables/unicode "Emoji Unicode Tables"
[2]: https://msdn.microsoft.com/en-us/library/windows/apps/jj841126.aspx "Segoe UI Symbol"
[3]: https://developer.mozilla.org/en-US/docs/Web/CSS/font-family "font-family"
[5]: http://www.w3schools.com/cssref/pr_font_font-family.asp "font-family"
