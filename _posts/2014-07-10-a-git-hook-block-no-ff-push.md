---
# MUST HAVE BEG
layout: post
disqus_identifier: 20140710-a-git-hook-block-noff-push # DON'T CHANGE THE VALUE ONCE SET
title: A Git Hook Script to Block No-Fast-Forward Push
# MUST HAVE END

subtitle:
tags: 
- git
date: 2014-07-10 10:30:00
image:
image_desc:
---

    #!/bin/sh

    # for details see here, http://git-scm.com/book/en/Customizing-Git-An-Example-Git-Enforced-Policy
    # it seems that git on Windows doesn't support ruby, so use bash instead
    # to function, put it into remote hook dir
    # to disable, rename or delete file in remote hook dir

    refname=$1
    oldrev=$2
    newrev=$3


    # enforces fast-forward only pushes
    check_fast_forward ()
    {
      all_refs=`git rev-list ${oldrev}..${newrev} | wc  -l`
      single_parent_refs=`git rev-list ${oldrev}..${newrev} --max-parents=1 | wc  -l `
      if [ $all_refs -ne $single_parent_refs ]; then
        echo "Now not allow to push a non fast-forward reference."
        echo "If it cause any inconvenient, please tell."
        exit 1
      fi
    }

    check_fast_forward

Name the above script as "update", and put it into remote repo's "hooks" directory. If necessary, make it executable. With simple test, this hook works well. It DOES block a client pushing any merge commit (no-fast-forward commit) to remote, meanwhile allow fast-forward push, which ensures a clean history in remote.

My first try was using a example scirpt from [this link](http://git-scm.com/book/en/Customizing-Git-An-Example-Git-Enforced-Policy). However, it didn't work.

The above script is implemented by bash script, and works on Windows. My original implementation used ruby, but failed on Windows.

If you find any bug or improvement, please let me know.
