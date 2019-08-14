/// Problem 7: 10001 番目の素数
///
/// 素数を小さい方から 6 つ並べると 2、3、5、7、11、13 であり、6 番目の素数は 13 である。
/// 10001 番目の素数を求めよ。
module project_euler.problem007;

import project_euler.foundation : PrimeSequence;

uint problem007(in size_t nth)
in
{
    assert(nth >= 1);
}
body
{
    return PrimeSequence.init[nth - 1];
}

unittest
{
    assert(problem007(6) == 13);
    assert(problem007(10001) == 104743);
}
