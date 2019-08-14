module project_euler.foundation;

import std.algorithm : sort;
import std.random : uniform;
import std.range : assumeSorted;
import std.traits : Unqual;
import std.typetuple : TypeTuple;
import system.linq : first;

/// 指定した $(D_KEYWORD uint) の 10 進表現における桁数を取得します。
///
/// Params:
/// value = 桁数を取得する対象の値。
///
/// Returns:
/// $(D_PSYMBOL value) の 10 進表現における桁数。
@property size_t decimalLength(in uint value)
{
    if (value < 10)
        return 1;
    if (value < 100)
        return 2;
    if (value < 1000)
        return 3;
    if (value < 10000)
        return 4;
    if (value < 100000)
        return 5;
    if (value < 1000000)
        return 6;
    if (value < 10000000)
        return 7;
    if (value < 100000000)
        return 8;
    if (value < 1000000000)
        return 9;
    else
        return 10;
}

///
unittest
{
    static assert((0).decimalLength == 1);
    static assert((1).decimalLength == 1);
    static assert((2).decimalLength == 1);
    static assert((3).decimalLength == 1);
    static assert((4).decimalLength == 1);
    static assert((5).decimalLength == 1);
    static assert((6).decimalLength == 1);
    static assert((7).decimalLength == 1);
    static assert((8).decimalLength == 1);
    static assert((9).decimalLength == 1);
    static assert((123).decimalLength == 3);
    static assert(uint.max.decimalLength == 10);
}

/// 数値を指定したアライメントの倍数に切り上げます。
///
/// Params:
/// alignment = アライメント。
/// value = 切り上げる対象の数値。
///
/// Returns:
/// $(D_PARAM alignment) に切り上げられた $(D_PARAM value)。
T aligned(size_t alignment, T)(T value)
{
    if (value % alignment == 0)
        return value;
    else
    {
        Unqual!T local = value;
        local -= value % alignment;
        local += alignment;
        return local;
    }
}

///
unittest
{
    static assert(aligned!4(3) == 4);
    static assert(aligned!4(4) == 4);
    static assert(aligned!4(5) == 8);
}

/// 指定した文字列を分解し、各文字から構成されるタプルを構築します。
///
/// Params:
/// source = タプルの構築元となる文字列。
template unpackChars(string source)
{
    static if (source.length == 0)
        alias unpackChars = TypeTuple!();
    else
        alias unpackChars = TypeTuple!(source[0], unpackChars!(source[1 .. $]));
}

///
unittest
{
    static assert(unpackChars!"".length == 0);
    static assert(unpackChars!"A".length == 1);
    static assert(unpackChars!"ABC".length == 3);
    static bool test(char c1, char c2, char c3)
    {
        return c1 == 'A' && c2 == 'B' && c3 == 'C';
    }
    static assert(test(unpackChars!"ABC"));
}

/// 数値を表す文字 ($(D_STRING '0') 〜 $(D_STRING '9')) を数値 ($(D 0) 〜 $(D 9)) に変換します。
///
/// Params:
/// c = 数値を表す文字。
///
/// Returns:
/// $(D_PSYMBOL c) と等価な数値。
@property uint asDigit(in dchar c)
{
    switch (c)
    {
        foreach (i, cc; unpackChars!"0123456789")
        {
            case cc:
                return i;
        }
        default:
            assert(false);
    }
}

///
unittest
{
    static assert('0'.asDigit == 0);
    static assert('1'.asDigit == 1);
    static assert('2'.asDigit == 2);
    static assert('3'.asDigit == 3);
    static assert('4'.asDigit == 4);
    static assert('5'.asDigit == 5);
    static assert('6'.asDigit == 6);
    static assert('7'.asDigit == 7);
    static assert('8'.asDigit == 8);
    static assert('9'.asDigit == 9);
}

/// TODO
pure nothrow @safe @nogc uint modpow(in uint base, in uint exponent, in uint mod)
{
    static pure nothrow @safe @nogc ulong internal(in ulong base, in uint exponent, in uint mod, in ulong result)
    {
        if (exponent == 0)
            return result;
        else if (exponent % 2 != 0)
            return internal(base * base % mod, exponent / 2, mod, result * base % mod);
        else
            return internal(base * base % mod, exponent / 2, mod, result);
    }
    return cast(uint)internal(base, exponent, mod, 1);
}

///
unittest
{
    static assert(modpow(2, 4, 3) == 2 ^^ 4 % 3);
}

/// 素数のシーケンスを表します。
struct GenericPrimeSequence(T)
{
    private static
    {
        immutable(T)[] _primes = [2, 3, 5, 7];

        void _glow()
        {
            for (auto n = _primes[$ - 1] + 2; true; n += 2)
            {
                foreach (prime; _primes)
                {
                    if (prime * prime > n)
                    {
                        _primes ~= n;
                        return;
                    }
                    if (n % prime == 0)
                        break;
                }
            }
        }

        T _get(in size_t index)
        {
            if (index >= _primes.length)
            {
                foreach (_; 0 .. index - _primes.length + 1)
                {
                    _glow();
                }
            }
            return _primes[index];
        }
    }

    private size_t _current = 0;

    enum empty = false;

    @property T front()
    {
        return _get(_current);
    }

    void popFront()
    {
        ++_current;
    }

    @property typeof(this) save()
    {
        return typeof(return)(_current);
    }

    T opIndex(in size_t i)
    {
        return _get(_current + i);
    }

    public static bool isPrime(in uint value)
    {
        while (_primes[$ - 1] < value)
        {
            _glow();
        }
        return assumeSorted(_primes).contains(value);
    }

    /// Miller-Rabin 素数判定法を使用して指定した値が素数かどうかを確率的に判断します。
    ///
    /// Params:
    /// value = 素数かどうかを判断する対象の値。
    /// k = 繰り返し試行する回数。
    ///
    /// Returns:
    /// $(D_PSYMBOL value) が確率的に素数の場合は $(D_KEYWORD true)。それ以外の場合は $(D_KEYWORD false)。
    public static bool isProbablePrime(in uint value, in uint k = 10)
    {
        if (value < 2 || value % 2 == 0)
            return value == 2;
        uint d = value - 1;
        uint s = 0;
        while (d % 2 == 0)
        {
            d /= 2;
            ++s;
        }
        assert(2 ^^ s * d == value - 1);

        static bool internal(in uint value, in uint d, in uint s)
        {
            immutable a = uniform(2U, value);
            auto x = modpow(a, d, value);
            if (x == 1 || x == value - 1)
                return true;
            foreach (_; 1 .. s)
            {
                x = modpow(x, 2, value);
                if (x == 1)
                    return false;
                if (x == value - 1)
                    return true;
            }
            return false;
        }
        foreach (_; 0 .. k)
        {
            if (!internal(value, d, s))
                return false;
        }
        return true;
    }
}

/// ditto
alias PrimeSequence = GenericPrimeSequence!uint;

///
unittest
{
    import std.range : take;
    import system.linq : sequenceEqual;
    assert(PrimeSequence.init.take(10).sequenceEqual([2, 3, 5, 7, 11, 13, 17, 19, 23, 29]));
}

///
unittest
{
    assert(PrimeSequence.isProbablePrime(2));
    assert(PrimeSequence.isProbablePrime(3));
    assert(PrimeSequence.isProbablePrime(97));
    assert(PrimeSequence.isProbablePrime(7652413));
}

/// 素因数を管理します。
struct GenericPrimeFactors(T)
{
    private static immutable(size_t)[T][ulong] _cache;

    /// 指定した値を素因数分解します。
    ///
    /// Params:
    /// value = 素因数分解する対象の値。
    ///
    /// Returns:
    /// $(D_PSYMBOL value) を素因数分解した結果の連想配列。
    /// 連想配列のキーは素数、値は素数が出現する回数を表します。
    public static immutable(size_t)[T] opIndex(in ulong value)
    {
        if (value == 1)
            return null;
        if (value !in _cache)
        {
            immutable minimumPrimeFactor = GenericPrimeSequence!T.init.first!(x => value % x == 0);
            auto primeFactors = cast(size_t[T])GenericPrimeFactors!T[value / minimumPrimeFactor].dup;
            ++primeFactors[minimumPrimeFactor];
            _cache[value] = cast(immutable(size_t)[T])primeFactors;
        }
        return _cache[value];
    }
}

/// ditto
alias PrimeFactors = GenericPrimeFactors!uint;

///
unittest
{
    import system.linq : orderBy, sequenceEqual;
    assert(PrimeFactors[2 * 3 * 3 * 5 * 5 * 5 * 7].keys.orderBy.sequenceEqual([2, 3, 5, 7]));
    assert(PrimeFactors[2 * 3 * 3 * 5 * 5 * 5 * 7][2] == 1);
    assert(PrimeFactors[2 * 3 * 3 * 5 * 5 * 5 * 7][3] == 2);
    assert(PrimeFactors[2 * 3 * 3 * 5 * 5 * 5 * 7][5] == 3);
    assert(PrimeFactors[2 * 3 * 3 * 5 * 5 * 5 * 7][7] == 1);
}

/// 約数を管理します。
struct GenericDivisors(T)
{
    private static immutable(ulong)[][ulong] _cache;

    /// 指定した値のすべての約数を取得します。
    ///
    /// Params:
    /// value = 約数を取得する対象の値。
    ///
    /// Returns:
    /// $(D_PSYMBOL value) のすべての約数。
    public static immutable(ulong)[] opIndex(in ulong value)
    in
    {
        assert(value >= 1);
    }
    body
    {
        if (value !in _cache)
        {
            ulong[] divisors = [1];
            foreach (prime, count; GenericPrimeFactors!T[value])
            {
                immutable n = divisors.length;
                divisors.length *= count + 1;
                foreach (i; 0 .. count)
                {
                    immutable lower = n * i;
                    immutable middle = lower + n;
                    immutable upper = middle + n;
                    divisors[middle .. upper] = divisors[lower .. middle];
                    divisors[middle .. upper] *= prime;
                }
            }
            sort(divisors);
            _cache[value] = cast(immutable(ulong)[])divisors;
        }
        return _cache[value];
    }
}

/// ditto
alias Divisors = GenericDivisors!uint;

///
unittest
{
    assert(Divisors[1] == [1]);
    assert(Divisors[2] == [1, 2]);
    assert(Divisors[12] == [1, 2, 3, 4, 6, 12]);
}

/// 回文数のシーケンスを表します。
struct GenericPalindromeSequence(T)
{
    private size_t _length;
    private ushort[] _digits;

    this(in size_t length)
    in
    {
        assert(length >= 1);
    }
    body
    {
        _length = length;
        _digits = new ushort[aligned!2(length) / 2];
        _digits[0] = 1;
        _digits[1 .. $][] = 0;
    }

    @property bool empty()
    {
        return _digits[0] == 0;
    }

    @property T front()
    in
    {
        assert(!empty);
    }
    body
    {
        T value = 0;
        foreach (d; _digits)
        {
            value *= 10;
            value += d;
        }
        foreach_reverse (d; _length % 2 == 0 ? _digits : _digits[0 .. $ - 1])
        {
            value *= 10;
            value += d;
        }
        return value;
    }

    @property T back()
    in
    {
        assert(!empty);
    }
    body
    {
        T value = 10 - _digits[0];
        foreach (d; _digits[1 .. $])
        {
            value *= 10;
            value += 9 - d;
        }
        foreach_reverse (i, d; _length % 2 == 0 ? _digits[1 .. $] : _digits[1 .. $ - 1])
        {
            value *= 10;
            value += 9 - d;
        }
        value *= 10;
        value += 10 - _digits[0];
        return value;
    }

    void popFront()
    in
    {
        assert(!empty);
    }
    body
    {
        foreach_reverse (i, ref d; _digits)
        {
            ++d;
            if (d != 10)
                break;
            d = 0;
        }
    }

    alias popBack = popFront;

    @property GenericPalindromeSequence!T save()
    {
        assert(false);
    }
}

/// ditto
alias PalindromeSequence = GenericPalindromeSequence!uint;

///
unittest
{
    import system.linq : sequenceEqual;
    static assert(PalindromeSequence(1).sequenceEqual([1, 2, 3, 4, 5, 6, 7, 8, 9]));
    static assert(PalindromeSequence(2).sequenceEqual([11, 22, 33, 44, 55, 66, 77, 88, 99]));
    static assert(PalindromeSequence(3).sequenceEqual(
    [
        101, 111, 121, 131, 141, 151, 161, 171, 181, 191,
        202, 212, 222, 232, 242, 252, 262, 272, 282, 292,
        303, 313, 323, 333, 343, 353, 363, 373, 383, 393,
        404, 414, 424, 434, 444, 454, 464, 474, 484, 494,
        505, 515, 525, 535, 545, 555, 565, 575, 585, 595,
        606, 616, 626, 636, 646, 656, 666, 676, 686, 696,
        707, 717, 727, 737, 747, 757, 767, 777, 787, 797,
        808, 818, 828, 838, 848, 858, 868, 878, 888, 898,
        909, 919, 929, 939, 949, 959, 969, 979, 989, 999,
    ]));
}
