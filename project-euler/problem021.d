/// Problem 21: 友愛数
///
/// d(n) を n の真の約数の和と定義する。
/// 真の約数とは n 以外の約数のことである。
/// もし、d(a) = b かつ d(b) = a を満たすとき、a と b は友愛数(親和数)であるという。
/// 例えば、220 の約数は 1、2、4、5、10、11、20、22、44、55、110 なので d(220) = 284 である。
/// また、284 の約数は 1、2、4、71、142 なので d(284) = 220 である。
/// それでは 10000 未満の友愛数の和を求めよ。
module project_euler.problem021;

import system.linq : counting, sum, where;
import project_euler.foundation : Divisors;

ulong problem021(in uint upper)
{
    static ulong d(in ulong n)
    {
        return Divisors[n][0 .. $ - 1].sum(0UL);
    }
    assert(d(220) == 284);
    assert(d(284) == 220);
    static bool isAmicableNumber(in ulong a)
    {
        immutable b = d(a);
        // d(6) == 6 など、a == b となるケースを除外
        return b != a && d(b) == a;
    }
    return counting[2 .. upper].where!isAmicableNumber.sum(0UL);
}

unittest
{
    assert(problem021(10000) == 31626);
}
