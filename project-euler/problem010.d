/// Problem 10: 素数の和
///
/// 10 以下の素数の和は 2 + 3 + 5 + 7 = 17 である。
/// 200 万以下の全ての素数の和を求めよ。
module project_euler.problem010;

import system.linq : convert, sum, takeWhile;
import project_euler.foundation : PrimeSequence;

ulong problem010(in uint upper)
{
    return PrimeSequence.init.takeWhile!(x => x <= upper).convert!ulong.sum;
}

unittest
{
    assert(problem010(10) == 17);
    assert(problem010(200_0000) == 142913828922);
}
