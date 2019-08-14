/// Problem 22: 名前のスコア
///
/// 5000 個以上の名前が書かれているテキストファイル names.txt を用いる。まずアルファベット順にソートせよ。
/// のち、各名前についてアルファベットに値を割り振り、リスト中の出現順の数と掛け合わせることで、名前のスコアを計算する。
/// たとえば、リストがアルファベット順にソートされているとすると、COLIN はリストの938番目にある。
/// また COLIN は 3 + 15 + 12 + 9 + 14 = 53 という値を持つ。
/// よって COLIN は 938 x 53 = 49714 というスコアを持つ。
/// ファイル中の全名前のスコアの合計を求めよ。
module project_euler.problem022;

import std.file : readText;
import std.string : split;
import system.linq : asRvalueElements, block, orderBy, sum, toArray, Yield;
import project_euler.foundation : unpackChars;

@property uint scoreof(in string source)
{
    uint score = 0;
    foreach (c; source)
    {
        final switch (c)
        {
            foreach (i, cc; unpackChars!"ABCDEFGHIJKLMNOPQRSTUVWXYZ")
            {
                case cc:
                    score += i + 1;
                    break;
            }
        }
    }
    return score;
}

ulong problem022(in string path)
{
    auto names = readText(path).split(',').asRvalueElements.orderBy.toArray;
    void yieldScores(Yield!ulong yield)
    {
        foreach (i, name; names)
        {
            yield = (i + 1) * name[1 .. $ - 1].scoreof;
        }
    }
    return block!yieldScores.sum;
}

unittest
{
    assert(problem022("./project-euler/resources/022-names.txt") == 871198282);
}
