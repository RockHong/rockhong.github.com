---
# MUST HAVE BEG
layout: post
disqus_identifier: 20151228-cannot-open-itunes-on-win7 # DO NOT CHANGE THE VALUE ONCE SET
title: Windows 7上不能打开iTunes的问题 
# MUST HAVE END

is_short: true
subtitle:
tags: 
- apple
date: 2015-12-28 10:36:00
image: 
image_desc: 
---

Windows 7上的iTunes突然不能打开了。双击运行iTunes没有任何反应。
虽然任务管理器中显示有`iTunes.exe`和`iTunesHelper.exe`进程，但是桌面上却没有显示iTunes窗口。
反复地卸载、重装iTunes都不能解决问题。

Google了一番，在苹果官方论坛的[一个帖子][1]上找到了解决方法，

- 打开“任务管理器（Task Manager）”。
- 去“进程（Processes）”标签页，找到`APSDaemon.exe`进程，然后点击“结束进程（End Prosses）”按钮。
- 关闭“任务管理器（Task Manager）”。

如果上面的步骤能解决问题，那么再修改一下Windows的启动项，防止下次启动时问题重现，

- 打开“开始”菜单，输入`MSCONFIG`，回车。
- 打开“启动（StartUp）”标签页，取消勾选`Apple Push`，再点击“Ok”按钮。



[1]: https://discussions.apple.com/thread/4006028?tstart=0 "iTunes won't open on my Windows 7 PC."

