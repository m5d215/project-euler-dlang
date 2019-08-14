/// Problem 1: 3 と 5 の倍数
///
/// 10未満の自然数のうち、3 もしくは 5 の倍数になっているものは 3、5、6、9 の 4 つがあり、これらの合計は 23 になる。
/// 同じようにして、1000 未満の 3 か 5 の倍数になっている数字の合計を求めよ。
module project_euler.problem001;

import system.linq : counting, sum, where;

uint problem001(in uint upper)
in
{
    assert(upper >= 1);
}
body
{
    return counting[1 .. upper].where!(x => x % 3 == 0 || x % 5 == 0).sum;
}

unittest
{
    assert(problem001(10) == 23);
    assert(problem001(1000) == 233168);
}
