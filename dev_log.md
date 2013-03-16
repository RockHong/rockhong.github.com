##HTML##
- DOCTYPE  
    <http://docs.webplatform.org/wiki/guides/doctypes_and_markup_styles>  
- Why <html xmlns="http://www.w3.org/1999/xhtml"> is recommended?  
    <http://www.html-5.com/tags/html-tag/index.html>   
    It's always better to add namespace to avoid potential conflicts ;-)  
- "lang" attribute  
    <http://reference.sitepoint.com/html/core-attributes/lang>  
    The intention of the lang attribute is to allow browsers (and other user agents) to adjust their displays. For example, if you use the q element, a browser should be able to identify the language in use and present the appropriate style of quotation marks...Another example,The lang attribute is helpful to users of assistive technology such as screen readers that can adjust the pronunciation depending on the language used. For example, the word penchant, meaning .a strong and continued inclination,. is French in origin. When the screen reader JAWS encounters the word, it pronounces it similar to .pen-chunt,. but when the word is marked up as 
    
        <span lang="fr">penchant</span>
        
    JAWS reads it using the proper French pronunciation, .pon-shont..   
    <http://www.dreamdu.com/xhtml/attribute_lang/>   
    If page is of XHTML1.1 or XML format, then use xml:lang; If is of HTML format, then should both use xml:lang and lang.   
- \<head\> tag
    <http://docs.webplatform.org/wiki/guides/the_html_head>  
    \<head\> is a place to put "meta info", css info, javascript info and title. title is the only one that's visible.  
- \<meta\> in \<head\>  
    <https://developer.mozilla.org/en-US/docs/HTML/Element/meta>  
    <http://docs.webplatform.org/wiki/guides/the_html_head>


##CSS##
- background   
    A very detailed introduction. <http://www.qianduan.net/everthing-about-css-background.html>

##Blog Design##
- 100 nice design   
    <http://www.hongkiat.com/blog/100-nice-and-beautiful-blog-design/>
- 163 lofter  
    <http://www.lofter.com/>
    
##TODO##
- Gallery
- Analytics   
To test
- Search
- Words of the Day
- Updates from friends' Sina Weibo
- Comment  
  Done
- back to top, example: <http://www.freelancer.com/>
- 网页乱码问题相关, 总结整理一下
<https://developer.mozilla.org/en-US/docs/HTML/Element/meta#attr-charset>

        <meta http-equiv="content-type" content="text/html;charset=utf-8"/>

  一个链接，<http://www.kmwzjs.com/site/q-view94.html>
  
- 'next btn' and 'prev btn' in post page
- 'more btn' in index page
- font size in safari, firefox, chrome
- test in IEs
- in index page, make 'image click effect' like '163 lofter'
- style links and other elements in post.html
- add published date and update date in end of post in a post page
- tag archive system  
  example: <https://github.com/Bilalh/bilalh.github.com>


##Others##
Free icon resource <http://www.webportio.com/>

##To Learn##
- site.categories  

        {% for post in site.categories.beginner %}
          <a href="{{ post.url }}">{{ post.title }}</a>
        {% endfor %}
      
- limit in for loop

        {% for post in site.posts limit: 7 %}
          <li><a href="{{ post.url }}">{{ post.title }}</a></li>
        {% endfor %}
  
- assign

        <div class="span-24">
          <h2 class>Latest Posts</h2>
          {% assign posts = site.posts %}
          {% assign listing_limit = 4 %}
          {% include post-listing-index.html %}
        </div>

- css  
  zoom    
  z-index    
  line-height   
  cursor: pointer; 
- html

        <div class="post-preview" data-cmtcount="8">   #data-cmtcount?
        <a href…  #target in href?
        <a href… #hidefocus in href?
        <a href… #title in href?
        #lofter image click effect
        <img data-ow="3271" data-oh="2244" data-origin="http://imglf0.ph.126.net/HK-Vf9uhmPGFFf5dPKKCzA==/6598226452889602284.jpg" style="width: 164px;" src="http://imglf2.ph.126.net/Dl4pKovCVBWmjVe0h3oj9A==/6598181372912870264.jpg" alt="第一次深夜上图，不知道有木有人...">  #data-oh? data-origin?

