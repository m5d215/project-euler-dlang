/// Problem 34: 桁の階乗
///
/// 145 は面白い数である。
/// -----
/// 1! + 4! + 5! = 1 + 24 + 120 = 145
/// -----
///
/// 各桁の数の階乗の和が自分自身と一致するような数の和を求めよ。
/// ただし、1! = 1 と 2! = 2 は総和に含めてはならない。
module project_euler.problem034;

import std.functional : memoize;
import system.linq : counting, sum, where;

uint problem034()
{
    enum uint[] factorials =
    [
        1,
        1 * 1,
        1 * 1 * 2,
        1 * 1 * 2 * 3,
        1 * 1 * 2 * 3 * 4,
        1 * 1 * 2 * 3 * 4 * 5,
        1 * 1 * 2 * 3 * 4 * 5 * 6,
        1 * 1 * 2 * 3 * 4 * 5 * 6 * 7,
        1 * 1 * 2 * 3 * 4 * 5 * 6 * 7 * 8,
        1 * 1 * 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9,
    ];
    static uint eachFactorial(in uint value)
    {
        if (value < 10)
            return factorials[value];
        else
            return memoize!eachFactorial(value / 10) + factorials[value % 10];
    }
    immutable upper =
    {
        // digit |   upper | eachFactorial |
        // ------|---------|---------------|
        //     1 |       9 |        362880 |
        //     2 |      99 |        725760 |
        //     3 |     999 |       1088640 |
        //     4 |    9999 |       1451520 |
        //     5 |   99999 |       1814400 |
        //     6 |  999999 |       2177280 |
        //     7 | 9999999 |       2540160 |
        uint lower = 999999;
        uint upper = 9999999;
        while (true)
        {
            immutable length = upper - lower;
            if (length < 16)
            {
                return upper;
            }
            else
            {
                immutable pivot = lower + length / 2;
                if (eachFactorial(pivot) < pivot)
                {
                    upper = pivot;
                }
                else
                {
                    lower = pivot;
                }
            }
        }
    }();
    return counting[3U .. upper]
        .where!(x => x == eachFactorial(x))
        .sum;
}

unittest
{
    assert(problem034() == 40730);
}
