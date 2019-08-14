/// Problem 28: 螺旋状に並んだ数の対角線
///
/// 1 から初めて右方向に進み時計回りに数字を増やしていき、5x5 の螺旋が以下のように生成される。
/// -----
/// 21 22 23 24 25
/// 20  7  8  9 10
/// 19  6  1  2 11
/// 18  5  4  3 12
/// 17 16 15 14 13
/// -----
///
/// 両対角線上の数字の合計は 101 であることが確かめられる。
/// -----
/// 21 + 7 + (1) + 3 + 13 = 45
/// 25 + 9 + (1) + 5 + 17 = 57
/// 45 + 57 - 1 = 101 // 真ん中の 1 が 2 回加算されているので引く
/// -----
/// 1001x1001 の螺旋を同じ方法で生成したとき、対角線上の数字の和はいくつか。
module project_euler.problem028;

import system.linq : block, sum, Yield;

ulong problem028(in uint size)
in
{
    assert(size % 2 != 0);
}
body
{
    void iterationBlock(Yield!uint yield)
    {
        auto value = 1U;
        yield = value;
        for (auto step = 2; value != size * size; step += 2)
        {
            version(none)
            {
                foreach (_; 0 .. 4)
                {
                    value += step;
                    yield = value;
                }
            }
            else
            {
                // 四隅の値の和をまとめて生成することで yield の回数を減らす
                yield = value * 4 + step * 10;
                value += step * 4;
            }
        }
    }
    return block!iterationBlock.sum(0UL);
}

unittest
{
    assert(problem028(5) == 101);
    assert(problem028(1001) == 669171001);
}
