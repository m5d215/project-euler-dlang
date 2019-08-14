/// Problem 9: 特別なピタゴラス数
///
/// ピタゴラス数 (ピタゴラスの定理を満たす自然数) とは a < b < c で a^2 + b^2 = c^2 を満たす数の組である。
/// 例えば、3^2 + 4^2 = 9 + 16 = 25 = 5^2 である.
/// a + b + c = 1000 となるピタゴラスの三つ組が一つだけ存在する。
/// これらの積 a * b * c を計算しなさい。
module project_euler.problem009;

uint problem009()
{
    foreach (a; 1 .. 1000 - 2)
    foreach (b; a .. 1000 - 1)
    {
        if (a + b + 1 > 1000)
            break;
        immutable c = 1000 - a - b;
        if (a * a + b * b == c * c)
            return a * b * c;
    }
    assert(false);
}

unittest
{
    assert(problem009() == 31875000);
}
