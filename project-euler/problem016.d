/// Problem 16: べき乗の数字和
///
/// 2^15 = 32768 であり、これの各桁の和は 3 + 2 + 7 + 6 + 8 = 26 となる。
/// 同様にして、2^1000 の数字和を求めよ。
module project_euler.problem016;

import std.bigint : BigInt, toDecimalString;
import system.linq : select, sum;
import project_euler.foundation : asDigit;

uint problem016(in uint exponent)
{
    return toDecimalString(BigInt(2) ^^ exponent).select!asDigit.sum;
}

unittest
{
    assert(problem016(15) == 26);
    assert(problem016(1000) == 1366);
}
