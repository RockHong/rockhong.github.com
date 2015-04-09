---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150409-newline-in-git # DO NOT CHANGE THE VALUE ONCE SET
title: Git里的换行符
# MUST HAVE END

is_short: true
subtitle:Newline in Git
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
1. 把文本文件中的换行符统一转换成`LF`
2. 把文本文件中的换行符统一转换成`CRLF`
3. 把文本文件中的换行符换成本地操作系统中的换行符
4. 认为这个文件是二进制文件，不做任何处理
在我工作的这个仓库（repository）里，很多文件的换行符策略被配置成“转换为本地系统的换行符”。
我是在Windows上用Git Bash克隆仓库的，所以这些文件的换行符是`CRLF`。当我在cygwin里运行
`git status`时，git以为自己运行在Unix环境里😔，所以它认为这些文件的换行符从`LF`被换成了
`CRLF`。

### More Details
如果

--------------
http://git-scm.com/docs/gitattributes
Set to string value "auto"
When text is set to "auto", the path is marked for automatic end-of-line normalization. If Git decides that the content is text, its line endings are normalized to LF on checkin.


http://adaptivepatchwork.com/2012/03/01/mind-the-end-of-your-line/
None of this would be a problem if we each lived in our own little worlds and never shared code between operating systems.

In fact, anytime you download a sample project in a zip file, copy code out of a gist, copy code from someones blog or use code out of a file that you keep in Dropbox - you are sharing text and you need to deal with these invisible line-ending characters

Git's primary solution to all this is to specify that LF is the best way to store line endings for text files in a Git repository's object database.

In all but the rarest of cases you should never have to change this setting from it's default. This setting doesn't do much on its own, but as soon as we start telling Git to change our line endings for us we need to know the value of core.eol.

core.eol = native The default.When Git needs to change line endings to write a file in your working directory it will change them to whatever is the default line ending on your platform. For Windows this will be CRLF, for Unix/Linux/OS X this will be LF.

core.eol = crlf When Git needs to change line endings to write a file in your working directory it will always use CRLF to denote end of line.

core.eol = lf

git config --global core.eol
If nothing comes back that means you are on the using the default which is native.

##The Old System
Git has a configuration setting called core.autocrlf which is specifically designed to make sure that when a text file is written to the repository's object database that all line endings in that text file are normalized to LF.

core.autocrlf = false This is the default, but most people are encouraged to change this immediately.
The result of using false is that Git doesn't ever mess with line endings on your file. 

core.autocrlf = true
will process all text files and make sure that CRLF is replaced with LF when writing that file to the object database and turn all LF back into CRLF when writing out into the working directory. 
This is the recommended setting on Windows because it ensures that your repository can be used on other platforms while retaining CRLF in your working directory.

core.autocrlf = input
 will process all text files and make sure that CRLF is replaced with LF when writing that file to the object database. 
It will not, however, do the reverse
This setting is generally used on Unix/Linux/OS X to prevent CRLFs from getting written into the repository. 
The idea being that if you pasted code from a web browser and accidentally got CRLFs into one of your files, Git would make sure they were replaced with LFs when you wrote to the object database.

How does Git know that a file is text? Good question.
Git has an internal method for heuristically checking if a file is binary or not. A file is deemed text if it is not binary. 

core.safecrlf which is designed to protect against these cases where Git might change line endings on a file that really should just be left alone.

core.safecrlf = true - When getting ready to run this operation of replacing CRLF with LF before writing to the object database, Git will make sure that it can actually successfully back out of the operation. It will verify that the reverse can happen (LF to CRLF) and if not the operation will be aborted.

core.safecrlf = warn

.gitattributes
These rules allow you to control things like autocrlf on a per file basis.

*.txt crlf
*.txt -crlf
*.txt crlf=input

##The New System
The new system moves to defining all of this in the .gitattributes file that you keep with your repository.

*.txt text Set all files matching the filter *.txt to be text.
will run CRLF to LF replacement on these files every time they are written to the object database and the reverse replacement will be run when writing out to the working directory.

*.txt -text Unset

*.txt text=auto Set all files matching the filter to be converted (CRLF to LF) if those files are determined by Git to be text and not binary. This relies on Git's built in binary detection heuristics.

If a file is unspecified then Git falls back to the core.autocrlf setting and you are back in the old system. 

(binary is a macro for -text -diff)

*       text=auto

This is certainly better than requiring everyone to be on the same global setting for core.autocrlf, but it means that you really trust Git to do binary detection properly. In my opinion it is better to explicitly specify your text files that you want normalized. Don't forget if you are going to use this setting that it should be the first line in your .gitattributes file so that subsequent lines can override that setting.


https://help.github.com/articles/dealing-with-line-endings/
# Declare files that will always have CRLF line endings on checkout.
*.sln text eol=crlf

text eol=lf

git rm --cached -r .
git reset --hard


http://git-scm.com/book/en/v2/Customizing-Git-Git-Attributes
Now, Git won’t try to convert or fix CRLF issues; nor will it try to compute or print a diff for changes in this file when you run git show or git diff on your project.


-----------------
Emoji是unicode的一部分，UTF-8编码也是可以表示Emoji的。
比如😁对应的unicode是`U+1F601`，对应的UTF-8编码是`\xF0\x9F\x98\x81`。所以我们可以在UTF-8编码存储的
文本中（比如HTML文件）保存Emoji表情。

###显示文本中的Emoji
我们需要一种字体来显示以UTF-8编码的Emoji表情。通常，一种字体不能显示所有的UTF-8编码。不能显示时，通常
会显示成一个“小方块”。在较新的OS X系统上，`Apple Color Emoji`字体可以显示Emoji表情。在较新的Windows上
（比如Windows 7/8），`Segoe UI Symbol`字体可以显示黑白的Emoji表情。Windows 8上可以用
`Segoe UI Emoji`字体来显示彩色的表情。

###显示网页上的Emoji
对于网页元素，我们可以通过CSS属性`font-family`来指定（一系列）字体。比如，

    font-family: Gill Sans Extrabold, sans-serif;

排在前面的字体优先级较后面的高。如果用户电脑上没有安装优先级高的字体，那么根据优先级依次尝试后续的
字体。如果所有的字体都没有找到，那么使用浏览器提供的字体（Initial value depends on user agent）。
在OS X上，如果font-family中没有指定可以显示Emoji的字体，Safari是可以正常显示Emoji的，而Chrome则不能。
这是因为这两个浏览器提供的默认字体有区别。

为了在Windows和OS X上都能显示Emoji表情，可以向font-family里加入`Apple Color Emoji`，`Segoe UI Emoji`，
和`Segoe UI Symbol`字体。比如，

    font-family: Helvetica, arial, freesans, clean, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol';

最后效果如下，       
Chrome on Windows 7       
<img src="../images/blog/chrome-win7-emoji.png" alt="chrome win7 emoji" title="chrome win7 emoji" style="display: block; width: 90px; margin-left: 0px; margin-right: 0px;">
IE 11 on Windows 7      
<img src="../images/blog/ie-win7-emoji.png" alt="ie win7 emoji" title="ie win7 emoji" style="display: block; width: 90px; margin-left: 0px; margin-right: 0px;">
Safari on OS X     
<img src="../images/blog/safari-osx-emoji-png.png" alt="safari osx emoji" title="safari osx emoji" style="display: block; width: 90px; margin-left: 0px; margin-right: 0px;">
Chrome on OS X      
<img src="../images/blog/chrome-osx-emoji-png.png" alt="chrome osx emoji" title="chrome osx emoji" style="display: block; width: 90px; margin-left: 0px; margin-right: 0px;">


###参考连接
[Emoji Unicode Tables](http://apps.timwhitlock.info/emoji/tables/unicode)     
[Segoe UI Symbol](https://msdn.microsoft.com/en-us/library/windows/apps/jj841126.aspx)     
[font-family MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/font-family)      
[font-family](http://www.w3schools.com/cssref/pr_font_font-family.asp)    
