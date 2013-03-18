---
# MUST HAVE BEG
layout: post
disqus_identifier: 20130318-git-tips-config # DON'T CHANGE THE VALUE ONCE SET
title: Git Configuration
subtitle: Git的配置
# MUST HAVE END
tags: git
date: 2012-03-18 22:33:00
---
Git通过一系列配置文件来决定它的行为。`/etc/gitconfig`是Git最先查看的配置文件。这个文件中的配置信息会应用于系统上的每个用户的每个仓库。运行`git config`命令时加上`--system`选项，会读写这个配置文件。下一个配置文件是`~/.gitconfig`，存放着某个用户的特定配置；`--global`选项可读写这个配置文件。最后，Git会查看当前仓库中的`.git/config`文件；该文件存放着这个仓库特定的配置信息。这三个配置文件有着不同的优先级，`/etc/gitconfig`最低，`.git/config`最高，低优先级的配置信息会被高优先级的所覆盖。虽然可以手工修改这三个文件来配置Git，但是推荐运行`git config`命令来进行读写。

最常用的配置信息是用户名（username）和邮件（email），因为Git的每一次提交中都会保存用户名和邮件地址信息。可以使用如下方式来设置， 

    $ git config --global user.name "John Doe"
    $ git config --global user.email johndoe@example.com  

Github是当前最流行的在线代码仓库。每个Github账户都有对应的邮箱（可以有多个邮箱），Github通过查看一个提交中的邮箱信息来“认定“这次提交归功于哪个用户。所以从一台（新）机器提交代码到远程Github仓库前，要检查一下Git的邮箱配置信息是否正确。工作在多台机器上时，要特别注意这点。详见[Github帮助](https://help.github.com/articles/why-are-my-commits-linked-to-the-wrong-user)。


另外，一台机器上可能同时存在不同类型的仓库，比如私人项目和公司项目。这些不同类型的仓库往往使用不同的邮件地址。这时最好不要配置global的邮件地址，转而为每个仓库分别设置邮件地址。


通过`git config`还可以为一些Git命令设置别名，比如

    $ git config --global alias.co checkout
    $ git config --global alias.st status
    $ git config --global alias.last ’log -1 HEAD’

当然还可以配置其它更丰富的信息，可以参见[Pro Git](http://git-scm.com/book/en/Customizing-Git-Git-Configuration)的相关章节。