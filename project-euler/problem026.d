/// Problem 26: 逆数の循環節 その 1
///
/// 単位分数とは分子が 1 の分数である。
/// 分母が 2 から 10 の単位分数を 10 進数で表記すると次のようになる。
/// -----
/// 1/2 = 0.5
/// 1/3 = 0.(3)
/// 1/4 = 0.25
/// 1/5 = 0.2
/// 1/6 = 0.1(6)
/// 1/7 = 0.(142857)
/// 1/8 = 0.125
/// 1/9 = 0.(1)
/// 1/10 = 0.1
/// -----
///
/// 0.1(6)は 0.166666... という数字であり、1 桁の循環節を持つ。
/// 1/7 の循環節は 6 桁ある。
/// d < 1000 なる 1/d の中で小数部の循環節が最も長くなるような d を求めよ。
module project_euler.problem026;

import std.functional : memoize;
import system.linq : counting, maximum;

uint problem026(in uint upper)
{
    static size_t repetend(in uint d)
    {
        size_t[uint] memo;
        uint numerator = 1;
        for (size_t i = 0; true; ++i)
        {
            if (numerator < d)
            {
                memo[numerator] = i;
            }
            else
            {
                numerator %= d;
                if (numerator == 0)
                    return 0;
                if (numerator in memo)
                {
                    return i - memo[numerator];
                }
                memo[numerator] = i;
            }
            numerator *= 10;
        }
    }
    version(unittest)
    {
        assert(repetend(2) == 0);
        assert(repetend(3) == 1);
        assert(repetend(4) == 0);
        assert(repetend(5) == 0);
        assert(repetend(6) == 1);
        assert(repetend(7) == 6);
        assert(repetend(8) == 0);
        assert(repetend(9) == 1);
    }
    return counting[2 .. upper].maximum!((x, y) => memoize!repetend(x) < memoize!repetend(y));
}

unittest
{
    assert(problem026(7) == 3);
    assert(problem026(8) == 7);
    assert(problem026(9) == 7);
    assert(problem026(1000) == 983);
}
