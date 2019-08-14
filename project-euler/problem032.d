/// Problem 32: パンデジタル積
///
/// すべての桁に 1 から n が一度だけ使われている数を n 桁の数がパンデジタル (pandigital) であるということにしよう。
/// 例えば 5 桁の数 15234 は 1 から 5 のパンデジタルである。
/// 7254 は面白い性質を持っている。
/// 39 x 186 = 7254 と書け、掛けられる数、掛ける数、積が 1 から 9 のパンデジタルとなる。
/// 掛けられる数/掛ける数/積が 1 から 9 のパンデジタルとなるような積の総和を求めよ。
/// ただし、いくつかの積は 1 通り以上の掛けられる数/掛ける数/積の組み合わせを持つが 1 回だけ数え上げよ。
module project_euler.problem032;

import system.linq : block, counting, distinct, permutations, sum, Yield;

ulong problem032()
{
    // -----
    //    # x       # = ####### | x
    //    # x      ## =  ###### | x
    //    # x     ### =   ##### | x
    //    # x    #### =    #### | o
    //    # x   ##### =     ### | x
    //    # x  ###### =      ## | x
    //    # x ####### =       # | x
    //   ## x      ## =   ##### | x
    //   ## x     ### =    #### | o
    //   ## x    #### =     ### | x
    //   ## x   ##### =      ## | x
    //   ## x  ###### =       # | x
    //  ### x     ### =     ### | x
    //  ### x    #### =      ## | x
    //  ### x   ##### =       # | x
    // #### x    #### =       # | x
    // -----
    // 上記表より、以下の 2 通りの掛け算を試せばよい
    // * 1 桁 x 4 桁 = 4 桁
    // * 2 桁 x 3 桁 = 4 桁
    enum multiplications =
    [
        [1, 4, 4],
        [2, 3, 4],
    ];
    static uint toDigits(in uint[] source)
    {
        uint value = 0;
        foreach (digit; source)
        {
            value *= 10;
            value += digit;
        }
        return value;
    }
    void iterationBlock(Yield!uint yield)
    {
        foreach (combi; counting!"[]"[1U .. 9U].permutations)
        foreach (multiplication; multiplications)
        {
            immutable i = multiplication[0];
            immutable ii = i + multiplication[1];
            immutable left = toDigits(combi[0 .. i]);
            immutable right = toDigits(combi[i .. ii]);
            immutable result = toDigits(combi[ii .. $]);
            if (left * right == result)
            {
                yield = result;
            }
        }
    }
    return block!iterationBlock.distinct.sum(0UL);
}

unittest
{
    assert(problem032() == 45228);
}
