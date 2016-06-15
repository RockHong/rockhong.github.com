---
# MUST HAVE BEG
layout: post
disqus_identifier: 20160615-lightweight-code-review-with-git # DO NOT CHANGE THE VALUE ONCE SET
title: Lightweight "Code Review" with Git
# MUST HAVE END

is_short: true
tags: 
- git
date: 2016-06-15 08:36:00
image: 
image_desc: 
---

介绍一种git环境下的“轻量级”的“code review”方法。
“code review”加上引号是因为它只能算“查看代码改动”的一种方式。
如果由于某些原因导致像Gerrit这样的专业code review工具不能用时，可以考虑一下它。

简单的步骤如下：

- Reviewee把代码改动输出到一个文件里。
- 把上一步生成的文件发给reviewer。
- Reviewer进行code review。

### Reviewee
如果reviewee已经把代码改动提交到本地仓库，
假设commit的SHA-1是`e3fbbbcfd`（如果commit是最新的提交，那么`e3fbbbcfd`也可以用`HEAD`替代），

{% highlight bash %}
$ git show e3fbbbcfd --color > change-to-review
{% endhighlight %}

假设代码改动还没有提交，

{% highlight bash %}
$ git diff --color -- path/to/file-to-review-1 path/to/file-to-review-2 > change-to-review
{% endhighlight %}

`--color`选项会用颜色高亮代码的改动。

Reviewee通过邮件或者聊天工具等方式把`change-to-review`文件发给reviewer。

### Reviewer
Reviewer检查代码改动，

{% highlight bash %}
$ cat change-to-review | less -R
{% endhighlight %}

`-R`选项使less可以显示颜色。

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/git-code-review-1.png" alt="less -R" style="max-width:480px;">
</div>

还可以用[diff-highlight][1]来进一步高亮代码改动，方便review代码。
下载diff-highlight脚本，放到系统的`PATH`目录下。然后运行如下命令，

{% highlight bash %}
$ cat change-to-review | diff-highlight | less -R
{% endhighlight %}

效果如图，

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/git-code-review-2.png" alt="diff-highlight" style="max-width:480px;">
</div>






[1]: https://github.com/git/git/tree/master/contrib/diff-highlight "diff-highlight"






 
 

