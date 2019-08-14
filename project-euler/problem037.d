/// Problem 37: 切り詰め可能素数
///
/// 3797 は面白い性質を持っている。
/// まずそれ自身が素数であり、左から右に桁を除いたときに全て素数になっている。
/// -----
///  3797 797 97 7
/// -----
///
/// 同様に右から左に桁を除いたときも全て素数である。
/// -----
///  3797 379 37 3
/// -----
///
/// 右から切り詰めても左から切り詰めても素数になるような素数は 11 個しかない。総和を求めよ。
/// ただし、2、3、5、7 を切り詰め可能な素数とは考えない。
module project_euler.problem037;

import system.linq : block, sum, Yield;
import project_euler.foundation : PrimeSequence;

private bool isLeftToRightTruncatablePrime(in uint prime)
{
    auto mod = 10;
    while (mod * 10 <= prime)
    {
        mod *= 10;
    }
    uint local = prime;
    do
    {
        local %= mod;
        mod /= 10;
        if (!PrimeSequence.isPrime(local))
            return false;
    } while (local >= 10);
    return true;
}

unittest
{
    assert(isLeftToRightTruncatablePrime(97));
    assert(isLeftToRightTruncatablePrime(797));
    assert(isLeftToRightTruncatablePrime(3797));
    assert(!isLeftToRightTruncatablePrime(3297));
}

private bool isRightToLeftTruncatablePrime(in uint prime)
{
    uint local = prime;
    do
    {
        local /= 10;
        if (!PrimeSequence.isPrime(local))
            return false;
    } while (local >= 10);
    return true;
}

unittest
{
    assert(isRightToLeftTruncatablePrime(37));
    assert(isRightToLeftTruncatablePrime(379));
    assert(isRightToLeftTruncatablePrime(3797));
    assert(!isRightToLeftTruncatablePrime(3297));
}

uint problem037()
{
    void iterationBlock(Yield!uint yield)
    {
        size_t count = 0;
        foreach (prime; PrimeSequence.init)
        {
            if (isLeftToRightTruncatablePrime(prime) &&
                isRightToLeftTruncatablePrime(prime))
            {
                yield = prime;
                ++count;
                if (count == 11)
                    return;
            }
        }
    }
    return block!iterationBlock.sum(0U);
}

unittest
{
    assert(problem037() == 748317);
}
