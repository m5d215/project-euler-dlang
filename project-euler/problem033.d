/// Problem 33: 桁消去分数
///
/// 49/98 は面白い分数である。
/// 「分子と分母からそれぞれ 9 を取り除くと、49/98 = 4/8 となり、簡単な形にすることができる」
/// と経験の浅い数学者が誤って思い込んでしまうかもしれないからである。
/// 方法は正しくないが，49/98 の場合にはたまたま正しい約分になってしまう。
///
/// 我々は 30/50 = 3/5 のようなタイプは自明な例だとする。
/// このような分数のうち、1 より小さく分子、分母がともに 2 桁の数になるような自明でないものは、4 個ある。
/// その 4 個の分数の積が約分された形で与えられたとき、分母の値を答えよ。
module project_euler.problem033;

import std.numeric : gcd;
import system.linq : aggregate, counting;

struct Rational(T)
{
    T numerator;
    T denominator;

    Rational!T reduce() const
    {
        immutable n = gcd(numerator, denominator);
        return Rational!T(numerator / n, denominator / n);
    }

    auto opBinary(string op)(Rational!T other)
    if (op == "*")
    {
        return Rational!T(numerator * other.numerator, denominator * other.denominator).reduce();
    }
}

private Rational!T accidentalReduce(T)(Rational!T rational)
{
    immutable n1 = rational.numerator / 10;
    immutable n2 = rational.numerator % 10;
    immutable d1 = rational.denominator / 10;
    immutable d2 = rational.denominator % 10;
    if (n1 == d1)
        return Rational!T(n2, d2);
    else if (n1 == d2)
        return Rational!T(n2, d1);
    else if (n2 == d1)
        return Rational!T(n1, d2);
    else if (n2 == d2)
        return Rational!T(n1, d1);
    else
        return rational;
}

uint problem033()
{
    alias Rational = .Rational!uint;
    immutable(Rational)[] rationals;
    foreach (numerator; counting[10U .. 99U])
    foreach (denominator; counting[numerator + 1 .. 100U])
    {
        if (numerator % 10 == 0 && denominator % 10 == 0) // trivial
            continue;
        immutable rational = Rational(numerator, denominator);
        immutable accidentalReduced = rational.accidentalReduce();
        if (accidentalReduced == rational)
            continue;
        if (rational.reduce() == accidentalReduced.reduce())
        {
            rationals ~= rational;
            if (rationals.length == 4)
                break;
        }
    }
    return rationals.aggregate!"a * b".reduce().denominator;
}

unittest
{
    assert(problem033() == 100);
}
