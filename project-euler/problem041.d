/// Problem 41: パンデジタル素数
/// 
/// n 桁パンデジタルであるとは、1 から n までの数を各桁に 1 つずつ持つこととする。
/// 例えば 2143 は 4 桁パンデジタル数であり、かつ素数である。
/// n 桁パンデジタルな素数の中で最大の数を答えよ。
module project_euler.problem041;

import system.linq : aggregate, permutations;
import project_euler.foundation : PrimeSequence;

uint problem041()
{
    // -----
    // 1 + 2                             % 3 == 0
    // 1 + 2 + 3                         % 3 == 0
    // 1 + 2 + 3 + 4                     % 3 != 0
    // 1 + 2 + 3 + 4 + 5                 % 3 == 0
    // 1 + 2 + 3 + 4 + 5 + 6             % 3 == 0
    // 1 + 2 + 3 + 4 + 5 + 6 + 7         % 3 != 0
    // 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8     % 3 == 0
    // 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 % 3 == 0
    // -----
    // 上記表より、n=4 と n=7 のみ調べればよい (他は必ず 3 で割り切れるため素数とならない)
    foreach (pandigital; [7, 6, 5, 4, 3, 2, 1].permutations!"a > b")
    {
        immutable value = pandigital.aggregate!"a * 10 + b";
        if (PrimeSequence.isProbablePrime(value))
            return value;
    }
    assert(false);
}

unittest
{
    assert(problem041() == 7652413);
}
