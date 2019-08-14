/// Problem 29: 個別のべき乗
///
/// 2 <= a <= 5 と 2 <= b <= 5について、a^b を全て考える。
/// -----
/// 2^2=4,  2^3=8,   2^4=16,  2^5=32
/// 3^2=9,  3^3=27,  3^4=81,  3^5=243
/// 4^2=16, 4^3=64,  4^4=256, 4^5=1024
/// 5^2=25, 5^3=125, 5^4=625, 5^5=3125
/// -----
///
/// これらを小さい順に並べ、同じ数を除いたとすると、15 個の項を得る。
/// -----
/// 4, 8, 9, 16, 25, 27, 32, 64, 81, 125, 243, 256, 625, 1024, 3125
/// -----
///
/// 2 <= a <= 100 と 2 <= b <= 100 で同じことをしたときいくつの異なる項が存在するか。
module project_euler.problem029;

import std.bigint : BigInt;
import system.core : Nothing;
import system.linq : counting;

size_t problem029(in uint lower, uint upper)
{
    Nothing[BigInt] memo;
    foreach (a; counting!"[]"[lower .. upper])
    foreach (b; counting!"[]"[lower .. upper])
    {
        memo[BigInt(a) ^^ b] = Nothing.init;
    }
    return memo.length;
}

unittest
{
    assert(problem029(2, 5) == 15);
    assert(problem029(2, 100) == 9183);
}
