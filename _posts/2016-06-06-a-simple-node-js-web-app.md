---
# MUST HAVE BEG
layout: post
disqus_identifier: 20160606-a-simple-node-js-web-app # DO NOT CHANGE THE VALUE ONCE SET
title: 使用Node.js搭建一个简单的静态文件server。
# MUST HAVE END

is_short: true
tags: 
- node.js
date: 2016-06-06 12:36:00
image: 
image_desc: 
---

介绍一下如何利用Node.js搭建一个简单的静态文件server。
这里用到了[Express][1]，Express是Node.js世界的web framework。

### 新建工程

创建工程目录，

{% highlight bash %}
$ mkdir my-app
$ cd my-app
{% endhighlight %}

为自己的工程建一个`package.json`文件，

{% highlight bash %}
$ npm init
This utility will walk you through creating a package.json file.
It only covers the most common items, and tries to guess sensible defaults.

See `npm help json` for definitive documentation on these fields
and exactly what they do.

Use `npm install <pkg> --save` afterwards to install a package and
save it as a dependency in the package.json file.

Press ^C at any time to quit.
name: (my-app)
version: (1.0.0)
description:
entry point: (index.js)
test command:
git repository:
keywords:
author:
license: (ISC)
About to write to E:\tmp\my-app\package.json:

{
  "name": "my-app",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}


Is this ok? (yes)
{% endhighlight %}

`npm init`会问你一些问题，直接回车表示接受默认值。`package.json`的更多信息见[此文档][2]。

### 安装依赖

安装Express，`--save`选项会在`package.json`文件里加上对`express`的依赖。

{% highlight bash %}
$ npm install express --save
{% endhighlight %}

### 编写代码

如果在执行`npm init`时没有指定新的名字，那么程序的“main”文件就是`index.js`。编辑`index.js`文件如下，

{% highlight javascript %}
var express = require('express');
var app = express();

app.listen(3000, function() {
  console.log('i am alive on port 3000');
});

app.use(express.static(__dirname + '/public'));
{% endhighlight %}

把静态文件放到`public`目录下面。
假设`public`目录下面有个`index.html`文件，那么就可以通过`http://localhost:3000/index.html`来访问文件了。

如果想给静态文件指定URL前缀，可以这样（详见[文档][3]），

{% highlight javascript %}
app.use('/static', express.static(__dirname + '/public'));
{% endhighlight %}

现在可以通过`http://localhost:3000/static/index.html`来访问文件。



[1]: http://expressjs.com/ "Express"
[2]: https://docs.npmjs.com/files/package.json "Specifics of npm's package.json handling"
[3]: http://expressjs.com/en/starter/static-files.html "Serving static files in Express"
[5]: https://stormpath.com/blog/build-nodejs-express-stormpath-app "A Simple Web App With Node.js, Express, Bootstrap & Stormpath"



