/// Problem 35: 巡回素数
///
/// 197 は巡回素数と呼ばれる。
/// 桁を回転させたときに得られる数 197、971、719 が全て素数だからである。
/// 100未満には巡回素数が13個ある。
/// -----
/// 2, 3, 5, 7, 11, 13, 17, 31, 37, 71, 73, 79, 97
/// -----
/// 100 万未満の巡回素数はいくつあるか。
module project_euler.problem035;

import std.algorithm : bringToFront;
import std.conv : to;
import system.linq : count, takeWhile;
import project_euler.foundation : PrimeSequence;

size_t problem035(in uint upper)
{
    static bool isCircularPrime(in uint prime)
    {
        if (prime == 2)
            return true;
        immutable containsEven =
        {
            uint local = prime;
            do
            {
                if (local % 2 == 0)
                    return true;
                local /= 10;
            } while (local != 0);
            return false;
        }();
        if (containsEven)
            return false;
        auto s = to!(dchar[])(prime);
        foreach (i; 0 .. s.length)
        {
            bringToFront(s[0 .. 1], s[1 .. $]);
            if (!PrimeSequence.isPrime(to!uint(s)))
                return false;
        }
        foreach (i; 0 .. s.length - 1)
        {
            bringToFront(s[1 .. $], s[0 .. 1]);
            if (!PrimeSequence.isPrime(to!uint(s)))
                return false;
        }
        return true;
    }
    version(unittest)
    {
        assert(isCircularPrime(2));
        assert(isCircularPrime(3));
        assert(isCircularPrime(5));
        assert(isCircularPrime(7));
        assert(isCircularPrime(11));
        assert(isCircularPrime(13));
        assert(isCircularPrime(17));
        assert(isCircularPrime(31));
        assert(isCircularPrime(37));
        assert(isCircularPrime(71));
        assert(isCircularPrime(73));
        assert(isCircularPrime(79));
        assert(isCircularPrime(97));
    }
    return PrimeSequence.init.takeWhile!(x => x < upper).count!isCircularPrime;
}

unittest
{
    assert(problem035(100) == 13);
    assert(problem035(100_0000) == 55);
}
