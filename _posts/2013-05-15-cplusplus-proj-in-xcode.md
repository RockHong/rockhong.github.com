---
# MUST HAVE BEG
layout: post
disqus_identifier: 20130515-cplusplus-proj-in-xcode # DON'T CHANGE THE VALUE ONCE SET
title: 在XCode中新建C++工程
# MUST HAVE END

is_short: true
subtitle:
tags: 
- xcode
date: 2013-05-15 22:16:00
image: 	
image_desc: 
---

我的XCode版本是4.6.2。

新建一个C++工程的步骤如下，  
第一步，打开“File”->“New”->“Project…”，在弹出的选择模版的对话框中选择“OS X”->“Application”->“Command Line Tool”，如图   

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/xcode-cpp-step1.png" alt="xcode c++ step1" style="width: 630px;">
</div>

第二部，填好工程名字（Product Name）；在“Type”下拉列表中选择“C++”；取消选择“Use Automatic Reference Counting”（Apple应该没有为C++提供ARC的吧），如图    

<!-- at least one blank line before <div>, <p>, <pre> or <table>,
and one blank after </div>.
but you can use <span>, <cite>, <del> freely -->
<div style="text-align: center;">
  <img src="/images/blog/xcode-cpp-step2.png" alt="xcode c++ step2" style="width: 630px;">
</div>

完成，新的C++工程就建好了。

待做——向XCode中导入已经存在的C++工程。  
[http://stackoverflow.com/questions/5034286/import-existing-c-project-into-xcode-ide](), Do more search.

