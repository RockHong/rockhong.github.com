---
# MUST HAVE BEG
layout: post
disqus_identifier: 20150924-sort-a-linked-list # DO NOT CHANGE THE VALUE ONCE SET
title: Sort A Linked List
# MUST HAVE END

is_short: false
subtitle:
tags: 
- interview
date: 2015-09-24 23:24:00
image: 
image_desc: 
---

Days ago, I took an online interview from Microsoft Shanghai. After some quick
questions, I was asked to solve a simple question, sorting a linked list, in a
online editor, whose content was shared between me and the interviewer in real-time.

### Solutions
Below are three solutions. Source is [here][1].

#### Solution 1
Iterate from the head of list to the end. For an element, if it's larger than the
next one, swap them. Therefore, after the first pass, the largest one goes to the
last position of the list. After the second pass, the second largest one gets to
the second last position. Keep iterating until the list is sorted.

Obviously, the complexity is `O(n^2)`.

{% highlight xml %}
#include "gtest/gtest.h"
#include <iostream>

struct Node{
    int value;
    Node *next;
};
typedef struct Node * NodePtr;

bool isSorted(NodePtr head);
void swap(NodePtr *prev, NodePtr p);

NodePtr sort_1(NodePtr head) {
    if (head == NULL) {
        return head;
    }
    
    while (!isSorted(head)) {
        NodePtr ptr = head;
        NodePtr *prev = &head;
        while (ptr->next != NULL) {
            if (ptr->value > ptr->next->value) {
                swap(prev, ptr);
            }
            ptr = (*prev)->next;
            prev = &((**prev).next); // hate this...
        }
    }
    return head;
}

bool isSorted(NodePtr head) {
    if (head == NULL) {
        return true;
    }
    
    NodePtr ptr = head;
    while (ptr->next != NULL) {
        if (ptr->value > ptr->next->value) {
            return false;
        }
        ptr = ptr->next;
    }
    return true;
}

/*
 *      -> [ ] -> []
 *    /     |
 * prev     p
 */
void swap(NodePtr *prev, NodePtr p) {
    *prev = p->next;
    NodePtr tmp = p->next->next;
    p->next->next = p;
    p->next = tmp;
}
{% endhighlight %}

#### Solution 2
Solution 2 solves the problem recursively. The problem of size `N` can be solved by
solving problem of size `N-1` firstly and then inserting the first element into the
sorted list.

The code is cleaner, and the complexity is also `O(n^2)`.

{% highlight xml %}
NodePtr insert(NodePtr list, NodePtr node);

NodePtr sort_2(NodePtr node) {
    NodePtr sub = NULL;
    if (node->next != NULL) {
        sub = sort_2(node->next);
    }
    
    return insert(sub, node);
}

NodePtr insert(NodePtr list, NodePtr node) {
    if (list == NULL) {
        return node;
    }
    
    // find the position to insert
    NodePtr ptr = list;
    NodePtr prev = NULL;
    while (ptr != NULL && ptr->value < node->value) {
        prev = ptr;
        ptr = ptr->next;
    }
    
    NodePtr newHead = list;
    if (prev == NULL) {
        node->next = ptr;
        newHead = node;
    } else {
        prev->next = node;
        node->next = ptr;
    }

    return newHead;
}
{% endhighlight %}

#### Solution 3
This solution does it in a "divide-and-conquer" way. It divides the problem into
small ones, sorts them, and merges small sorted list into larger ones till the
whole list is sorted.

The inner loop takes `O(n)` time. The outer loop runs `O(lgn)` times. So this
soluton is `O(nlgn)`.
<!--more-->

{% highlight xml %}
NodePtr getSubList(NodePtr *pos, int n);
int getListSize(NodePtr head);
NodePtr merge(NodePtr first, NodePtr second, NodePtr *head, NodePtr *tail);

NodePtr sort_3(NodePtr head) {
    int listSize = getListSize(head);
    int subSize = 1;
    int mergedSize = subSize * 2;
    
    while(true) {
        NodePtr pos = head;
        NodePtr prevTail = NULL;
        head = NULL;
        do {
            NodePtr subHead1 = getSubList(&pos, subSize);
            NodePtr subHead2 = getSubList(&pos, subSize);
            if (subHead1 == NULL && subHead2 == NULL) {
                return head;
            }
            NodePtr newHead = NULL;
            NodePtr newTail = NULL;
            merge(subHead1, subHead2, &newHead, &newTail);
            if (head == NULL) {
                head = newHead;
            }
            if (prevTail != NULL) {
                // connect the previous merged sublist and current merged sublist
                prevTail->next = newHead;
            }
            if (newTail != NULL) {
                // connect current merged sublist's tail to the rest of list
                newTail->next = pos;
            }
            prevTail = newTail;
            
            if (mergedSize >= listSize) {
                return head;
            }
        } while (pos != NULL);
        subSize = subSize * 2;
        mergedSize = subSize * 2;
    }
    return head;
}

int getListSize(NodePtr head) {
    if (head == NULL) {
        return 0;
    }
    
    int i = 1;
    while (head->next != NULL) {
        ++i;
        head = head->next;
    }
    return i;
}

/*
 * Return the head of sub list.
 * @pos will at the next position of the sub list's tail.
 */
NodePtr getSubList(NodePtr *pos, int n) {
    if (*pos == NULL) {
        return NULL;
    }
    
    NodePtr subHead = *pos;
    NodePtr subTail;
    int i = 0;
    while (i < n && *pos != NULL) {
        ++i;
        subTail = *pos;
        *pos = (*pos)->next;
    }
    subTail->next = NULL;
    return subHead;
}

NodePtr merge(NodePtr first, NodePtr second, NodePtr *head, NodePtr *tail) {
    NodePtr pos1 = NULL;
    NodePtr pos2 = NULL;
    if (first == NULL) {
        *head = second;
        pos2 = second->next;
    } else if (second == NULL) {
        *head = first;
        pos1 = first->next;
    } else if (first->value > second->value) {
        *head = second;
        pos1 = first;
        pos2 = second->next;
    } else {
        *head = first;
        pos1 = first->next;
        pos2 = second;
    }
    
    NodePtr sorted = *head;
    
    while (pos1 != NULL && pos2 != NULL) {
        if (pos1->value > pos2->value) {
            sorted->next = pos2;
            sorted = pos2;
            pos2 = pos2->next;
        } else {
            sorted->next = pos1;
            sorted = pos1;
            pos1 = pos1->next;
        }
    }

    if (pos1 != NULL) {
        sorted->next = pos1;
    } else if (pos2 != NULL) {
        sorted->next = pos2;
    }
    
    *tail = sorted;
    while (sorted->next != NULL) {
        sorted = sorted->next;
        *tail = sorted;
    }
   
    return *head;
}
{% endhighlight %}

### The Interview
It sounded rather easy at first glance, and it really is. Within seconds, I told
the interviewer it could be solved by "insertion sorting" since a linked list cannot
be accessed randomly. I started coding immediately and was losted in implementaion
details soon. Minutes later, it become unable to continue. I told the interviewer
I was stuck. With more minutes, I come up with a draft version of solution 1. It
finally took around 30 minutes to solve this easy question. And next 15 minutes
interview to pick out mistakes from my draft solution.

It made me awkward. An eligible candidate is supposed to solve it much more quickly!
And the result of interview confirms it - no further call from Microsoft.

I usually feel nervous during interview, maybe due to the personality. In an interview,
the interviewees are expected to respond quickly, which gives more pressures.
Putting my bad feelings alone, there are still somethings to keep in mind when
solving a problem:

- think about it first before implement. Do some drawings or scratch on paper
if needed.
- try to describe a soluton in a few steps without thinking about details of each
step. For example, solution 1 is easy to describe in a few simple steps. It's just
like programming in C - implementing a function by some small ones, which makes
code clean. Thinking/solving this way makes people think more easily and not lost
in great details.
- recursion also helps people think. Like the above one, recursion breaks the
problem down. A big problem usually becomes a smaller one plus some extra steps.
You don't need to think about solving the problem(N-1) (at last it becomes to
problem(1) and easy to solve).
- just like design patter to OO, there are "patterns" to algorithm design, like
"divide-and-conquer", dynamic programming and greedy algorithm. Thinking about them,
then maybe an (efficient) solution come out.

[1]: https://gist.github.com/RockHong/108813b2cae13d3fa511 "source code"

