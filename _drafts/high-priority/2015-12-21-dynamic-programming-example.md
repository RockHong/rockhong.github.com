---
# MUST HAVE BEG
layout: post
disqus_identifier: 20151221-dynamic-programming-example # DO NOT CHANGE THE VALUE ONCE SET
title: xxx
# MUST HAVE END

is_short: true
subtitle:
tags: 
- xxx
date: 2015-09-26 15:36:00
image: 
image_desc: 
---


面试题有十个台阶，每次可以走一步，两步，或者三步，问有几种走法？
f(n) = f(n-1) + f(n-2) + f(n-3)


---------------------------------------------------------------
In contrast, dynamic programming applies when the subproblems
overlap—that is, when subproblems share subsubproblems. In this context,
a divide-and-conquer algorithm does more work than necessary, repeatedly solving
the common subsubproblems.
如果子问题很多都是重复的，那么分治法可能就不适合了

A dynamic-programming algorithm solves each
subsubproblem just once and then saves its answer in a table, thereby avoiding the
work of recomputing the answer every time it solves each subsubproblem.
动态规划会把子问题的解存起来
dynamic programming实际上的字面意思是？

1. Characterize the structure of an optimal solution.
2. Recursively define the value of an optimal solution.     找到递归形式
3. Compute the value of an optimal solution, typically in a bottom-up fashion.
4. Construct an optimal solution from computed information.    这一步可选；取决于问题的需求


问题1
Serling Enterprises buys long steel rods and cuts them into shorter rods, which it then sells. 
Each cut is free.

The rod-cutting problem is the following. Given a rod of length n inches and a
table of prices pi for i D 1;2; : : : ;n, determine the maximum revenue rn obtainable
by cutting up the rod and selling the pieces. Note that if the price pn for a rod
of length n is large enough, an optimal solution may require no cutting at all.
给一个rod，长为n
给一个表，里面有各个长度的rod对应的价格
怎么切rob，才能得到最大的收入

假设长度的单位都是整数
长度为n的rob，有2的n-1次方种切法；暴力解法不太可行

rn = max(pn, r1+rn-1, r2+rn-2, ... rn-1 + r1)
原问题rn的解是pn（一道不切），r1+rn-1（先切在位置1），等等可能解中的价格最高的那个
推导递归形式的时候看“做一步”后，子问题是什么样的；比如这个做一步（切一刀）后，子问题是什么样的

书里面问了简化，把上面的递归形式写成
rn = max(pi + rn-i)     1<=i <= n

用动态规划的方式解这个递归表达式
There are usually two equivalent ways to implement a dynamic-programming approach. 两种方式
第一种，top-down with memoization
In this approach, we write
the procedure recursively in a natural manner, but modified to save the result of
each subproblem (usually in an array or hash table). The procedure now first checks
to see whether it has previously solved this subproblem. If so, it returns the saved
value, saving further computation at this level; if not, the procedure computes the
value in the usual manner.
和普通的、非动态规划的递归写法类似；只不过求解fn时，先看看fn是不是已经存下来了；如果是，就直接返回保存的值；如果不是，再去算

第二种是bottom-up method
This approach typically depends
on some natural notion of the “size” of a subproblem, such that solving any particular
subproblem depends only on solving “smaller” subproblems. We sort the
subproblems by size and solve them in size order, smallest first. When solving a
particular subproblem, we have already solved all of the smaller subproblems its
solution depends upon, and we have saved their solutions. We solve each subproblem
only once, and when we first see it, we have already solved all of its
prerequisite subproblems.
把问题安装规模大小排好序；先算小的；大的问题依赖小的问题的解；而小的问题的解之前都算过了；

两种方法复杂度差不多；但是bottom up的，复杂度的常数更小一些；
书中给出了，两种方式的解；看看；看看bottom up的是怎么按问题规模大小解的；

Subproblem graphs

Reconstructing a solution
Our dynamic-programming solutions to the rod-cutting problem return the value of
an optimal solution, but they do not return an actual solution: a list of piece sizes.


习题
问题变形；切一刀都有一个cost；给出问题的解


The Fibonacci numbers are defined by recurrence (3.22). Give an O.n/-time
dynamic-programming algorithm to compute the nth Fibonacci number. Draw the
subproblem graph. How many vertices and edges are in the graph?
给出斐波那契数列的动态规划解



问题2
给矩阵乘法加括号，使得cost最少； 乘法运算做的最少



---------
15.3 Elements of dynamic programming
可以用动态规划的两个要素，optimal
substructure and overlapping subproblems

第一步 是 to characterize the structure of an optimal solution

Recall that a problem exhibits
optimal substructure if an optimal solution to the problem contains within it optimal
solutions to subproblems.
如果一个问题的最优解包含了子问题的最优解，那么这个问题就有optimal substructure
如果有optimal substructure，那么就可能能用dp

在发现、寻找optimal substructure时，注意一些常见的pattern
1 a solution to the problem consists of making a choic；Making this choice leaves one or more subproblems to be solved.
做选择使得问题规模变小
2 You suppose that for a given problem, you are given the choice that leads to an
optimal solution. You do not concern yourself yet with how to determine this
choice. You just assume that it has been given to you.
你要假设对于某个特定问题f（n），你已经做好了选择；不用关心，怎么去做这个选择；
3 Given this choice, you determine which subproblems ensue and how to best
characterize the resulting space of subproblems
- You show that the solutions to the subproblems used within an optimal solution
to the problem must themselves be optimal by using a “cut-and-paste” technique.
You do so by supposing that each of the subproblem solutions is not
optimal and then deriving a contradiction. In particular, by “cutting out” the
nonoptimal solution to each subproblem and “pasting in” the optimal one, you
show that you can get a better solution to the original problem, thus contradicting
your supposition that you already had an optimal solution. If an optimal
solution gives rise to more than one subproblem, they are typically so similar
that you can modify the cut-and-paste argument for one to apply to the others
with little effort.
证明；证明子问题也要是optimal的
用反证法证明；假设子问题不是最优解，那么会有什么样的矛盾
可以这么反证：  f(n) = f(n-2) + f(2)  ； 假设f（n-2）不需要是optimal的；把它cut off；把一个最优的paste in；如果得到一个比原来的更optimal的解；那么就有矛盾了







