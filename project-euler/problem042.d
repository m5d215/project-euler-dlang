/// Problem 42: 符号化三角数
/// 
/// 三角数の n 項 (n >= 1) は t[n]=n(n+1)/2 で与えられる。
// 単語中のアルファベットを数値に変換した後に和をとる。
/// この和を「単語の値」と呼ぶことにする。
/// 例えば SKY は 19 + 11 + 25 = 55 = t[10] である。
/// 単語の値が三角数であるとき、その単語を三角語と呼ぶ。
/// テキスト ファイル words.txt 中に約 2000 語の英単語が記されている。
/// 三角語はいくつあるか。
module project_euler.problem042;

import std.file : readText;
import std.range : assumeSorted;
import std.string : split;
import system.linq : count, counting, infinity, maximum, select, takeWhile, toArray;
import project_euler.problem022 : scoreof;

size_t problem042(in string path)
{
    const scores = readText(path).split(',').select!(x => scoreof(x[1 .. $ - 1])).toArray;
    immutable maximum = scores.maximum;
    auto triangles = counting[1U .. infinity].select!"a * (a + 1) / 2".takeWhile!(x => x <= maximum).toArray.assumeSorted;
    return scores.count!(x => triangles.contains(x));
}

unittest
{
    assert(problem042("./project-euler/resources/042-words.txt") == 162);
}
