/// Problem 4: 最大の回文積
///
/// 左右どちらから読んでも同じ値になる数を回文数という。
/// 2 桁の数の積で表される回文数のうち、最大のものは 9009 = 91 x 99 である。
/// では、3 桁の数の積で表される回文数の最大値を求めよ。
module project_euler.problem004;

import std.range : retro;
import system.linq : any, counting, select, where;
import project_euler.foundation : PalindromeSequence;

uint problem004(in uint digit)
{
    immutable minimum = 10 ^^ (digit - 1);
    immutable maximum = 10 ^^ digit;
    foreach (palindrome; PalindromeSequence(digit * 2).retro())
    {
        if (counting[minimum .. maximum]
            .where!(x => palindrome % x == 0)
            .select!(x => palindrome / x)
            .any!(x => minimum <= x && x < maximum))
            return palindrome;
    }
    assert(false);
}

unittest
{
    assert(problem004(2) == 9009);
    assert(problem004(3) == 906609);
}
