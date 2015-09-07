---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150908-sort-a-linked-list # DO NOT CHANGE THE VALUE ONCE SET
title: Space Between inline-block Elements
# MUST HAVE END

is_short: false
subtitle:
tags: 
- interview
date: 2015-09-08 06:50:00
image: 
image_desc: 
---

Yesterday in an interview with Microsoft, I was asked to write a program to sort
a linked list. It sounded easy at first glance, (and it does). Since elements in a
linked list can only be accessed one followed another, my first try was sorting it
using "insertion sort". Starting coding without any thoughts, I was losted in implementation
details and failed to come out a "insertion sort" version. Not until fifteen or tweenty minutes later did I give out the first version.

### First Version
Spent minutes thinking, I come out a simple solution, which breaks itself down to
several steps and is easy to describe and implement. It solves the problem by:

1. start at list head, if an element and its adjacent element are not sorted, swap
them.
2. move to next element, repeat step 1 until the end.
3. check whether the list is all sorted. If not, go to step 1.

Code in C++.
struct Node {
  int value;
  Node *next;
}

Node * sort(Node *head) {





not too hurry, 不要一上来就写，先想；先想简单的方案
算法：先想大的有几步；不要每一步具体怎么实现；


Due to some nervousness