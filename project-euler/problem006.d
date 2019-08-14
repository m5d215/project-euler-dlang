/// Problem 6: 二乗和の差
///
/// 最初の 10 個の自然数について、その二乗の和は 1^2 + 2^2 + ... + 10^2 = 385。
/// 最初の 10 個の自然数について、その和の二乗は (1 + 2 + ... + 10)^2 = 3025。
/// これらの数の差は 3025 - 385 = 2640 となる。
/// 同様にして、最初の 100 個の自然数について二乗の和と和の二乗の差を求めよ。
module project_euler.problem006;

import system.functional : buildFunction;
import system.linq : counting, select, sum;

uint problem006(in uint upper)
in
{
    assert(upper >= 1);
}
body
{
    alias square = buildFunction!"a * a";
    auto range = counting!"[]"[1 .. upper];
    return square(range.sum) - range.select!square.sum;
}

unittest
{
    assert(problem006(10) == 2640);
    assert(problem006(100) == 25164150);
}
