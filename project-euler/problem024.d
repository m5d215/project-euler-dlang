/// Problem 24: 辞書式順列
///
/// 順列とはモノの順番付きの並びのことである。
/// たとえば、3124 は数 1、2、3、4 の一つの順列である。
/// すべての順列を数の大小でまたは辞書式に並べたものを辞書順と呼ぶ。
/// 0 と 1 と 2 の順列を辞書順に並べると 012 021 102 120 201 210 になる。
/// 0、1、2、3、4、5、6、7、8、9 からなる順列を辞書式に並べたときの 100 万番目はいくつか?
module project_euler.problem024;

import system.linq : elementAt, permutations;

dstring problem024(in dstring source, in size_t nth)
{
    return permutations(source.dup).elementAt(nth - 1);
}

unittest
{
    assert(problem024("012", 1) == "012");
    assert(problem024("012", 2) == "021");
    assert(problem024("012", 3) == "102");
    assert(problem024("012", 4) == "120");
    assert(problem024("012", 5) == "201");
    assert(problem024("012", 6) == "210");
    assert(problem024("0123456789", 100_0000) == "2783915460");
}
