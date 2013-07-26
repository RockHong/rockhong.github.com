---
# MUST HAVE BEG
layout: post
disqus_identifier: 20130707-github-pages-fails-to-update # DON'T CHANGE THE VALUE ONCE SET
title: github pages不能自动更新
# MUST HAVE END

subtitle:
tags: 
- jekyll
date: 2013-07-07 11:51:00
image:
image_desc:
---
昨天往github pages的repository里提交了一篇文章后，却发现github pages的页面一直没有更新——看不到新提交的文章。网上搜了一些资料，最后解决了这个问题。

一般来说，如果你的github pages repository有新的提交，github的服务器就会运行jekyll编译你的repository（延时很小）。如果编译出错，那么你的github pages页面是不会更新的；同时，github也会给你发一封提醒邮件，大致内容如下，
>The page build failed with the following error:     
>page build failed

给出的错误信息很有限，仅仅通知你编译出错。

要找到出错的原因，首先确认下github pages服务没有down掉；查看这个网址，[https://status.github.com/]()，可以了解服务器的运行状态。如果服务器运行良好，那么极有可能是因为提交的内容导致jekyll编译错误。    

如果服务器一切正常，那么在本地用jekyll编译一下repository，看看是否有错误。首先，更新一下本地的jekyll。github可能使用了较新版本的jekyll，所以即使你使用以前的本地jekyll编译没有问题，远端的jekyll编译时也可能出错。（当然，最好是保证本地和远端的jekyll版本一样。但是，还没有发现查看远端jekyll版本的方法。）
   
	$ sudo gem install jekyll
	$ jekyll --version
然后，在本地编译你的repository。

	$ jekyll build --safe
jekyll给出的出错信息还是很详细的，能看出在什么位置发生了错误。比如，

    | Maruku tells you:
    +---------------------------------------------------------------------------
    | Invalid char for url
    | ---------------------------------------------------------------------------
    | 结构如下所示，  N![ELF layout]("../images/blog/217px-elf-layout.png"
    | --------------------------------------|-------------------------------------
    |                                       +--- Byte 206
    | Shown bytes [168 to 75] of 257:

“Maruku“应该是Markdown语法相关的错误。根据错误信息，修正相关的错误。

本地编译要没有任何错误。（有时候即使本地有错误，也可以在本地server上看到新的改动；但是远端的服务器会要求更严格。）重新提交，马上你就可以在你的github pages上看到新的提交了。

所以，在提交改动前，最好保证在本地能编译无错。同时，也要时常更新本地的jekyll版本。

参考链接：    
[https://help.github.com/articles/pages-don-t-build-unable-to-run-jekyll]()     
[http://youngsterxyf.github.io/2013/01/08/fix-github-pages-builds-failed/]()     
[http://python-china.org/topic/481]()

