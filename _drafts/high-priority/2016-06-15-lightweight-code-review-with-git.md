---
# MUST HAVE BEG
layout: post
disqus_identifier: 20160615-lightweight-code-review-with-git # DO NOT CHANGE THE VALUE ONCE SET
title: 
# MUST HAVE END

is_short: true
tags: 
- git
date: 2016-06-15 08:36:00
image: 
image_desc: 
---

介绍一种git环境下的“轻量级”的code review方法。简单的步骤如下：

- Reviewee把代码改动输出到一个文件里。
- 把上一步生成的文件发给reviewer。
- Reviewer进行code review。


### Reviewee
如果reviewee已经把代码改动提交到本地仓库，假设commit的SHA-1是`e3fbbbcfd`（如果commit是最新的提交，那么`e3fbbbcfd`可以用`HEAD`替代），

{% highlight bash %}
$ git show e3fbbbcfd --color > change-to-review
{% endhighlight %}

假设代码改动还没有提交，

{% highlight bash %}
$ git diff --color -- path/to/file1 path/to/file2 > change-to-review
{% endhighlight %}

`--color`选项会用颜色高亮代码改动。

Reviewee通过邮件或者聊天工具等方式把`change-to-review`文件发给reviewer。

### Reviewer
Reviewer检查代码改动，

{% highlight bash %}
$ cat change-to-review | less -R
{% endhighlight %}

`-R`选项使less可以显示颜色。

TODO图片

还可以用[diff-highlight][1]来进一步高亮代码改动，方便code review。
下载diff-highlight脚本，放到

[1]: https://github.com/git/git/tree/master/contrib/diff-highlight "diff-highlight"






Gerrit 
 


环境
SHA-1


$ cat aaa | diff-highlight  | less -R

{% highlight bash %}
$ git show head --color > zzz
{% endhighlight %}




[1]: http://expressjs.com/ "Express"
[2]: https://docs.npmjs.com/files/package.json "Specifics of npm's package.json handling"
[3]: http://expressjs.com/en/starter/static-files.html "Serving static files in Express"
[5]: https://stormpath.com/blog/build-nodejs-express-stormpath-app "A Simple Web App With Node.js, Express, Bootstrap & Stormpath"



