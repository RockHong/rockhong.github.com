---
# MUST HAVE BEG
layout: post
disqus_identifier: 20160202-wake-up-not-responding-process # DO NOT CHANGE THE VALUE ONCE SET
title: 唤醒“未响应”的进程 
# MUST HAVE END

is_short: true
subtitle: Wake Up Not Responding Processes on OS X
tags: 
- OS X
date: 2016-02-02 10:36:00
image: 
image_desc: 
---

Safari的一个页面在占用了10多G的内存后，使得OS X系统内存耗尽，包括Safari在内很多程序卡死，变成了“未响应”的进程。
简单地在“活动监视器”里强制退出“未响应”的进程，有可能导致这些进程的数据丢失，比如Safari正在打开的页面，TextWrangle未保存的文本等。
尝试了一些方法，比如干等😅、睡眠/唤醒、关闭其它程序释放内存等，都不管用。

最后发现了一个方法，可以唤醒“未响应”的Safari进程。打开“终端”程序，在“终端”里新开一个Safari程序：

    $ open -n /Applications/Safari.app/

在这个新开的Safari程序里可以正常访问之前的那个Safari程序打开的所有页面。
通过这种方法唤醒所有“未响应”的进程，保存好你的工作，然后可以在合适的时间尝试重新启动一下电脑😊。

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/safari-not-responding.png" alt="safari not responding" style="max-width:420px;">
</div>

After a web page in a Safari tab eat up all memory of my OS X, the whole Safari program,
along with other programs like TextWrangle, became an "not responding" process in Activity Monitor.
I did not want to lose all my opening web pages in Safari and unsaved text documents in TextWrangle
by simply clicking the "force quit" button in Activity Monitor.
I waited a long time for my Safari to recover, sleep and wake up my OS X system,
killed all other unimportant processes, but all of them did not work.

Fortunately, I found a way at last. Open the Terminal application, and open a new Safari process in the Terminal:

    $ open -n /Applications/Safari.app/
    
And in the new opened Safari, all web pages of previous not responding Safari came to alive again.
By this way, wake up all "not responding" processes, save your working in those processes,
and try to restart your Mac in your very proper time.
    







