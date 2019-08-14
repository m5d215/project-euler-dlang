/// Problem 14: 最長のコラッツ数列
///
/// 正の整数に以下の式で繰り返し生成する数列を定義する。
/// -----
/// n -> n/2 (n が偶数)
/// n -> 3n + 1 (n が奇数)
/// -----
///
/// 13 からはじめるとこの数列は以下のようになる。
/// -----
/// 13 -> 40 -> 20 -> 10 -> 5 -> 16 -> 8 -> 4 -> 2 -> 1
/// -----
///
/// 13 から 1 まで 10 個の項になる。
/// この数列はどのような数字からはじめても最終的には 1 になると考えられているが、まだそのことは証明されていない。(コラッツ問題)
/// さて、100 万未満の数字の中でどの数字からはじめれば最長の数列を生成するか。
/// 注意: 数列の途中で 100 万以上になってもよい
module project_euler.problem014;

private uint collatz(in uint value)
{
    if (value % 2 == 0)
    {
        return value / 2;
    }
    else
    {
        return value * 3 + 1;
    }
}

uint problem014(in uint upper)
{
    uint[] memo = new uint[upper];
    enum uint uninitialized = 0;
    enum uint initialized = 1;
    uint maximumValue = 0;
    size_t maximumLength = 0;
    foreach (n; 1U .. upper)
    {
        if (memo[n] != uninitialized)
            continue;
        uint local = n;
        size_t length = 0;
        do
        {
            local = collatz(local);
            ++length;
            if (local < upper)
            {
                if (memo[local] == uninitialized)
                {
                    memo[local] = initialized;
                }
                else if (memo[local] != initialized)
                {
                    length += memo[local];
                    break;
                }
            }
        } while (local != 1);
        memo[n] = cast(uint)length;
        if (length > maximumLength)
        {
            maximumValue = n;
            maximumLength = length;
        }
    }
    return maximumValue;
}

unittest
{
    assert(problem014(100_0000) == 837799);
}
