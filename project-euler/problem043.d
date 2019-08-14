/// Problem 43: 部分列被整除性
/// 
/// 数 1406357289 は 0 から 9 のパンデジタル数である。
/// d1 を上位 1 桁目、d2 を上位 2 桁目の数とし、以下順に dn を定義する。
/// この記法を用いると次のことが分かる。
/// d2d3d4=406 は 2 で割り切れる
/// d3d4d5=063 は 3 で割り切れる
/// d4d5d6=635 は 5 で割り切れる
/// d5d6d7=357 は 7 で割り切れる
/// d6d7d8=572 は 11 で割り切れる
/// d7d8d9=728 は 13 で割り切れる
/// d8d9d10=289 は 17 で割り切れる
/// このような性質をもつ 0 から 9 のパンデジタル数の総和を求めよ。
module project_euler.problem043;

import system.linq : aggregate, permutations, select, sum, where;

ulong problem043()
{
    // パラメータ pandigital は d6 を除く [d1, d2, d3, d4, d5, d7, d8, d9, d10] を格納している
    static bool predicate(in uint[] pandigital, in uint d6)
    in
    {
        assert(pandigital.length == 9);
    }
    body
    {
        // 可読性のために dn という構文でアクセスできるようなプロキシ構造体を定義
        // 配列は with 文で使用できないため、配列に対する UFCS では実現できない
        struct Pandigital
        {
            private const(uint)[] _source;
            @property uint d2 () const { return _source[1]; }
            @property uint d3 () const { return _source[2]; }
            @property uint d4 () const { return _source[3]; }
            @property uint d5 () const { return _source[4]; }
            @property uint d7 () const { return _source[5]; }
            @property uint d8 () const { return _source[6]; }
            @property uint d9 () const { return _source[7]; }
            @property uint d10() const { return _source[8]; }
        }
        with (Pandigital(pandigital))
        {
            // 2 で割り切れる
            if (d4 % 2 != 0)
                return false;
            // 3 で割り切れる
            if ((d3 * 100 + d4 * 10 + d5) % 3 != 0)
                return false;
            // 7 で割り切れる
            if ((d5 * 100 + d6 * 10 + d7) % 7 != 0)
                return false;
            // 11 で割り切れる
            if ((d6 * 100 + d7 * 10 + d8) % 11 != 0)
                return false;
            // 13 で割り切れる
            if ((d7 * 100 + d8 * 10 + d9) % 13 != 0)
                return false;
            // 17 で割り切れる
            if ((d8 * 100 + d9 * 10 + d10) % 17 != 0)
                return false;
            return true;
        }
    }
    alias decode = aggregate!("a * 10 + b", "a", const(uint)[]);
    // d6 は必ず 0 または 5 になるので、それを利用して枝刈りする
    return [1U, 2, 3, 4, 5, 6, 7, 8, 9].permutations.where!(x => predicate(x, 0)).select!decode.sum(0UL)
         + [0U, 1, 2, 3, 4, 6, 7, 8, 9].permutations.where!(x => predicate(x, 5)).select!decode.sum(0UL);
}

unittest
{
    assert(problem043() == 16695334890);
}
