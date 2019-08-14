/// Problem 39: 整数の直角三角形
///
/// 辺の長さが {a, b, c} と整数の 3 つ組である直角三角形を考え、その周囲の長さを p とする。
/// p = 120 のときには 3 つの解が存在する。
/// -----
/// {20, 48, 52}
/// {24, 45, 51}
/// {30, 40, 50}
/// -----
///
/// p <= 1000 のとき解の数が最大になる p はいくつか。
module project_euler.problem039;

import std.math : sqrt;
import std.range : assumeSorted;
import system.linq : counting, maximum, select, toArray;

uint problem039(in uint upper)
{
    auto squares = assumeSorted(counting[1 .. upper].select!"a * a".toArray);
    size_t[uint] count;
    foreach (a; 1 .. upper / 2)
    foreach (b; a .. upper)
    {
        // c (斜辺) が一番長くなる
        if (a + b > upper / 2)
            break;
        immutable cc = a * a + b * b;
        if (squares.contains(cc))
        {
            static import std.math;
            immutable p = a + b + cast(uint)sqrt(cast(real)cc);
            if (p <= upper)
            {
                ++count[p];
            }
        }
    }
    return count.keys.maximum!((x, y) => count[x] < count[y]);
}

unittest
{
    assert(problem039(1000) == 840);
}
