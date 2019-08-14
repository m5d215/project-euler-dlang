/// Problem 15: 格子経路
///
/// 2x2 のマス目の左上からスタートした場合、引き返しなしで右下にいくルートは 6 つある。
/// では、20x20 のマス目ではいくつのルートがあるか。
module project_euler.problem015;

import std.functional : memoize;

ulong problem015(in uint size)
{
    static ulong route(in uint x, in uint y)
    {
        if (x == 0 && y == 0)
            return 1;
        if (x == 0)
            return memoize!route(x, y - 1);
        if (y == 0)
            return memoize!route(x - 1, y);
        else
            return memoize!route(x - 1, y) + memoize!route(x, y - 1);
    }
    return route(size, size);
}

unittest
{
    assert(problem015(2) == 6);
    assert(problem015(20) == 137846528820);
}
