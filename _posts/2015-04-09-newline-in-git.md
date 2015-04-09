---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150409-newline-in-git # DO NOT CHANGE THE VALUE ONCE SET
title: Git里的换行符
# MUST HAVE END

subtitle: Newline in Git
tags: 
- git
date: 2015-04-09 20:13:00
image:
image_desc:
---

今天在使用git时遇到一个“奇怪”的问题。操作系统是Windows 7，分别在Git Bash和cygwin里运行
`git status`命令，输出的结果相差非常大。cygwin下运行该命令提示有大量的文件被修改了（“Changes
not staged for commit”），但是实际上我并没有对这些文件做过任何的改动。

Google了一下后，发现是换行符导致的问题😔。Unix，Linux和OS X用`LF`表示换行（new line），而
Windows用`CRLF`表示换行。git在checkout一个文件时可以按照以下方式处理换行符：  
  
- 把文本文件中的换行符统一转换成`LF`    
- 把文本文件中的换行符统一转换成`CRLF`    
- 把文本文件中的换行符换成本地操作系统中的换行符     
- 认为这个文件是二进制文件，不做任何处理

在我工作的这个仓库（repository）里，很多文件的换行符策略被配置成“转换为本地系统的换行符”。
我是在Windows上用Git Bash克隆仓库的，所以这些文件的换行符是`CRLF`。当我在cygwin里运行
`git status`时，git以为自己运行在Unix环境里😔，所以它认为这些文件的换行符从`LF`被换成了
`CRLF`。

## More Details
如果我们的git仓库永远都是工作在同一种操作系统下，那么换行符相关的问题可能不会困扰我们。但是
实际上我们常常会有意无意地跨操作系统进行工作。比如来自不同的操作系统的文件可以通过Dropbox、浏览器
、压缩包等途径进入到我们的git仓库。

git有自己“数据库”（.git目录）存着所有的commit；也有“working directory”，也就是当前的工作
目录。为了解决换行符问题，首先最好是让git在写“数据库”时使用`LF`作为换行符。

下面介绍一下git中换行符相关的一些设置。
<!--more-->

### core.eol
首先是`core.eol`。当git**把文件checkout到“working directory”时**如果需要改变换行符，会根据这个配置来设置换行符。     

- `core.eol = native` 这是默认值。当git需要改变换行符时（写文件到working directory时），用native的换行符
。也就是说Windows下用`CRLF`，Unix/Linux/OS X下用`LF`。
- `core.eol = crlf` 使用`CRLF`做换行符。
- `core.eol = lf` 使用`LF`做换行符。

通过`git config --global core.eol`可以查看这个配置的值。如果输出是空，表示值是native。一般而言，最好
不要更改这个配置。这个配置对换行符的影响需要其它配置的配合。也就是说git的“其它配置”指定什么情况下
要改变换行符，而这个配置指定如果转换发生时（从“数据库”到“working directory”的转换）换行符应该用
哪个值。

### .gitattributes
我们可以在仓库的根目录下新建一个.gitattributes文件，告诉git应该怎么处理换行符。

- `*.txt text` 告诉git所有以`txt`为后缀的文件都是文本文件（git不会对二进制文件做换行符转换）。在
写“git数据库”前把所有的`CRLF`都换成`LF`。在写文件到working directory时，也做换行符转换；换行符
的值取决于`core.eol`。
- `*.txt text eol=crlf` 行为类似，只不过在写working directory时不用`core.eol`，而是`CRLF`。
`eol=crlf`会覆盖`core.eol`的值。
- `*.txt -text` 对所有以`txt`为后缀的文件，git都不会对它们的换行符做任何处理。
- `*.txt text=auto` 对所有以`txt`为后缀的文件，让git去决定它们是文本还是二进制文件。如果git
认为它们是文本就做转换。
- `*.png binary` `binary`是`-text -diff`的缩写。`-diff`表示git不会对这类文件做diff。

建议在.gitattributes文件的开头加上`*	text=auto`，这样对于.gitattributes中没有指定的文件类型
git会检查它们是不是文本，如果是文本就做换行符转换。

注：     
`*	text=auto`应该放在第一行，这样后续的行可以“覆盖”它。         
如果没有加`*	text=auto`，而且某种后缀的文件没有在.gitattributes中指定规则，那么git会根据
`core.autocrlf`来觉得如何转换换行符（后面介绍）。      
.gitattributes也会应该diff的行为，见它的帮助文档。

一个.gitattributes文件的例子
	
	*         text
	
	# These files are text and should be normalized (convert crlf => lf)
	*.cs      text diff=csharp
	*.csproj  text
	*.sln     text
	*.tt      text
	
	# Images should be treated as binary
	# (binary is a macro for -text -diff)
	*.png     binary
	*.jepg    binary

上面关于.gitattributes的内容适用于1.7.2之后的git版本。

### 对于1.7.2之前的git版本

`core.autocrlf`

- `core.autocrlf = false` git把文本文件写入它的“数据库”时不做任何换行符的转换。这是默认值。
- `core.autocrlf = true` 写“数据库”时`CRLF`会变成`LF`；写working directory时`LF`会变回`CRLF`。
- `core.autocrlf = input` 只在写“数据库”时把`CRLF`变成`LF`；反过来写working directory时不会
做任何动作。

可以用`git config --global core.autocrlf`来查看该配置的值。

`core.safecrlf`

- `core.safecrlf = true` 在把`CRLF`变成`LF`并写入“数据库”之前，git会看是不是能够转换回来。如果不能，
就放弃操作。
- `core.safecrlf = warn` 如果不能“互转”，仅仅警告用户。

.gitattributes文件     
`core.autocrlf`是“全局的”配置。.gitattributes文件可以按文件类型指定换行符的转换。它可以有类似下面的行。

- `*.txt crlf` 对所有后缀为`txt`的文件都做转换。
- `*.txt -crlf` 对所有后缀为`txt`的文件都不做转换。
- `*.txt crlf=input`对所有后缀为`txt`的文件仅在写如“数据库”时做换行符的转换。

## 参考文档
[gitattributes man page](http://schacon.github.io/git/gitattributes.html) 或者运行`git help gitattributes`      
[gitattributes](http://git-scm.com/docs/gitattributes)       
[gitattributes](http://git-scm.com/book/en/v2/Customizing-Git-Git-Attributes)       
[Mind the End of Your Line](http://adaptivepatchwork.com/2012/03/01/mind-the-end-of-your-line/)       
[A github help](https://help.github.com/articles/dealing-with-line-endings/)            
  
