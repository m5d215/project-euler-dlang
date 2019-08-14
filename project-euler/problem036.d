/// Problem 36: 二種類の基数による回文数
///
/// 585 = 10010010012 (2進) は 10 進でも 2 進でも回文数である。
/// 100 万未満で 10 進でも 2 進でも回文数になるような数の総和を求めよ。
/// ただし、先頭に 0 を含めて回文にすることは許されない。
module project_euler.problem036;

import std.conv : to;
import system.linq : concat, sum, where;
import project_euler.foundation : PalindromeSequence;

uint problem036()
{
    static bool isBinaryPalindrome(in uint value)
    {
        immutable binary = to!string(value, 2);
        foreach (i, c; binary[0 .. $ / 2])
        {
            if (c != binary[$ - i - 1])
                return false;
        }
        return true;
    }
    auto decimalPalindromes = concat(
        PalindromeSequence(1),
        PalindromeSequence(2),
        PalindromeSequence(3),
        PalindromeSequence(4),
        PalindromeSequence(5),
        PalindromeSequence(6)
    );
    return decimalPalindromes.where!isBinaryPalindrome.sum(0U);
}

unittest
{
    assert(problem036() == 872187);
}
