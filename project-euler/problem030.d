/// Problem 30: 各桁の 5 乗
///
/// 驚くべきことに、各桁を 4 乗した数の和が元の数と一致する数は 3 つしかない。
/// -----
/// 1634 = 1^4 + 6^4 + 3^4 + 4^4
/// 8208 = 8^4 + 2^4 + 0^4 + 8^4
/// 9474 = 9^4 + 4^4 + 7^4 + 4^4
/// -----
///
/// ただし、1=1^4 は含まないものとする。
/// この数たちの和は 1634 + 8208 + 9474 = 19316 である。
/// 各桁を 5 乗した数の和が元の数と一致するような数の総和を求めよ。
module project_euler.problem030;

import system.linq : counting, first, infinity, select, sum, where;

uint problem030(in uint exponent)
{
    static uint eachpow(in uint value, in uint exponent)
    {
        uint sum = 0;
        uint local = value;
        do
        {
            sum += (local % 10) ^^ exponent;
            local /= 10;
        } while (local != 0);
        return sum;
    }
    version(unittest)
    {
        assert(eachpow(1634, 4) == 1634);
        assert(eachpow(8208, 4) == 8208);
        assert(eachpow(9474, 4) == 9474);
    }
    // 999999... >= eachpow(999999..., exponent) となる最小の 999999... を取得
    immutable maximum =
        counting[1 .. infinity]
        .select!(x => 10 ^^ x - 1)
        .first!(x => x >= eachpow(x, exponent));
    return counting[2U .. maximum].where!(x => x == eachpow(x, exponent)).sum(0U);
}

unittest
{
    assert(problem030(4) == 19316);
    assert(problem030(5) == 443839);
}
