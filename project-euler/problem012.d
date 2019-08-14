/// Problem 12: 高度整除三角数
///
/// 三角数の数列は自然数の和で表わされ、7 番目の三角数は 1 + 2 + 3 + 4 + 5 + 6 + 7 = 28 である。
/// 三角数の最初の10項は 1、3、6、10、15、21、28、36、45、55、... となる。
///
/// 最初の 7 項について、その約数を列挙すると、以下のとおり。
/// -----
///  1: 1
///  3: 1, 3
///  6: 1, 2, 3, 6
/// 10: 1, 2, 5, 10
/// 15: 1, 3, 5, 15
/// 21: 1, 3, 7, 21
/// 28: 1, 2, 4,  7, 14, 28
/// -----
///
/// これから、7 番目の三角数である 28 は、5 個より多く約数をもつ最初の三角数であることが分かる。
/// では、500 個より多く約数をもつ最初の三角数はいくつか。
///
/// Bugs: performance
module project_euler.problem012;

import system.linq : counting, first, select;
import project_euler.foundation : Divisors;

uint problem012(in uint divisors)
{
    enum triangles = counting[1 .. uint.max].select!(x => (x + 1) * x / 2);
    return triangles.first!(x => Divisors[x].length >= divisors);
}

unittest
{
    assert(problem012(5) == 28);
    assert(problem012(500) == 76576500);
}
