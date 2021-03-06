---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150814-space-between-inline-blocks # DO NOT CHANGE THE VALUE ONCE SET
title: Space Between inline-block Elements
# MUST HAVE END

is_short: true
subtitle:
tags: 
- css
date: 2015-08-14 18:00:00
image: 
image_desc: 
---

Share a weird css issue I met today, that isthere are always some space between `inline-block`
div elements of a line. For these div elements, `margin` are confirmed to be `0`. See how it looks in
the top part of below snapshot.

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/space-btw-inline-block.png" alt="space between">
</div>

And below is corresponding code snippet,

{% highlight html %}
<div style="border:red 1px solid;">
    <div style="width: 100px;display:inline-block; border:green 1px solid;">div 1</div>
    <div style="width: 150px;display:inline-block; border:green 1px solid;">div 2</div>
    <div style="width: 100px;display:inline-block; border:green 1px solid;">div 3</div>
</div>
{% endhighlight %}

After some time on googling, the root cause was located; It's the  whitespace between `inline-block` div elements. In the above code, whitespace
is `newline` character.

Two solutions can be used to fix this issue. One is eliminating whitespace, like

{% highlight html %}
<div style="border:red 1px solid;">
    <div style="width: 100px;display:inline-block; border:green 1px solid;">div 1
    </div><div style="width: 150px;display:inline-block; border:green 1px solid;">div 2
    </div><!-- no space here --><div style="width: 100px;display:inline-block; border:green 1px solid;">div 3
</div></div>
{% endhighlight %}

The other is to use `display:table-cell;`, which may be better than former method, since it does
not hurt your beautiful format.

{% highlight html %}
<div style="border:red 1px solid;">
    <div style="width: 100px;display:table-cell; border:green 1px solid;">div 1</div>
    <div style="width: 150px;display:table-cell; border:green 1px solid;">div 2</div>
    <div style="width: 100px;display:table-cell; border:green 1px solid;">div 3</div>
</div>
{% endhighlight %}

Reference [here][2]. Code for above snapshot [here][1].

[1]: https://gist.github.com/RockHong/98c7ffdf8fdc25cddc27 "code"
[2]: https://css-tricks.com/fighting-the-space-between-inline-block-elements/ "space between inline block"
