/// Problem 17: 数字の文字数
///
/// 1 から 5 までの数字を英単語で書けば one、two、three、four、five であり、全部で 3 + 3 + 5 + 4 + 4 = 19 の文字が使われている。
/// では 1 から 1000 (one thousand) までの数字をすべて英単語で書けば、全部で何文字になるか。
///
/// 注: 空白文字やハイフンを数えないこと。
/// 例えば、342 (three hundred and forty-two) は 23 文字、115 (one hundred and fifteen) は 20 文字と数える。
/// なお、"and" を使用するのは英国の慣習。
module project_euler.problem017;

import system.linq : counting, select, sum;

size_t problem017(in uint upper)
{
    enum dictionary =
    [
           1 : "one",
           2 : "two",
           3 : "three",
           4 : "four",
           5 : "five",
           6 : "six",
           7 : "seven",
           8 : "eight",
           9 : "nine",
          10 : "ten",
          11 : "eleven",
          12 : "twelve",
          13 : "thirteen",
          14 : "fourteen",
          15 : "fifteen",
          16 : "sixteen",
          17 : "seventeen",
          18 : "eighteen",
          19 : "nineteen",
          20 : "twenty",
          30 : "thirty",
          40 : "forty",
          50 : "fifty",
          60 : "sixty",
          70 : "seventy",
          80 : "eighty",
          90 : "ninety",
         100 : "onehundred",
         200 : "twohundred",
         300 : "threehundred",
         400 : "fourhundred",
         500 : "fivehundred",
         600 : "sixhundred",
         700 : "sevenhundred",
         800 : "eighthundred",
         900 : "ninehundred",
        1000 : "onethousand",
    ];
    static size_t englishLength(in uint value)
    in
    {
        assert(value >= 1);
    }
    body
    {
        if (value in dictionary)
        {
            return dictionary[value].length;
        }
        if (value < 100)
        {
            return dictionary[value - value % 10].length + dictionary[value % 10].length;
        }
        if (value < 1000)
        {
            return dictionary[value - value % 100].length + "and".length + englishLength(value % 100);
        }
        assert(false);
    }
    return counting!"[]"[1 .. upper]
        .select!(x => englishLength(x))
        .sum;
}

unittest
{
    assert(problem017(5) == 19);
}
