/// Problem 5: 最小の倍数
///
/// 2520 は 1 から 10 の数字の全ての整数で割り切れる数字であり、そのような数字の中では最小の値である。
/// では、1 から 20 までの整数全てで割り切れる数字の中で最小の正の数はいくらになるか。
module project_euler.problem005;

import system.linq : aggregate, counting, select;
import project_euler.foundation : PrimeFactors;

uint problem005(in uint upper)
in
{
    assert(upper >= 1);
}
body
{
    size_t[uint] primeFactors;
    foreach (n; counting!"[]"[1 .. upper])
    {
        foreach (prime, count; PrimeFactors[n])
        {
            if (prime in primeFactors)
            {
                if (primeFactors[prime] < count)
                {
                    primeFactors[prime] = count;
                }
            }
            else
            {
                primeFactors[prime] = count;
            }
        }
    }
    return primeFactors
        .keys
        .select!(prime => prime ^^ cast(uint)primeFactors[prime])
        .aggregate!"a * b";
}

unittest
{
    assert(problem005(10) == 2520);
    assert(problem005(20) == 232792560);
}
