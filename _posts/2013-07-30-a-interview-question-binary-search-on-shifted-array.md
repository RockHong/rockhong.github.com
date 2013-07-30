---
# MUST HAVE BEG
layout: post
disqus_identifier: 20130730-a-interview-question-search-on-shifted-array # DON'T CHANGE THE VALUE ONCE SET
title: 一道面试题：平移后的数组的搜索问题
# MUST HAVE END

subtitle:
tags: 
- interview
date: 2013-07-30 13:16:00
image:
image_desc:
---

最近在面试的时候被问到一个算法题：
有一个升序排列的数组，经过一系列的“平移”操作，然后在平移后的数组中查找某个值；请给出一个算法。
平移的定义如下：
假设有数组{1, 2, 3, 4, 5}， 平移最后两位，那么数组变为{4, 5, 1, 2, 3}。

首先，一系列平移操作可以看成是一次平移。比如，
先平移最后两位到左边，得到`{4, 5, 1, 2, 3}`，
再平移最开始的三位到右边，得到`{2, 3, 4, 5, 1}`。
上述两次平移操作的结果和一次平移第一位到右边的效果是相同的。

注意到数组最初是升序排列的，可以想到用二分搜索查找。经过一系列平移后，虽然整个数组不再是升序排列了，但是可以看到数组被分成了两个部分（子数组），各自都是升序的。
比如，`{4, 5}和`{1, 2, 3}`。如果可以找到数组在什么位置被截开，那么就可以对两个升序子数组进行二分查找。

###如何确定数组被截开的位置
实际上，也可以使用二分的思想找到这个位置。比如，
`{4, 5, 1, 2, 3}`在中点分开，得到`{4, 5, 1}`和`{1, 2, 3}`。可以看到截开位置在`{4, 5, 1}`；判定的条件是数组首元素大于数组尾元素（`4 > 1`）。

###源代码
[github地址](https://github.com/RockHong/sample-code/blob/master/alg/shiftedArraySearch.cpp)

    #include <iostream>
    #include <string>
    #include <gtest/gtest.h>

    using namespace std;

    int shiftedPosition(int *array, int low, int high)
    {
        static string level;
        level.push_back(' ');
        cout << __FUNCTION__ <<level <<"run for array(" <<array <<"): low=" <<low <<", high=" <<high <<endl;
        int pos = 0;

        if (high - low <= 1) {
            pos = array[low] > array[high] ? high : low;
            level.erase(level.size() - 1);
            return pos;
        }

        int mid = (low + high)/2;
        if (array[low] > array[mid]) {
            pos = shiftedPosition(array, low, mid);
        }
        else if (array[mid] > array[high]) {
            pos = shiftedPosition(array, mid, high);
        }
        else {
            pos = low;
        }

        level.erase(level.size() - 1);
        return pos;
    }

    int shiftedArraySearch(int *array, int size, int key)
    {
        int pos = shiftedPosition(array, 0, size-1);

        int low;
        int high;

        if (array[0] <= key && key <= array[pos-1]) {
            low = 0;
            high = pos -1;
        }
        else if (array[pos] <= key && key <= array[size -1]) {
            low = pos;
            high = size -1;
        }
        else {
            return -1;
        }

        while(low <= high) {
            int mid = (low + high)/2;
            if (array[mid] == key) return mid;
            if (array[mid] > key) high = mid - 1;
            else if (array[mid] < key) low = mid + 1;
        }

        return -1;
    }

    TEST(ShiftedArraySearchTest, xxx) {
        int array1[1] = {1};
        int arrayOdd[9] = {2, 5, 8, 9, 11, 15, 19, 21, 24};
        int arrayOddLargeLeft[9] = {9, 11, 15, 19, 21, 24, 2, 5, 8 };
        int arrayOddLargeRight[9] = {19, 21, 24, 2, 5, 8, 9, 11, 15};
        int arrayEven[8] = {2, 5, 8, 9, 11, 15, 19, 21};
        int arrayEvenLargeLeft[8] = {8, 9, 11, 15, 19, 21, 2, 5};
        int arrayEvenLargeRight[8] = {21, 2, 5, 8, 9, 11, 15, 19};

        EXPECT_EQ(0, shiftedPosition(array1, 0, 0));
        EXPECT_EQ(0, shiftedPosition(arrayOdd, 0, 8));
        EXPECT_EQ(6, shiftedPosition(arrayOddLargeLeft, 0, 8));
        EXPECT_EQ(3, shiftedPosition(arrayOddLargeRight, 0, 8));
        EXPECT_EQ(0, shiftedPosition(arrayEven, 0, 7));
        EXPECT_EQ(6, shiftedPosition(arrayEvenLargeLeft, 0, 7));
        EXPECT_EQ(1, shiftedPosition(arrayEvenLargeRight, 0, 7));

        EXPECT_EQ(-1, shiftedArraySearch(array1, 1, 999));
        EXPECT_EQ(0, shiftedArraySearch(array1, 1, 1));
        EXPECT_EQ(8, shiftedArraySearch(arrayOdd, 9, 24));
        EXPECT_EQ(-1, shiftedArraySearch(arrayEven, 8, 999));
        EXPECT_EQ(7, shiftedArraySearch(arrayOddLargeLeft, 9, 5));
        EXPECT_EQ(0, shiftedArraySearch(arrayEvenLargeRight, 8, 21));
    }

    

