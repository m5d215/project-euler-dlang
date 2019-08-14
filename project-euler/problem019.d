/// Problem 19: 日曜日の数え上げ
///
/// 次の情報が与えられている。
/// * 1900/01/01 は月曜日である。
/// * 9 月、4 月、6 月、11 月は 30 日まであり、2 月を除く他の月は 31 日まである。
/// * 2 月は 28 日まであるが、うるう年のときは 29 日である。
/// * うるう年は西暦が 4 で割り切れる年に起こる。しかし、西暦が 400 で割り切れず 100 で割り切れる年はうるう年でない。
/// 20 世紀 (1901/01/01 から 2000/12/31) 中に月の初めが日曜日になるのは何回あるか。
module project_euler.problem019;

import system.linq : block, count, counting, Yield;

private bool isLeapYear(in uint year)
{
    return year % 4 == 0 && !(year % 400 != 0 && year % 100 == 0);
}

size_t problem019()
{
    enum DayOfWeek
    {
        sunday,
        monday,
        tuesday,
        wednesday,
        thursday,
        friday,
        saturday,
    }
    static void iterationBlock(Yield!DayOfWeek yield)
    {
        auto dayOfWeek = DayOfWeek.monday;
        dayOfWeek += isLeapYear(1900) ? 366 : 365;
        dayOfWeek %= 7;
        foreach (year; counting!"[]"[1901 .. 2000])
        foreach (month; counting!"[]"[1 .. 12])
        {
            yield = dayOfWeek;
            final switch (month)
            {
                case 4:
                case 6:
                case 9:
                case 11:
                    dayOfWeek += 30;
                    break;
                case 1:
                case 3:
                case 5:
                case 7:
                case 8:
                case 10:
                case 12:
                    dayOfWeek += 31;
                    break;
                case 2:
                    if (isLeapYear(year))
                    {
                        dayOfWeek += 29;
                    }
                    else
                    {
                        dayOfWeek += 28;
                    }
            }
            dayOfWeek %= 7;
        }
    }
    return block!iterationBlock.count!(x => x == DayOfWeek.sunday);
}

unittest
{
    assert(problem019() == 171);
}
