/// Problem 25: 1000 桁のフィボナッチ数
///
/// フィボナッチ数列は以下の漸化式で定義される。
/// -----
/// F[1] = 1
/// F[2] = 1
/// F[n] = F[n-1] + F[n-2]
/// -----
///
/// 最初の 12 項は以下である。
/// -----
/// F[1] = 1
/// F[2] = 1
/// F[3] = 2
/// F[4] = 3
/// F[5] = 5
/// F[6] = 8
/// F[7] = 13
/// F[8] = 21
/// F[9] = 34
/// F[10] = 55
/// F[11] = 89
/// F[12] = 144
/// -----
///
/// 12番目の項、F[12] が 3 桁になる最初の項である。
/// 1000 桁になる最初の項の番号を答えよ。
module project_euler.problem025;

import std.bigint : BigInt, toDecimalString;
import std.range : enumerate, recurrence;

size_t problem025(in uint digits)
{
    foreach (i, fib; recurrence!"a[n - 1] + a[n - 2]"(BigInt(1), BigInt(1)).enumerate)
    {
        if (toDecimalString(fib).length >= digits)
            return i + 1;
    }
}

unittest
{
    assert(problem025(3) == 12);
    assert(problem025(1000) == 4782);
}
