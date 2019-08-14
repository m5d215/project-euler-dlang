/// Problem 31: 硬貨の和
///
/// イギリスでは硬貨はポンドとペンスがあり、一般的に流通している硬貨は以下の 8 種類である。
/// -----
/// 1, 2, 5, 10, 20, 50, 100, 200
/// -----
///
/// これらの硬貨を使って 200 を作る方法は何通りあるか。
module project_euler.problem031;

import std.functional : memoize;

size_t problem031(in uint target)
{
    // target の計算に不要なコインを除外する
    static immutable(uint)[] optimize(in immutable(uint)[] coins, in uint target)
    {
        foreach_reverse (i, coin; coins)
        {
            if (coin <= target)
                return coins[0 .. i + 1];
        }
        return [];
    }
    static size_t exchange(in immutable(uint)[] coins, in uint target)
    {
        if (target == 0)
            return 1;
        if (coins.length == 0)
            return 0;
        if (coins[$ - 1] == target)
            return 1 + memoize!exchange(coins[0 .. $ - 1], target);
        size_t count = 0;
        foreach_reverse (i, coin; optimize(coins, target))
        {
            count += memoize!exchange(coins[0 .. i + 1], target - coin);
        }
        return count;
    }
    enum uint[] coins = [1, 2, 5, 10, 20, 50, 100, 200];
    return exchange(optimize(coins, target), target);
}

unittest
{
    // [1]
    assert(problem031(1) == 1);
    // [1, 1], [2]
    assert(problem031(2) == 2);
    // [1, 1, 1], [1, 2]
    assert(problem031(3) == 2);
    // [1, 1, 1, 1], [1, 1, 2], [2, 2]
    assert(problem031(4) == 3);
    // [1, 1, 1, 1, 1], [1, 1, 1, 2], [1, 2, 2], [5]
    assert(problem031(5) == 4);
    assert(problem031(200) == 73682);
}
