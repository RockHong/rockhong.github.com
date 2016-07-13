---
# MUST HAVE BEG
layout: post
disqus_identifier: 20160713-where-is-netease-cloud-music-cache # DO NOT CHANGE THE VALUE ONCE SET
title: 网易云音乐的缓存路径
# MUST HAVE END

is_short: true      # <!--more-->
subtitle:
tags: 
- command line
date: 2016-07-13 19:36:00
image: 
image_desc: 
---

苹果系统上的网易云音乐在播放时默认会缓存歌曲。通过下面的方法可以找到缓存的路径。

打开网易云音乐，随便播放一首没有听过的歌曲。然后运行下面的命令，

{% highlight bash %}
>lsof | grep -e "[[:digit:]]\+w" | grep -i netease
NeteaseMu   866 hong   22w     REG                1,4       1198 3911953 /Users/hong/Library/Saved Application State/com.netease.163music.savedState/windows.plist
NeteaseMu   866 hong   34w     REG                1,4    4788183 4437551 /Users/hong/Library/Containers/com.netease.163music/Data/Caches/online_play_cache/186001-_-_128-_-_d08add8397181cefb1014a7b09ee4a92.uc!
{% endhighlight %}

`186001-_-_128-_-_d08add8397181cefb1014a7b09ee4a92.uc!`就是网易云音乐缓存的歌曲。
`/Users/hong/Library/Containers/com.netease.163music/Data/Caches/online_play_cache/`就是缓存歌曲的目录。
把后缀从`.uc!`改成`.mp3`就可以通过iTunes等播放了。

注：网易云音乐的版本是Mac版1.4.4 (470)。
