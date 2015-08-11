My personal blog site powered by Jekyll and Github. [Click Me](http://rockhong.github.com/);-)

*The design of the site “copies” a lot from [163 lofter](http://www.lofter.com)*

##404 page##
[http://www.qq.com/404/](http://www.qq.com/404/) for lost children.    
An example 404 page,    
[http://rockhong.github.io/not-existing-page.html](http://rockhong.github.io/not-existing-page.html)       

##References:##
[Jekyll Project](https://github.com/mojombo/jekyll)     
[Liquid](https://github.com/shopify/liquid/wiki/liquid-for-designers)        
[Liquid Filters](http://docs.shopify.com/themes/liquid-documentation/filters/additional-filters#date)      
[YAML](http://yaml.org)       
[Markdown Syntax](http://daringfireball.net/projects/markdown/syntax)        
[Github Flavored Markdown](https://help.github.com/articles/github-flavored-markdown)      
[Chinese Markdown Tutorial](http://wowubuntu.com/markdown/)         

##Quick Links:##
[Github Status](https://status.github.com/messages)       
[Quick Start for Jekyll](https://help.github.com/articles/using-jekyll-with-pages/)        
[Jekyll Document](http://jekyllrb.com/docs/home/)           

##Run Jekyll Locally
From [this doc](https://help.github.com/articles/using-jekyll-with-pages/)

    switch to gh-pages branch for a Project Pages site. it's not my case.
    bundle exec jekyll serve
    go to http://localhost:4000

##Others
###How to implement "Read More" functionality
Jekyll already supports this, see [here](http://jekyllrb.com/docs/posts/#post-excerpts). Use `excerpt_separator`
and etc. to implement.

###Code Highlight
Jekyll already supports this, see [here](http://jekyllrb.com/docs/posts/#highlighting-code-snippets). For example,

    {% highlight ruby %}
    def show
        @widget = Widget(params[:id])
        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @widget }
        end
    end
    {% endhighlight %}

See more [here](http://jekyllrb.com/docs/templates/), and see language's short name [here](http://pygments.org/docs/lexers/).
To use this highlight function, a style sheet is also needed.

Github flavored markdown(GFM) also supports code highlight. Jekyll [supports GFM](http://jekyllrb.com/docs/configuration/).
All supported languages can be found here, [Code Highlight by Github Markdown](https://github.com/github/linguist/blob/master/lib/linguist/languages.yml).
Example,

    ```ruby
    require 'redcarpet'
    markdown = Redcarpet.new("Hello World!")
    puts markdown.to_html
    ```

(GFM treats newline differently to Markdown, so it's not very convenient to turn on GFM support on jekyll site.)
