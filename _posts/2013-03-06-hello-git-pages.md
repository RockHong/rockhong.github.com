---
layout: post
title: "Hello World" from a Blog Site Powered by Jekyll and Github
tags:
    - todo todo
image: none
abstract: a b c d
---

草稿
稍微说一下历史
1 建立博客的方式
2 github pages的优点，专注于写，主机
3 用到的技术： git，yaml，liquid，markdown，静态的
4 简单步骤，简单解析
5 后续阅读，参考site，blogging like a hacker

---
"Hello World" from a Blog Site Powered by Jekyll and Github
利用Jekyll和Github搭建个人博客站点

搭建博客站点有很多种方式，比如WordPress框架、Django框架。只是WordPress需要懂PHP语言，Django需要知晓Python语言；之外，应该还需要了解一些数据库的知识。相比而言，使用Jekyll https://github.com/mojombo/jekyll 和Github https://github.com/ 搭建博客站点会显得简单一点。Jekyll是一个静态站点生成器（static site generator），换言之，不使用数据库；Github则是互联网上代码/内容托管服务器。Github公司利用Jekyll将我们站点的“原始（raw）内容”成一个标准的静态站点，放在Github的主机上让我们的读者访问。Github将这种服务称为Github Pages http://pages.github.com/

Jekyll+Github（Github Pages）的优点，一言以蔽之，就是简单（Simple）。我们不必为搭建一个站点去学习一门语言（比如PHP或者Python），去学习数据库知识，去寻找合适的主机。搭建好站点后（搭建的过程不会很复杂），我们只需要专注于写作就可以。

Jekyll和Github有用到下面所列的技术：
git，流行的版本控制软件。在这里只是简单地将它当成一种内容上传工具——将你本地电脑的站点内容通过git上传到Github主机上。这里，可以简单把git当成一个类FTP的工具。
YAML，可以用来表达列表（list）、哈希表（key value table）等数据的一种文本格式。通过给站点中的某个文件（比如某篇文章）加上“YAML头“，让Jekyll知道这个文件的某些信息。比如，在一篇博客的头部加上如下的“YAML头”
---
layout: post
title: stashing your changes
category: beginner
---
Jekyll在解析这个文件后，会知道这个文件分类（category）是“beginner”；这些信息后续可以给Liquid使用。

Liquid，https://github.com/Shopify/liquid/wiki 一个模版引擎（Ruby库），可用于生成HTML内容。比如，
  <ul class="posts">
    {% for post in site.posts %}
      <li>{{ post.title }}</li>
    {% endfor %}
  </ul>
可以将站点中所有文章的标题以HTML的列表方式呈现出来。
Markdown，http://zh.wikipedia.org/wiki/Markdown 一种轻量级标记语言，它允许人们“使用易读易写的纯文本格式编写文档，然后转换成有效的XHTML(或者HTML)文档”。在建立好博客站点后，我们不必以HTML格式来书写我们的文章，以更简洁直观的Markdown格式来轻松地写作就可以了。Github会自动地帮你把Markdown格式的文章转化成HTML格式。一个Markdown的简单教程 http://wowubuntu.com/markdown/ 在Mac OSX下可以使用免费Mou软件作为编辑器。
注：Github也支持另一种轻量级标记语言，Textile。

下面列出建立博客站点所需的步骤，
成为Github网站的用户
建立一个名为“username.github.com”的内容库（repo），将username替换成你的Github用户名 https://help.github.com/articles/user-organization-and-project-pages
在本地的内容库建立如下的目录结构，https://github.com/mojombo/jekyll/wiki/usage
.
|-- _config.yml
|-- _includes
|-- _layouts
|   |-- default.html
|   `-- post.html
|-- _posts
|   |-- 2007-10-29-why-every-programmer-should-play-nethack.md
|   `-- 2009-04-26-barcamp-boston-4-roundup.md
|-- _site
|-- css
|-- images
`-- index.html
_layouts目录下放置着HTML模版，_posts目录是我们的文章，index.html是博客站点的主页；其他目录，比如css，images可以用来放置样式表和图片，这些目录不是必需的。
在本地建立并且测试好站点后，将本地的内容库推送（push）到Github上后，我们的博客站点就发布/更新成功了。
通过http://my-github-username.github.com/就可以访问我们的博客站点了。

Github的创始人兼Jekyll的作者有一篇介绍Jekyll的博客，“Blogging Like a Hacker”，http://tom.preston-werner.com/2008/11/17/blogging-like-a-hacker.html 可以参考阅读。另外Jekyll的工程页面上也列出了很多以Jekyll为引擎的博客站点，以及这些站点的源代码链接，可以提供很好的参考 https://github.com/mojombo/jekyll/wiki/sites 当然，也可以参考我的站点;-)

DON'T BE PANIC.


