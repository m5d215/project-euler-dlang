/// Problem 2: 偶数のフィボナッチ数
///
/// フィボナッチ数列の項は前の 2 つの項の和である。
/// 最初の 2 項を 1、2 とすれば, 最初の 10 項は以下の通りである。
/// -----
/// 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
/// -----
///
/// 数列の項の値が 400 万以下の、偶数値の項の総和を求めよ。
module project_euler.problem002;

import std.range : recurrence;
import system.linq : sum, takeWhile, where;

uint problem002(in uint upper)
{
    return recurrence!"a[n - 1] + a[n - 2]"(1, 2).takeWhile!(x => x <= upper).where!(x => x % 2 == 0).sum;
}

unittest
{
    assert(problem002(89) == 2 + 8 + 34);
    assert(problem002(400_0000) == 4613732);
}
