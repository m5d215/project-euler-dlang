/// Problem 20: 階乗の数字和
///
/// 10! = 3628800 の各桁の合計は 3 + 6 + 2 + 8 + 8 + 0 + 0 = 27 である。
/// では、100! の各桁の数字の和を求めよ。
module project_euler.problem020;

import std.bigint : BigInt, toDecimalString;
import system.linq : aggregate, counting, select, sum;
import project_euler.foundation : asDigit;

uint problem020(in uint value)
{
    return toDecimalString(counting!"[]"[2 .. value].aggregate!"a * b"(BigInt(1))).select!asDigit.sum;
}

unittest
{
    assert(problem020(10) == 27);
    assert(problem020(100) == 648);
}
