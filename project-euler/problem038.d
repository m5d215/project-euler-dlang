/// Problem 38: パンデジタル倍数
///
/// 192 に 1、2、3 を掛けてみよう。
/// -----
/// 192 * 1 = 192
/// 192 * 2 = 384
/// 192 * 3 = 576
/// -----
///
/// 積を連結することで 1 から 9 のパンデジタル数 192384576 が得られる。
/// 192384576 を 192 と (1, 2, 3) の連結積と呼ぶ。
/// 同じようにして、9 を 1、2、3、4、5 と掛け連結することでパンデジタル数 918273645 が得られる。
/// これは 9 と (1, 2, 3, 4, 5) との連結積である。
/// 整数と (1, 2, ..., n) (n > 1) との連結積として得られる 9 桁のパンデジタル数の中で最大のものはいくつか。
module project_euler.problem038;

import system.linq : aggregate, counting, infinity, permutations;
import project_euler.foundation : decimalLength;

private alias toUInt = aggregate!((x, y) => x * 10 + y, x => x, const(uint)[]);

uint problem038()
{
    enum uint[] digits = [9, 8, 7, 6, 5, 4, 3, 2, 1];
    foreach (pandigital; digits.permutations!"a > b")
    {
        foreach (baseWidth; counting!"[]"[2 .. pandigital.length / 2])
        {
            immutable base = pandigital[0 .. baseWidth].toUInt();
            size_t offset = baseWidth;
            foreach (n; counting[2 .. infinity])
            {
                immutable value = base * n;
                immutable i = offset + decimalLength(value);
                if (i > pandigital.length || pandigital[offset .. i].toUInt() != value)
                    break;
                if (i == pandigital.length)
                    return pandigital.toUInt();
                offset = i;
            }
        }
    }
    assert(false);
}

unittest
{
    // 9327 * 1 = 9327
    // 9327 * 2 = 18654
    assert(problem038() == 932718654);
}
