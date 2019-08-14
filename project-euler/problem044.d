/// Problem 44: 五角数
/// 
/// 五角数は P[n] = n(3n-1)/2 で生成され、最初の10項は
/// -----
/// 1, 5, 12, 22, 35, 51, 70, 92, 117, 145, ...
/// -----
/// 
/// P[4] + P[7] = 22 + 70 = 92 = P[8] である。
/// しかし差 70 - 22 = 48 は五角数ではない。
/// 
/// 五角数のペア P[j] と P[k] について、差と和が五角数になるものを考える。
/// 差を D = |P[k] - P[j]| と書く。
/// 差 D の最小値を求めよ。
module project_euler.problem044;

import std.range : assumeSorted;
import std.traits : Parameters, Unqual;
import system.functional;
import system.linq;

ulong problem044()
{
    alias pentagonal = buildFunction!"a * (3 * a - 1) / 2";
    bool isPentagonal(in uint value)
    {
        uint lower = 1;
        version(none)
        {
            uint upper = value;
        }
        else
        {
            import std.math : sqrt;
            uint upper = 3 * cast(uint)sqrt(cast(real)value);
        }
        while (true)
        {
            immutable n = upper - lower;
            enum threshold = 8;
            if (n < threshold)
            {
                foreach (i; lower .. upper)
                {
                    if (pentagonal(i) == value)
                        return true;
                }
                return false;
            }
            else
            {
                immutable pivot = lower + n / 4;
                if (pentagonal(pivot) < value)
                {
                    lower = pivot;
                }
                else if (pentagonal(pivot) > value)
                {
                    upper = pivot;
                }
                else
                {
                    return true;
                }
            }
        }
    }
    // i |  1|  2|  3|  4|  5|  6|  7|  8| ...
    // --|---|---|---|---|---|---|---|---|----
    // P |  1|  5| 12| 22| 35| 51| 70| 92| ...
    // --|---|---|---|---|---|---|---|---|----
    // jk|  1|  2|  3|  4|  5|  6|  7|  8| ...
    // --|---|---|---|---|---|---|---|---|----
    // 1 |  0|  4| 11| 21| 34| 50| 69| 91| ...
    // 2 | x |  0|  7| 17| 30| 46| 65| 87| ...
    // 3 | x | x |  0| 10| 23| 39| 58| 80| ...
    // 4 | x | x | x |  0| 13| 29| 48| 70| ...
    // 5 | x | x | x | x |  0| 16| 35| 57| ...
    // 6 | x | x | x | x | x |  0| 19| 41| ...
    // 7 | x | x | x | x | x | x |  0| 22| ...
    // 8 | x | x | x | x | x | x | x |  0| ...
    foreach (k; counting[2 .. infinity])
    {
        immutable pk = pentagonal(k);
        foreach_reverse (j; 1 .. k)
        {
            immutable pj = pentagonal(j);
            if (!isPentagonal(pk + pj))
                continue;
            immutable d = pk - pj;
            if (isPentagonal(d))
                return d;
        }
    }
}

unittest
{
    assert(problem044() == 5482660);
}
