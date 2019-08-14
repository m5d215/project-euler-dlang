/// Problem 23: 非過剰数和
///
/// 完全数とは、その数の真の約数の和がそれ自身と一致する数のことである。
/// たとえば、28 の真の約数の和は、1 + 2 + 4 + 7 + 14 = 28 であるので、28 は完全数である。
/// 真の約数の和がその数よりも少ないものを不足数といい、真の約数の和がその数よりも大きいものを過剰数と呼ぶ。
/// 12 は、1 + 2 + 3 + 4 + 6 = 16 となるので、最小の過剰数である。
/// よって 2 つの過剰数の和で書ける最少の数は24である。
/// 数学的な解析により、28123 より大きい任意の整数は 2 つの過剰数の和で書けることが知られている。
/// 2 つの過剰数の和で表せない最大の数がこの上限よりも小さいことは分かっているのだが、この上限を減らすことが出来ていない。
/// 2 つの過剰数の和で書き表せない正の整数の総和を求めよ。
module project_euler.problem023;

import system.linq : asInputRange, counting, infinity, sum, takeWhile, toArray, where;
import project_euler.foundation : Divisors;

ulong problem023()
{
    static bool isAbundantNumber(in ulong n)
    {
        return Divisors[n][0 .. $ - 1].sum(0UL) > n;
    }
    enum limit = 28123;
    auto abundantNumbers = counting[2U .. infinity].asInputRange.where!isAbundantNumber.takeWhile!(x => x <= limit).toArray;
    auto isAbundantFlags = new bool[limit + 1];
    foreach (i, a; abundantNumbers)
    foreach (b; abundantNumbers[i .. $])
    {
        if (a + b >= isAbundantFlags.length)
            break;
        isAbundantFlags[a + b] = true;
    }
    return counting!"[]"[0 .. limit].where!(x => !isAbundantFlags[x]).sum(0UL);
}

unittest
{
    assert(problem023() == 4179871);
}
