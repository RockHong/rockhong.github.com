---
# MUST HAVE BEG
layout: post
disqus_identifier: 20160420-build-a-python-dev-env # DO NOT CHANGE THE VALUE ONCE SET
title: Python开发环境简介 
# MUST HAVE END

is_short: true
tags: 
- python
date: 2016-04-20 20:36:00
image: 
image_desc: 
---

## 依赖

	import requests

当在Python代码里[import][1]一个Python module时，你就引入了一个“依赖”

## 搜索依赖
Python解释器需要知道依赖的位置。如果import的module不是一个built-in module，
那么Python解释器就会去`sys.path`指定的目录下[搜索][2]。（`sys.path`在不同的系统上可能会有不同的值。）

## 安装依赖
Python内置了[Distutils][5]，它可以帮助开发者“分发”Python module，也帮助用户[安装][3]Python module。

    python setup.py install
	
默认情况下，上面的命令会把Python module安装类似`/usr/local/lib/pythonX.Y/site-packages`之类的目录。

## pip
Distutils是一个比较原始的工具，Python官方也推荐用户使用第三方工具来安装Python module，比如[pip][8]。
使用`pip`可以方便地从[PyPI][6]上下载package，并安装它。

	$ pip install SomePackage
	
`PyPI`类似于Java世界里的Maven（中央）仓库。

## virtualenv
不管是Distutils还是pip，在安装时都会把package安装到一个“全局的”目录下，比如上文
提到的`/usr/local/lib/pythonX.Y/site-packages`。这种情况下，更新某个package的
影响是全局的；很可能导致之前的Python程序突然不能工作了。

[virtualenv][9]提供了一种解决方案，它可以给不同的Python程序提供一个隔离的环境。
一个Python程序所依赖的所有package都存在于它自己的隔离环境里。

	$ virtualenv env
	
上面的命令生产了一个新的环境。Python执行程序，pip，和所有package都存在于`env`目录下。

使用`-p`选项，`-p PYTHON_EXE, --python=PYTHON_EXE`，可以在创建环境时指定Python执行程序。

## Requirements Files

	pip freeze > requirements.txt
	pip install -r requirements.txt
	
pip可以把当前安装的package的版本信息“快照”下来；也就是说你可以把当前可以工作的依赖信息
“快照”下来。未来可以通过`requirements.txt`把所有package回滚到可工作的状态。开发者
之间也可以通过`requirements.txt`来确保他们的工作环境是一致的。

`requirements.txt`最好被提交到git仓库里。

实际上，`requirements.txt`有点像Ruby世界里的`Gemfile.lock`文件。


<p>
注： 上面的文字在某种程度上把`module`，`package`和`依赖`混着用。
由于本身不是专业的Python开发者，如果任何错误，恳请指正。
</p>

[1]: https://docs.python.org/2/tutorial/modules.html "module"
[2]: https://docs.python.org/2/tutorial/modules.html#the-module-search-path "module search"
[3]: https://docs.python.org/2.7//install/index.html#how-installation-works "distutils install"
[5]: https://docs.python.org/2.7/distutils/index.html "distutils"
[6]: http://pypi.python.org/pypi "pypi"
[8]: https://pip.pypa.io/en/stable/ "pip"
[9]: https://virtualenv.pypa.io/en/latest/index.html "virtualenv"
[10]: https://pip.pypa.io/en/stable/user_guide/#requirements-files "Requirements files"




