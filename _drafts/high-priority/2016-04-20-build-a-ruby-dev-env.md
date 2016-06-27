---
# MUST HAVE BEG
layout: post
disqus_identifier: 20160420-build-a-ruby-dev-env # DO NOT CHANGE THE VALUE ONCE SET
title: Ruby开发环境简介
# MUST HAVE END

is_short: true
subtitle:
tags: 
- ruby
date: 2016-04-20 22:36:00
image: 
image_desc: 
---





[1]: https://discussions.apple.com/thread/4006028?tstart=0 "iTunes won't open on my Windows 7 PC."





gemfile
gemfile.lock
bundle
rake

## ri
## doc, rdoc, ri 文档
http://samuelmullen.com/2012/01/up-and-running-with-ruby-interactive-ri/
ri stands for “Ruby Interactive”
可以用来离线看文档

ri Array
ri Array.min
ri Array::wrap
ri Array#min

$ ri Enumerable.each   不用敲全，会列出所有each开头的东西

ri -f ansi Array.sort    带颜色显示

$ ri -i        “interactive” mode

还有vim插件

http://rubylearning.com/satishtalim/ruby_ri_tool.html
ri (Ruby Index) and RDoc (Ruby Documentation) are a closely related pair of tools
ri is a command-line tool; the RDoc system includes the command-line tool rdoc. 
ri and rdoc are standalone programs
rdoc scans your files, extracts the comments
ri tool is used to view the Ruby documentation off-line

If a class defines a class method and an instance method by the same name, you must instead use :: to refer to a class method or # to refer to the instance method. 
:: 表示class method
#  表示instance method
.  不区分

ri dovetails with RDoc: It gives you a way to view the information that RDoc has extracted and organized. 


http://www.jstorimer.com/blogs/workingwithcode/7766081-5-reasons-you-should-use-ri-to-read-ruby-documentation
$ ri File
$ ri Fil
$ ri File.directory?
$ ri Socket#accept
$ ri ActiveRecord::Base.touch

Interactive Mode
Start typing the classes and methods you're looking for and use <tab> for autocompletion.

generate the missing ri docs for all your installed gems you can
$ gem rdoc --all --ri --no-rdoc


生成文档
http://stackoverflow.com/questions/664651/can-you-install-documentation-for-existing-gems
 gem help rdoc   看看rdoc的帮助

