/// Problem 40: チャンパーノウン定数
/// 
/// 正の整数を順に連結して得られる以下の 10 進の無理数を考える。
/// -----
/// 0.123456789101112131415161718192021...
/// -----
/// 小数第 12 位は 1 である。
/// 
/// d[n] で小数第 n 位の数を表す。
/// d[1] * d[10] * d[100] * d[1000] * d[10000] * d[100000] * d[1000000] を求めよ。
module project_euler.problem040;

import std.conv : to;
import system.linq : aggregate, block, counting, infinity, Yield;
import project_euler.foundation : asDigit, decimalLength;

uint problem040()
{
    void iterationBlock(Yield!uint yield)
    {
        auto points = [1, 10, 100, 1000, 10000, 100000, 1000000];
        size_t offset = 0;
        foreach (n; counting[1 .. infinity])
        {
            immutable length = decimalLength(n);
            if (offset + length >= points[0])
            {
                yield = to!string(n)[points[0] - offset - 1].asDigit;
                points = points[1 .. $];
                if (points.length == 0)
                    return;
            }
            offset += length;
        }
    }
    return block!iterationBlock.aggregate!"a * b"(1U);
}

unittest
{
    assert(problem040() == 210);
}
