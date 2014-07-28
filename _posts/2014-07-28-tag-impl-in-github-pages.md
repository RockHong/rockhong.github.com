---
# MUST HAVE BEG
layout: post
disqus_identifier: 20140728-tag-impl-in-github-pages # DON'T CHANGE THE VALUE ONCE SET
title: 给Jekyll搭建的静态博客增加标签系统
# MUST HAVE END

subtitle:
tags: 
- jekyll
- Github Pages
date: 2014-07-28 12:12:00
image:
image_desc:
---

自己的博客是在[Github Pages][1]上搭建的，Github Pages使用[Jekyll][2]作为其背后的“引擎”。
因为Jekyll没有提供一个现成的“标签（tag）系统”，所以自己完成了一个简单的实现。最终效果见[这里][3]。

实现“标签”后的目录结构如下，

    root_dir
    ├── ...
    ├── _config.yml
    ├── favicon.ico
    ├── css
    ├── script
    ├── images
    ├── _drafts
    ├── _layouts
    ├── _posts
    │   ├── 2014-07-28-tag-impl-in-github-pages.md
    │   └── ...
    ├── tags.html
    ├── index.html
    └── about.html

下面简述一下实现的大致流程。

首先，在文章（比如_posts/2014-07-28-tag-impl-in-github-pages.md）的“YAML头”中增加“标签”信息。

    ---
    # others ...
    tags: 
    - jekyll
    - Github Pages
    ---

在根目录下，增加一个HTML文件，tags.html。在其中，将所有文章按照标签归类。

    {% for t in site.tags %}
      <h3>{{ t[0] }}  </h3> <!-- 输出标签 -->
        <ul>
          {% assign tag = t[0] %}
          {% for post in site.tags[tag] %} <!-- site.tags.TAG里有含TAG标签的所有文章 -->
            <li>
              <a href="{{ post.url }}">{{ post.title }}</a> <!-- 输出文章的URL和标题 -->
            </li>  
          {% endfor %}
        </ul>
    {% endfor %}

Jekyll解析文章的YAML头后会把标签信息放在一个[Jekyll变量][4]中，`site.tags`。Jekyll支持Liquid模板
语言。利用Liquid的[Tag markup][5]处理`site.tags`，生成按标签分类的文章列表。

另外，也可以按年月输出文章列表。

    {% assign prev_ym = '' %}
    {% for post in site.posts %} <!-- Jekyll文档上说site.posts变量是一个按时间逆序排列的列表 -->
      {% assign ym = post.date | date: "%Y %m" %}
      {% if prev_ym != ym %}
        {% if prev_ym == '' %}
          <ul>                   <!-- 加第一个ul -->
        {% endif %}
        
        {% assign prev_ym = ym %}
        </ul>                    <!-- 关闭上一个ul -->
        <h3>{{prev_ym}} </h3>
        <ul>                     <!-- 开始新的ul -->
      {% endif %}
      <li><span>{{post.date | date: "%F %R"}}  </span><a href="{{ post.url }}">{{ post.title }}</a></li>
    {% endfor %}
    </ul>                        <!-- 关闭最后一个ul-->


[1]: https://pages.github.com/ "Github Pages"     
[2]: http://jekyllrb.com/ "Jekyll"     
[3]: http://rockhong.github.io/tags.html "All Tags in Hong's Blog"       
[4]: http://jekyllrb.com/docs/variables/ "Jekyll Variables"       
[5]: https://github.com/shopify/liquid/wiki/liquid-for-designers "Liquid"     
