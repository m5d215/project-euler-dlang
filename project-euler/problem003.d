/// Problem 3: 最大の素因数
///
/// 13195 の素因数は 5、7、13、29 である。
/// 600851475143 の素因数のうち最大のものを求めよ。
module project_euler.problem003;

import system.linq : maximum;
import project_euler.foundation : PrimeFactors;

uint problem003(in ulong value)
in
{
    assert(value >= 1);
}
body
{
    return PrimeFactors[value].keys.maximum;
}

unittest
{
    assert(problem003(13195) == 29);
    assert(problem003(600851475143) == 6857);
}
