/// Problem 27: 二次式素数
///
/// オイラーは以下の二次式を考案している。
/// -----
/// n^2 + n + 41
/// -----
///
/// この式は、n を 0 から 39 までの連続する整数としたときに40個の素数を生成する。
/// しかし、n = 40 のとき 40^2 + 40 + 41 = 40(40 + 1) + 41 となり 41 で割り切れる。
/// また、n = 41 のときは 41^2 + 41 + 41 であり明らかに 41 で割り切れる。
///
/// 計算機を用いて、二次式 n^2 - 79n + 1601 という式が発見できた。
/// これは n = 0 から 79 の連続する整数で 80 個の素数を生成する。
/// 係数の積は、-79 x 1601 で -126479である。
///
/// さて、|a| < 1000, |b| < 1000 として以下の二次式を考える。
/// -----
/// n^2 + an + b
/// -----
///
/// n = 0 から始めて連続する整数で素数を生成したときに最長の長さとなる上の二次式の係数 a、b の積を答えよ。
module project_euler.problem027;

import system.linq : counting, infinity, takeWhile;
import project_euler.foundation : PrimeSequence;

private size_t primeLength(in int a, in int b)
{
    size_t i = 0;
    foreach (n; counting[0 .. infinity])
    {
        immutable fn = n * n + a * n + b;
        if (fn < 2 || !PrimeSequence.isPrime(fn))
            return i;
        ++i;
    }
}

unittest
{
    assert(primeLength(1, 41) == 40);
    assert(primeLength(-79, 1601) == 80);
}

int problem027()
{
    int maximumA;
    int maximumB;
    size_t maximumLength;
    // n=0 を考えると、b は必ず素数である必要がある
    foreach (a; counting!"()"[-1000 .. 1000])
    foreach (b; PrimeSequence.init.takeWhile!"a < 1000")
    {
        immutable length = primeLength(a, b);
        if (length > maximumLength)
        {
            maximumA = a;
            maximumB = b;
            maximumLength = length;
        }
    }
    return maximumA * maximumB;
}

unittest
{
    assert(problem027() == -59231);
}
