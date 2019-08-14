/++
 + $(I .NET Framework) の統合言語クエリ (LINQ, Language INtegrated Query) の D 言語による実装を提供します。
 +
 + $(TABLE
 +   $(TR $(TH 名前)                    $(TH 概要))
 +   $(TR $(TD aggregate)               $(TD レンジにアキュームレータ関数を適用します。))
 +   $(TR $(TD all)                     $(TD レンジのすべての要素が条件を満たしているかどうかを判断します。))
 +   $(TR $(TD any)                     $(TD レンジの任意の要素が条件を満たしているかどうかを判断します。))
 +   $(TR $(TD asInputRange)            $(TD レンジのカテゴリを $(PARLANCE InputRange) にダウングレードします))
 +   $(TR $(TD asForwardRange)          $(TD レンジのカテゴリを $(PARLANCE ForwardRange) にダウングレードします))
 +   $(TR $(TD asBidirectionalRange)    $(TD レンジのカテゴリを $(PARLANCE BidirectionalRange) にダウングレードします))
 +   $(TR $(TD asFiniteRange)           $(TD 定数の $(PARLANCE Range.empty) プロパティを秘匿します。))
 +   $(TR $(TD asDisabledLength)        $(TD $(PARLANCE Range.length) プロパティを秘匿します。))
 +   $(TR $(TD asDisabledSlicing)       $(TD $(PARLANCE Range.opSlice) メソッドを秘匿します。))
 +   $(TR $(TD asRvalueElements)        $(TD 要素型の $(D_KEYWORD ref) 修飾を秘匿します。))
 +   $(TR $(TD asReadOnlyElements)      $(TD 要素への書き込み機能を秘匿します。))
 +   $(TR $(TD average)                 $(TD レンジのすべての要素の平均値を取得します。))
 +   $(TR $(TD block)                   $(TD イテレータ ブロック構文を実現します。))
 +   $(TR $(TD combinations)            $(TD すべての組み合わせを列挙します。))
 +   $(TR $(TD concat)                  $(TD 複数のレンジを結合します。))
 +   $(TR $(TD contains)                $(TD 指定した要素がレンジに含まれているかどうかを判断します。))
 +   $(TR $(TD convert)                 $(TD レンジの各要素を指定した型へ変換します。))
 +   $(TR $(TD count)                   $(TD 条件を満たす要素の数を取得します。))
 +   $(TR $(TD counting)                $(TD 連続した数値のレンジを生成します。))
 +   $(TR $(TD defaultIfEmpty)          $(TD 指定されたレンジの要素を返します。レンジが空の場合はデフォルト値を返します。))
 +   $(TR $(TD distinct)                $(TD レンジから一意の要素のみを抽出します。))
 +   $(TR $(TD distribute)              $(TD 分配可能なイテレータ ブロック構文を実現します。))
 +   $(TR $(TD elementAt)               $(TD レンジ内の指定されたインデックス位置にある要素を取得します。))
 +   $(TR $(TD elementAtOrDefault)      $(TD レンジ内の指定されたインデックス位置にある要素を取得します。))
 +   $(TR $(TD first)                   $(TD レンジの最初の要素を取得します。))
 +   $(TR $(TD firstOrDefault)          $(TD レンジの最初の要素を取得します。))
 +   $(TR $(TD groupBy)                 $(TD $(I 未実装です。) ($(REF toLookup) を使用してください。)))
 +   $(TR $(TD groupJoin)               $(TD $(I 未実装です。)))
 +   $(TR $(TD last)                    $(TD レンジの最後の要素を取得します。))
 +   $(TR $(TD lastOrDefault)           $(TD レンジの最後の要素を取得します。))
 +   $(TR $(TD maximum)                 $(TD レンジの要素の最小値を取得します。))
 +   $(TR $(TD minimum)                 $(TD レンジの要素の最大値を取得します。))
 +   $(TR $(TD nothing)                 $(TD 指定した型の空のレンジを取得します。))
 +   $(TR $(TD ofType)                  $(TD 指定された型に基づいてレンジの要素をフィルタ処理します。))
 +   $(TR $(TD orderBy)                 $(TD 指定された比較子を使用してレンジの要素を並べ替えます。))
 +   $(TR $(TD permutations)            $(TD すべての順列を列挙します。))
 +   $(TR $(TD select)                  $(TD レンジの各要素を新しいフォームに射影します。))
 +   $(TR $(TD sequenceEqual)           $(TD ふたつのレンジが等しいかどうかを判断します。))
 +   $(TR $(TD single)                  $(TD レンジの唯一の要素を取得します。))
 +   $(TR $(TD singleOrDefault)         $(TD レンジの唯一の要素を取得します。))
 +   $(TR $(TD skip)                    $(TD レンジ内の指定された数の要素をバイパスし、残りの要素を返します。))
 +   $(TR $(TD skipWhile)               $(TD 指定された条件が満たされる限り、レンジの要素をバイパスした後、残りの要素を返します。))
 +   $(TR $(TD sum)                     $(TD レンジの各要素の合計値を取得します。))
 +   $(TR $(TD takeWhile)               $(TD 指定された条件が満たされる限り、レンジから要素を返します。))
 +   $(TR $(TD toArray)                 $(TD レンジから配列を作成します。))
 +   $(TR $(TD toDictionary)            $(TD レンジから連想配列を作成します。))
 +   $(TR $(TD toLookup)                $(TD レンジから連想配列を作成します。キーの重複を許可します。))
 +   $(TR $(TD where)                   $(TD 述語に基づいて値のレンジをフィルタ処理します。))
 +   $(TR $(TD zip)                     $(TD $(I 未実装です。))))
 +
 + Macros:
 + TABLE       = <table class="table table-condensed table-bordered">$0</table>
 + PARLANCE    = $(I $0)
 + REF         = $(D $0)
 + INLINE_CODE = $(I $0)
 +/
module system.linq;

import std.algorithm : equal, makeIndex, move, reverse, swap;
import std.conv : to;
import std.range;
import std.traits : CommonType, hasElaborateCopyConstructor, Parameters, Unqual;
import std.typetuple : allSatisfy, staticMap, TypeTuple;
import core.thread : Fiber;
import system.core;
import system.functional;

/++
 + レンジにアキュームレータ関数を適用します。
 +
 + レンジ各要素に対して、先頭からアキュームレータ関数 $(D_PARAM accumulate) を適用します。
 + -----
 + auto state0 = range[0]
 + auto state1 = accumulate(state0, range[1])
 + auto state2 = accumulate(state1, range[2])
 + auto state3 = accumulate(state2, range[3])
 + ......
 + -----
 +
 + シード値 $(D_PARAM seed) を指定した場合は、最初のアキュームレータ値として使用されます。
 + -----
 + auto state0 = seed
 + -----
 +
 + 最終的な結果は $(D_PARAM result) 関数によって取得します。
 + -----
 + return result(stateN);
 + -----
 +
 + この関数は、あらゆる集計操作を実現できる汎用的な関数です。
 + 一般的な集計操作を簡略化するために、$(REF average)、$(REF count)、$(REF minimum)、$(REF maximum)、$(REF sum) が提供されています。
 +
 + Params:
 + accumulate = 各要素に対して呼び出すアキュームレータ関数。
 + result = 最終的なアキュムレータ値を結果値に変換する関数。
 + range = 操作対象のレンジ。
 + seed = アキュームレータ値の初期値。存在しないオーバーロードの場合は $(D_PARAM range) の最初の要素が選択されます。
 +
 + Returns:
 + 最終的なアキュームレータ値。
 +
 + Throws:
 + $(D_PARAM seed) 受け取らないオーバーロードで、$(D_PARAM range) に要素が含まれていません。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Aggregate)
 +/
auto aggregate(alias accumulate, alias result = "a", Range, T)(Range range, T seed)
if (isInputRange!Range && !isInfinite!Range)
{
    for (; !range.empty; range.popFront())
    {
        seed = buildFunction!accumulate(seed, range.front);
    }
    return buildFunction!result(seed);
}

/// ditto
@property auto aggregate(alias accumulate, alias result = "a", Range)(Range range)
if (isInputRange!Range && !isInfinite!Range)
{
    if (range.empty)
        throw new Exception("The source sequence is empty.");
    auto seed = range.front;
    range.popFront();
    return aggregate!(accumulate, result, Range, Unqual!(ElementType!Range))(range, seed);
}

///
unittest
{
    enum source = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    static assert(source.aggregate!"a + b" == 55);
    static assert(source.aggregate!("a + b", x => x / cast(double)source.length) == 5.5);
    static assert(source.aggregate!"a + b"(3) == 58);
}

/++
 + レンジのすべての要素が条件を満たしているかどうかを判断します。
 +
 + $(D_PARAM range) のすべての要素が $(D_PARAM predicate) を満たしているかどうかを判断します。
 + $(D_PARAM range) の列挙は、結果が確認できるとすぐに停止します。
 +
 + Params:
 + predicate = 各要素が条件を満たしているかどうかをテストする関数。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + 指定された述語で $(D_PARAM range) のすべての要素がテストに合格する場合は $(D_KEYWORD true)。それ以外の場合は $(D_KEYWORD false)。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.All)
 +/
@property bool all(alias predicate, Range)(Range range)
if (isInputRange!Range)
{
    for (; !range.empty; range.popFront())
    {
        if (!buildFunction!predicate(range.front))
            return false;
    }
    static if (!isInfinite!Range)
        return true;
}

///
unittest
{
    enum source = [1, 2, 3];
    static assert( source.all!"a < 5");
    static assert(!source.all!"a < 3");
}

/++
 + レンジの任意の要素が条件を満たしているかどうかを判断します。
 +
 + $(D_PARAM range) の任意の要素が $(D_PARAM predicate) を満たしているかどうかを判断します。
 + $(D_PARAM range) の列挙は、結果が確認できるとすぐに停止します。
 +
 + Params:
 + predicate = 各要素が条件を満たしているかどうかをテストする関数。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + 指定された述語で $(D_PARAM range) のいずれかの要素がテストに合格する場合は $(D_KEYWORD true)。それ以外の場合は $(D_KEYWORD false)。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Any)
 +/
@property bool any(alias predicate, Range)(Range range)
if (isInputRange!Range)
{
    for (; !range.empty; range.popFront())
    {
        if (buildFunction!predicate(range.front))
            return true;
    }
    static if (!isInfinite!Range)
        return false;
}

///
unittest
{
    enum source = [1, 2, 3];
    static assert( source.any!"a % 2 == 0");
    static assert(!source.any!"a == 0");
}

private struct StrictRange(Range, bool asForwardRange, bool asBidirectionalRange, bool asRandomAccessRange, bool asFiniteRange, bool asDisabledLength, bool asDisabledSlicing, bool asRvalueElements, bool asReadOnlyElements)
if (isInputRange!Range)
{
    private Range _source;

    static if (isInfinite!Range && !asFiniteRange)
        enum empty = false;
    else
        @property auto empty()
        {
            return _source.empty;
        }

    static if (hasLength!Range && !asDisabledLength)
    {
        @property auto length()
        {
            return _source.length;
        }

        alias opDollar = length;
    }

    static if (hasSlicing!Range && !asDisabledSlicing)
        auto opSlice(in size_t lower, in size_t upper)
        {
            assert(lower <= upper);
            static if (hasLength!Range)
                assert(upper <= _source.length);
            return _source[lower .. upper];
        }

    @property auto ref front()
    {
        assert(!_source.empty);
        static if (hasLvalueElements!Range && !asRvalueElements && !asReadOnlyElements)
            return _source.front;
        else
            return asRvalue(_source.front);
    }

    static if (hasAssignableElements!Range && !asReadOnlyElements)
        @property void front(ElementType!Range value)
        {
            assert(!_source.empty);
            _source.front = value;
        }

    static if (hasMobileElements!Range)
        @property auto moveFront()
        {
            assert(!_source.empty);
            return .moveFront(_source);
        }

    void popFront()
    {
        assert(!_source.empty);
        _source.popFront();
    }

    static if (isForwardRange!Range && asForwardRange)
        @property auto save()
        {
            return typeof(this)(_source.save);
        }

    static if (isBidirectionalRange!Range && asBidirectionalRange)
    {
        @property auto ref back()
        {
            assert(!_source.empty);
            static if (hasLvalueElements!Range && !asRvalueElements && !asReadOnlyElements)
                return _source.back;
            else
                return asRvalue(_source.back);
        }

        static if (hasAssignableElements!Range && !asReadOnlyElements)
            @property void back(ElementType!Range value)
            {
                assert(!_source.empty);
                _source.back = value;
            }

        static if (hasMobileElements!Range)
            @property auto moveBack()
            {
                assert(!_source.empty);
                return .moveBack(_source);
            }

        void popBack()
        {
            assert(!_source.empty);
            _source.popBack();
        }
    }

    static if (isRandomAccessRange!Range && asRandomAccessRange)
    {
        auto ref opIndex(in size_t index)
        {
            static if (hasLength!Range)
                assert(index < _source.length);
            static if (hasLvalueElements!Range && !asRvalueElements && !asReadOnlyElements)
                return _source[index];
            else
                return asRvalue(_source[index]);
        }

        static if (hasAssignableElements!Range && !asReadOnlyElements)
            void opIndexAssign(ElementType!Range value, in size_t index)
            {
                static if (hasLength!Range)
                    assert(index < _source.length);
                _source[index] = value;
            }

        static if (hasMobileElements!Range)
            auto moveAt(in size_t index)
            {
                static if (hasLength!Range)
                    assert(index < _source.length);
                return .moveAt(_source, index);
            }
    }
}

/++
 + レンジの機能を制限します。
 +
 + このメソッドは遅延実行を使用して実装されます。
 + アクションの実行に必要なすべての情報を格納するレンジがすぐに返されます。
 + このプロパティによって取得したレンジは、$(D_KEYWORD foreach) ステートメントなどで列挙を開始するまで評価されません。
 +
 + 入力されたレンジが提供するインターフェイスを制限します。
 +
 + 以下のプロパティ群から構成されます。
 + $(TABLE
 +   $(TR $(TH プロパティ)
 +        $(TH 機能))
 +   $(TR $(TD asInputRange)
 +        $(TD レンジのカテゴリを $(PARLANCE InputRange) にダウングレードします))
 +   $(TR $(TD asForwardRange)
 +        $(TD レンジのカテゴリを $(PARLANCE ForwardRange) にダウングレードします))
 +   $(TR $(TD asBidirectionalRange)
 +        $(TD レンジのカテゴリを $(PARLANCE BidirectionalRange) にダウングレードします))
 +   $(TR $(TD asFiniteRange)
 +        $(TD 定数の $(PARLANCE Range.empty) プロパティを秘匿します))
 +   $(TR $(TD asDisabledLength)
 +        $(TD $(PARLANCE Range.length) プロパティを秘匿します))
 +   $(TR $(TD asDisabledSlicing)
 +        $(TD $(PARLANCE Range.opSlice) メソッドを秘匿します))
 +   $(TR $(TD asRvalueElements)
 +        $(TD 要素型の $(D_KEYWORD ref) 修飾を秘匿します))
 +   $(TR $(TD asReadOnlyElements)
 +        $(TD 要素への書き込み機能を秘匿します)))
 +
 + Params:
 + range = 操作対象のレンジ。
 +
 + Returns:
 + インターフェイスが制限されたレンジ。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.AsEnumerable)
 +/
@property auto asInputRange(Range)(Range range)
if (isInputRange!Range)
{
    static if (isForwardRange!Range)
        return StrictRange!(Range, false, false, false, false, false, false, false, false)(range);
    else
        return range;
}

/// ditto
@property auto asForwardRange(Range)(Range range)
if (isForwardRange!Range)
{
    static if (isBidirectionalRange!Range)
        return StrictRange!(Range, true, false, false, false, false, false, false, false)(range);
    else
        return range;
}

/// ditto
@property auto asBidirectionalRange(Range)(Range range)
if (isBidirectionalRange!Range)
{
    static if (isRandomAccessRange!Range)
        return StrictRange!(Range, true, true, false, false, false, false, false, false)(range);
    else
        return range;
}

/// ditto
@property auto asFiniteRange(Range)(Range range)
if (isInputRange!Range)
{
    static if (isInfinite!Range)
        return StrictRange!(Range, true, true, true, true, false, false, false, false)(range);
    else
        return range;
}

/// ditto
@property auto asDisabledLength(Range)(Range range)
if (isInputRange!Range)
{
    static if (hasLength!Range)
        return StrictRange!(Range, true, true, true, false, true, false, false, false)(range);
    else
        return range;
}

/// ditto
@property auto asDisabledSlicing(Range)(Range range)
if (isInputRange!Range)
{
    static if (hasSlicing!Range)
        return StrictRange!(Range, true, true, true, false, false, true, false, false)(range);
    else
        return range;
}

/// ditto
@property auto asRvalueElements(Range)(Range range)
if (isInputRange!Range)
{
    static if (hasLvalueElements!Range)
        return StrictRange!(Range, true, true, true, false, false, false, true, false)(range);
    else
        return range;
}

/// ditto
@property auto asReadOnlyElements(Range)(Range range)
if (isInputRange!Range)
{
    static if (hasAssignableElements!Range)
        return StrictRange!(Range, true, true, true, false, false, false, false, true)(range);
    else
        return range;
}

///
unittest
{
    enum source = [1];
    static assert( isInputRange!(typeof(source.asInputRange)));
    static assert(!isForwardRange!(typeof(source.asInputRange)));
    static assert( isForwardRange!(typeof(source.asForwardRange)));
    static assert(!isBidirectionalRange!(typeof(source.asForwardRange)));
    static assert( isBidirectionalRange!(typeof(source.asBidirectionalRange)));
    static assert(!isRandomAccessRange!(typeof(source.asBidirectionalRange)));
    struct Range
    {
        enum empty = false;
        @property int front() { return 0; }
        void popFront() { }
    }
    static assert( isInfinite!Range);
    static assert(!isInfinite!(typeof(Range.init.asFiniteRange)));
    static assert( hasLength!(int[]));
    static assert(!hasLength!(typeof([1].asDisabledLength)));
    static assert( hasSlicing!(int[]));
    static assert(!hasSlicing!(typeof([1].asDisabledSlicing)));
    static assert( hasLvalueElements!(int[]));
    static assert(!hasLvalueElements!(typeof([1].asRvalueElements)));
    static assert( hasAssignableElements!(int[]));
    static assert(!hasAssignableElements!(typeof([1].asReadOnlyElements)));
}

/++
 + レンジのすべての要素の平均値を取得します。
 +
 + まず、$(D_PARAM range) のすべての要素に $(D_PARAM selector) を適用し、結果を $(D_PARAM accumulate) 関数で集計します。
 + 次に、集計された結果と要素数で $(D_PARAM divide) 関数を呼び出すことで、結果を取得します。
 +
 + $(D_PARAM range) が空の場合は例外がスローされます。
 +
 + Params:
 + selector = 各要素に適用する変換関数。
 + accumulate = 各要素に対して呼び出すアキュームレータ関数。
 + divide = 合計値と要素数から平均値を計算する関数。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + $(D_PARAM range) の平均値。
 +
 + Throws:
 + $(D_PARAM range) に要素が含まれていません。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Average)
 +/
@property auto average(alias selector = "a", alias accumulate = "a + b", alias divide = "a / b", Range)(Range range)
if (isInputRange!Range && !isInfinite!Range)
{
    if (range.empty)
        throw new Exception("The source sequence is empty.");
    auto seed = buildFunction!selector(range.front);
    range.popFront();
    size_t n = 1;
    for (; !range.empty; range.popFront(), ++n)
    {
        seed = buildFunction!accumulate(seed, buildFunction!selector(range.front));
    }
    return buildFunction!divide(seed, n);
}

///
unittest
{
    enum source = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    static assert(source.average == 5);
    static assert(source.average!("a", "a + b", (x, y) => x / cast(double)y) == 5.5);
    static assert(source.average!"cast(double)a" == 5.5);
}

private template DeduceYieldType(alias iterationBlock)
{
    static if (is(Parameters!iterationBlock Params) &&
               Params.length == 1 &&
               is(Params[0] YieldType == Yield!YieldType))
        alias DeduceYieldType = YieldType;
    else
        static assert(false);
}

private final class BlockRange(alias iterationBlock)
if (is(DeduceYieldType!iterationBlock))
{
    private alias YieldType = DeduceYieldType!iterationBlock;
    static if (is(YieldType Y == Reference!Y))
        private Y* _cache;
    else
        private YieldType _cache;
    private bool _valid;
    private Fiber _fiber;

    this()
    {
        _fiber = new Fiber({ iterationBlock(Yield!YieldType(&_cache, &_valid)); });
        popFront();
    }

    @property bool empty()
    {
        return _fiber.state == Fiber.State.TERM && !_valid;
    }

    @property auto ref front()
    {
        assert(!empty);
        static if (is(Y))
        {
            assert(_cache !is null);
            return *_cache;
        }
        else
        {
            return asRvalue(_cache);
        }
    }

    static if (is(Y))
        @property void front(Y value)
        {
            *addressof(front) = value;
        }

    static if (!is(Y) && !hasElaborateCopyConstructor!YieldType)
        YieldType moveFront()
        {
            assert(!empty);
            return move(_cache);
        }

    void popFront()
    {
        assert(!empty);
        if (_fiber.state != Fiber.State.TERM)
        {
            _fiber.call();
            if (_fiber.state == Fiber.State.TERM)
                _valid = false;
        }
        else
        {
            _valid = false;
        }
    }
}

/++
 + プログラミング言語$(I C#)などにみられるイテレータ ブロック構文の D 言語実装です。
 +
 + $(D_PSYMBOL block) 関数は、イテレータ ブロックと呼ばれる特殊な関数をひとつ受け取り、そこから $(PARLANCE InputRange) を生成します。
 +
 + イテレータ ブロックとは、$(D_PSYMBOL Yield) 型の引数をひとつだけ受け取る関数のことをいい、以下のように宣言されます。
 + -----
 + void iterationBlock(Yield!int yield)
 + {
 +     // ......
 + }
 + -----
 +
 + イテレータ ブロックの内部では、引数 $(INLINE_CODE yield) に値を代入することで、その値をレンジの要素とすることができます。
 + -----
 + void iterationBlock(Yield!int yield)
 + {
 +     yield = 1;
 +     yield = 2;
 +     yield = 3;
 + }
 + -----
 +
 + このイテレータ ブロックをレンジ化すると 1、2、3 の要素をもつ $(PARLANCE InputRange) になります。
 + -----
 + auto range = block!iterationBlock;
 + assert(!range.empty);
 + assert(range.front == 1);
 + range.popFront();
 + assert(range.front == 2);
 + range.popFront();
 + assert(range.front == 3);
 + range.popFront();
 + assert(range.empty);
 + -----
 +
 + $(D_PSYMBOL Yield) テンプレートの引数に $(REF Reference) を指定することで、$(D_PSYMBOL block) によって生成されるレンジの要素を左辺値とすることができます。
 + -----
 + int[] a = [1, 2, 3];
 + void iterationBlock(Yield!(Reference!int) yield)
 + {
 +     yield = a[0];
 +     yield = a[1];
 +     yield = a[2];
 + }
 + assert(a == [1, 2, 3]);
 + foreach (ref x; block!iterationBlock)
 + {
 +     x = 0;
 + }
 + assert(a == [0, 0, 0]);
 + -----
 +
 + または、$(INLINE_CODE $(D_PSYMBOL Yield)!($(REF Reference)!YieldType)) に対するエイリアス $(D_PSYMBOL YieldReference) を使用することができます。
 + -----
 + void iterationBlock(YieldReference!int yield)
 + {
 +     // ......
 + }
 + -----
 +
 + Params:
 + iterationBlock = レンジの要素を生産するイテレータ ブロック。
 +
 + Returns:
 + $(D_PARAM iterationBlock) によって生産された要素をもつレンジ。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(PARLANCE InputRange)))
 +   $(TR $(TD Infinite)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Length)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Slicing)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD LvalueElements)
 +        $(TD $(D_PSYMBOL Yield) で $(REF Reference) 指定した場合は $(PARLANCE Yes)))
 +   $(TR $(TD AssignableElements)
 +        $(TD $(D_PSYMBOL Yield) で $(REF Reference) 指定した場合は $(PARLANCE Yes))))
 +
 + Remark:
 + $(D_PSYMBOL block) 関数は、イテレータ ブロックを $(PARLANCE InputRange) 化する際に、内部で $(REF core.thread.Fiber)を使用します。
 + 一般的なレンジの構築および列挙コストと比べ、$(REF Fiber) の構築分パフォーマンスが低下します。
 + 大量に構築される可能性のあるレンジの生成に $(D_PSYMBOL block) を使用する場合は、その点に注意してください。
 +/
@property auto block(alias iterationBlock)()
if (is(DeduceYieldType!iterationBlock))
{
    return new BlockRange!iterationBlock();
}

/// ditto
struct Yield(YieldType)
{
    static if (is(YieldType Y == Reference!Y))
        private Y** _cache;
    else
        private YieldType* _cache;
    private bool* _valid;

    invariant
    {
        assert(_cache !is null);
        assert(_valid !is null);
    }

    void opAssign(T)(auto ref T value)
    {
        static if (is(Y))
            *_cache = &value;
        else
            *_cache = value;
        *_valid = true;
        Fiber.yield();
    }
}

/// ditto
alias YieldReference(YieldType) = Yield!(Reference!YieldType);

///
unittest
{
    void iterationBlock(Yield!int yield)
    {
        yield = 1;
        yield = 2;
        yield = 3;
    }
    auto range = block!iterationBlock;
    assert(!range.empty);
    assert(range.front == 1); range.popFront();
    assert(range.front == 2); range.popFront();
    assert(range.front == 3); range.popFront();
    assert(range.empty);
    assert(block!iterationBlock.sequenceEqual([1, 2, 3]));
}

///
unittest
{
    int[] a = [1, 2, 3];
    void iterationBlock(YieldReference!int yield)
    {
        foreach (ref x; a)
        {
            yield = x;
        }
    }
    foreach (ref x; block!iterationBlock)
    {
        x *= x;
    }
    assert(a == [1*1, 2*2, 3*3]);
}

private struct CombinationRange(Range)
if (isInputRange!Range && !isInfinite!Range)
{
    static if (isRandomAccessRange!Range && hasLength!Range)
        private Range _source;
    else
        private typeof(Range.init.toArray) _source;

    private size_t[] _indexes;

    this(Range range, in size_t k)
    {
        static if (isRandomAccessRange!Range && hasLength!Range)
            _source = range;
        else
            _source = range.toArray;
        _indexes.length = k;
        foreach (i, ref index; _indexes)
        {
            index = i;
        }
    }

    @property auto empty()
    {
        return _indexes is null;
    }

    @property auto front()
    {
        assert(!empty);
        return PermuteRange!Range(_source, _indexes);
    }

    void popFront()
    {
        assert(!empty);
        foreach_reverse (ii, ref index; _indexes)
        {
            ++index;
            if (index != _source.length - (_indexes.length - ii - 1))
            {
                foreach (jj; ii + 1 .. _indexes.length)
                {
                    _indexes[jj] = _indexes[ii] + jj - ii;
                }
                return;
            }
            else if (ii == 0 && _indexes[ii] == _source.length - _indexes.length + 1)
            {
                _indexes = null;
                return;
            }
        }
    }
}

/++
 + すべての組み合わせを列挙します。
 +
 + このメソッドは遅延実行を使用して実装されます。
 + アクションの実行に必要なすべての情報を格納するレンジがすぐに返されます。
 + このプロパティによって取得したレンジは、$(D_KEYWORD foreach) ステートメントなどで列挙を開始するまで評価されません。
 +
 + $(D_PARAM range) の要素の中から $(D_PARAM k) 個を選ぶ組み合わせをすべて列挙します。
 +
 + Params:
 + range = 操作対象のレンジ。
 + k = 組み合わせる個数。
 +
 + Returns:
 + $(D_PARAM range) から $(D_PARAM k) 選ぶ組み合わせを表すレンジ。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(PARLANCE InputRange)))
 +   $(TR $(TD Infinite)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Length)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Slicing)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD LvalueElements)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD AssignableElements)
 +        $(TD $(PARLANCE No))))
 +/
auto combinations(Range)(Range range, in size_t k)
if (isInputRange!Range && !isInfinite!Range)
{
    return CombinationRange!Range(range, k);
}

///
unittest
{
    enum source = [1, 2, 3, 4, 5].asRvalueElements;
    enum expected =
    [
        [1, 2, 3],
        [1, 2, 4],
        [1, 2, 5],
        [1, 3, 4],
        [1, 3, 5],
        [1, 4, 5],
        [2, 3, 4],
        [2, 3, 5],
        [2, 4, 5],
        [3, 4, 5],
    ];
    static assert(source.combinations(3).sequenceEqual!sequenceEqual(expected));
}

/++
 + 複数のレンジを結合します。
 +
 + このメソッドは遅延実行を使用して実装されます。
 + アクションの実行に必要なすべての情報を格納するレンジがすぐに返されます。
 + このプロパティによって取得したレンジは、$(D_KEYWORD foreach) ステートメントなどで列挙を開始するまで評価されません。
 +
 + Params:
 + ranges = 操作対象のレンジ。
 +
 + Returns:
 + 複数のレンジの各要素を順番に結合したレンジを返します。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(PARLANCE InputRange)))
 +   $(TR $(TD Infinite)
 +        $(TD いずれかのレンジが無限レンジなら $(PARLANCE Yes)))
 +   $(TR $(TD Length)
 +        $(TD すべてのレンジが長さを取得できるなら $(PARLANCE Yes)))
 +   $(TR $(TD Slicing)
 +        $(TD すべてのレンジが長さとスライスをサポートしているなら $(PARLANCE Yes)))
 +   $(TR $(TD LvalueElements)
 +        $(TD すべてのレンジがサポートしており、要素の型も同じならば $(PARLANCE Yes)))
 +   $(TR $(TD AssignableElements)
 +        $(TD すべてのレンジがサポートしており、要素の型も同じならば $(PARLANCE Yes))))
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Concat)
 +/
auto concat(Ranges...)(Ranges ranges)
if (Ranges.length > 0 &&
    allSatisfy!(isInputRange, staticMap!(Unqual, Ranges)) &&
    !is(CommonType!(staticMap!(ElementType, staticMap!(Unqual, Ranges))) == void))
{
    return std.range.chain(ranges);
}

///
unittest
{
    static assert([1, 2, 3].concat([4, 5, 6], [7, 8, 9]).sequenceEqual([1, 2, 3, 4, 5, 6, 7, 8, 9]));
}

/++
 + 指定した要素がレンジに含まれているかどうかを判断します。
 +
 + 要素の比較関数 $(D_PARAM compare) を使用して、$(D_PARAM range) に $(D_PARAM value) が含まれているかどうかを判断します。
 +
 + Params:
 + compare = 値を比較する関数。
 + range = 操作対象のレンジ。
 + value = 検索対象の値。
 +
 + Returns:
 + 指定した値がレンジに含まれている場合は $(D_KEYWORD true)。それ以外は $(D_KEYWORD false)。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Contains)
 +/
bool contains(alias compare = "a == b", Range, T)(Range range, T value)
if (isInputRange!Range)
{
    for (; !range.empty; range.popFront())
    {
        if (buildFunction!compare(range.front, value))
            return true;
    }
    static if (!isInfinite!Range)
        return false;
}

///
unittest
{
    static assert([1, 2, 3].contains(3));
    static assert(![1, 2, 3].contains(7));
    static assert([1, 2, 3].contains!"a % 5 == b % 5"(7));
}

private struct ConvertRange(Range, Target)
if (isInputRange!Range)
{
    private Range _source;
    private alias E = ElementType!Range;
    private enum isAssignable = is(typeof(Range.init.front = to!E(Target.init)));

    static if (isInfinite!Range)
        enum empty = false;
    else
        @property auto empty()
        {
            return _source.empty;
        }

    static if (hasLength!Range)
    {
        @property auto length()
        {
            return _source.length;
        }

        alias opDollar = length;
    }

    static if (hasSlicing!Range)
        auto opSlice(in size_t lower, in size_t upper)
        {
            assert(lower <= upper);
            static if (hasLength!Range)
                assert(upper <= _source.length);
            return typeof(this)(_source[lower .. upper]);
        }

    @property Target front()
    {
        assert(!_source.empty);
        return to!Target(_source.front);
    }

    static if (isAssignable)
        @property void front(Target value)
        {
            assert(!_source.empty);
            _source.front = to!E(value);
        }

    void popFront()
    {
        assert(!_source.empty);
        _source.popFront();
    }

    static if (isForwardRange!Range)
        @property auto save()
        {
            return typeof(this)(_source.save);
        }

    static if (isBidirectionalRange!Range)
    {
        @property Target back()
        {
            assert(!_source.empty);
            return to!Target(_source.back);
        }

        static if (isAssignable)
            @property void back(Target value)
            {
                assert(!_source.empty);
                _source.back = to!E(value);
            }

        void popBack()
        {
            assert(!_source.empty);
            _source.popBack();
        }
    }

    static if (isRandomAccessRange!Range)
    {
        Target opIndex(in size_t index)
        {
            static if (hasLength!Range)
                assert(index < _source.length);
            return to!Target(_source[index]);
        }

        static if (isAssignable)
            void opIndexAssign(Target value, in size_t index)
            {
                static if (hasLength!Range)
                    assert(index < _source.length);
                _source[index] = to!E(value);
            }
    }
}

/++
 + レンジの各要素を指定した型へ変換します。
 +
 + このメソッドは遅延実行を使用して実装されます。
 + アクションの実行に必要なすべての情報を格納するレンジがすぐに返されます。
 + このプロパティによって取得したレンジは、$(D_KEYWORD foreach) ステートメントなどで列挙を開始するまで評価されません。
 +
 + このプロパティを使用することで、レンジの要素を任意の型へ変換することができます。
 + 変換は言語の $(D_KEYWORD cast) 演算子を使用するのではなく、標準ライブラリの$(REF std.conv.to)テンプレート関数を使用します。
 + したがって、$(D_KEYWORD int) から $(D_KEYWORD string) への変換など、$(D_KEYWORD cast) 演算子では実現できない変換を行うことができます。
 +
 + Params:
 + Target = 変換後の型。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + 指定した型に変換された各要素が格納されているレンジ。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(D_PARAM range) と同様))
 +   $(TR $(TD Infinite)
 +        $(TD $(D_PARAM range) と同様))
 +   $(TR $(TD Length)
 +        $(TD $(D_PARAM range) と同様))
 +   $(TR $(TD Slicing)
 +        $(TD $(D_PARAM range) と同様))
 +   $(TR $(TD LvalueElements)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD AssignableElements)
 +        $(TD $(D_PARAM range) がサポートしており、かつ $(D_PARAM Target) から $(INLINE_CODE ElementType!(typeof(range))) へ逆変換可能なら $(PARLANCE Yes))))
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Cast)
 +/
@property auto convert(Target, Range)(Range range)
if (isInputRange!Range)
{
    return ConvertRange!(Range, Target)(range);
}

///
unittest
{
    static assert([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].convert!double.average == 5.5);
    int[] a = [1, 2, 3];
    auto r = a.convert!string;
    r.front = "123";
    assert(a.front == 123);
}

/++
 + 条件を満たす要素の数を取得します。
 +
 + $(D_PARAM range) の要素について、$(D_PARAM predicate) が $(D_KEYWORD true) を返す要素の数を取得します。
 +
 + $(D_PARAM predicate) が常に $(D_KEYWORD true) を返すことがコンパイル時にわかり、
 + かつ$(D_PARAM range) が $(PARLANCE Range.length) プロパティをサポートしている場合は、$(D_PARAM range) の $(PARLANCE Range.length) と等価になります。
 +
 + Params:
 + predicate = 各要素が条件を満たしているかどうかをテストする関数。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + $(D_PARAM predicate) の条件を満たす要素の数。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Count)
 +/
@property size_t count(alias predicate = "true", Range)(Range range)
if (isInputRange!Range && !isInfinite!Range)
{
    enum alwaysTrue = __traits(compiles,
    {
        enum x = buildFunction!predicate();
        static assert(x);
    });

    static if (alwaysTrue && hasLength!Range)
    {
        return range.length;
    }
    else
    {
        size_t n;
        for (; !range.empty; range.popFront())
        {
            static if (!alwaysTrue)
                if (!buildFunction!predicate(range.front))
                    continue;
            ++n;
        }
        return n;
    }
}

///
unittest
{
    enum source = [1, 2, 3];
    static assert(source.count == 3);
    static assert(source.count!"a % 2 == 1" == 2);
}

private struct CountingRange(T, bool isInfinite)
{
    private T _start;
    static if (!isInfinite)
        private T _finish;

    static if (isInfinite)
        enum empty = false;
    else
        @property bool empty()
        {
            return _start == _finish;
        }

    static if (!isInfinite)
    {
        @property size_t length()
        {
            return _finish - _start;
        }

        alias opDollar = length;
    }

    static if (!isInfinite)
    auto opSlice(in size_t lower, in size_t upper)
        {
            assert(lower <= upper);
            assert(upper <= length);
            return typeof(this)(cast(T)(_start + lower), cast(T)(_start + upper));
        }

    @property T front()
    {
        assert(!empty);
        return _start;
    }

    void popFront()
    {
        assert(!empty);
        ++_start;
    }

    @property auto save()
    {
        static if (isInfinite)
            return typeof(this)(_start);
        else
            return typeof(this)(_start, _finish);
    }

    static if (!isInfinite)
    {
        @property T back()
        {
            assert(!empty);
            return _finish - 1;
        }

        void popBack()
        {
            assert(!empty);
            --_finish;
        }
    }

    T opIndex(in size_t index)
    {
        static if (!isInfinite)
            assert(index < length);
        return cast(T)(_start + index);
    }
}

private struct Infinity { };

private struct Counting(string interval)
if (interval == "[]" || interval == "()" || interval == "(]" || interval == "[)")
{
    static auto opSlice(S, F)(S start, F finish)
    {
        return opSliceInternal!(Unqual!S, Unqual!F)(start, finish);
    }

    private static auto opSliceInternal(S, F)(S start, F finish)
    {
        static if (interval[0] == '(')
            ++start;
        enum isInfinite = is(F == Infinity);
        static if (isInfinite)
        {
            return CountingRange!(S, isInfinite)(start);
        }
        else
        {
            static if (interval[1] == ']')
                ++finish;
            assert(start <= finish);
            return CountingRange!(CommonType!(S, F), isInfinite)(start, finish);
        }
    }
}

/++
 + 連続した数値のレンジを生成します。
 +
 + $(D_PARAM start) および $(D_PARAM finish) の範囲を表すレンジを生成します。
 +
 + Params:
 + interval = 生成される数値の範囲を制御するための区間記号。
 +            $(TABLE
 +              $(TR $(TD "[]")
 +                   $(TD 閉区間))
 +              $(TR $(TD "[]")
 +                   $(TD 開区間))
 +              $(TR $(TD "[$(RPAREN)")
 +                   $(TD 左閉右開区間))
 +              $(TR $(TD "$(LPAREN)]")
 +                   $(TD 左開右閉区間)))
 +
 + Returns:
 + $(D_PARAM start) から $(D_PARAM finish) の範囲をもつレンジ。
 + $(D_PARAM finish) に $(D_PSYMBOL infinity) を指定した場合、無限のレンジを返します。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(PARLANCE RandomAccessRange)))
 +   $(TR $(TD Infinite)
 +        $(TD $(D_PARAM finish) に $(D_PSYMBOL infinity) を指定した場合は $(PARLANCE Yes)))
 +   $(TR $(TD Length)
 +        $(TD $(D_PARAM finish) に $(D_PSYMBOL infinity) を指定した場合は $(PARLANCE No)))
 +   $(TR $(TD Slicing)
 +        $(TD $(PARLANCE Yes)))
 +   $(TR $(TD LvalueElements)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD AssignableElements)
 +        $(TD $(PARLANCE No))))
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Range)
 +/
@property auto counting(string interval = "[)")()
if (interval == "[]" || interval == "()" || interval == "(]" || interval == "[)")
{
    return Counting!interval.init;
}

/// ditto
enum infinity = Infinity.init;

///
unittest
{
    static assert(isInfinite!(typeof(counting[0 .. infinity])));
    static assert(!isInfinite!(typeof(counting[0 .. 10])));
    static assert(counting[0 .. 10].sequenceEqual([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]));
    static assert(counting!"[]"[0 .. 10].sequenceEqual([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]));
    static assert(counting!"()"[0 .. 10].sequenceEqual([   1, 2, 3, 4, 5, 6, 7, 8, 9    ]));
    static assert(counting!"(]"[0 .. 10].sequenceEqual([   1, 2, 3, 4, 5, 6, 7, 8, 9, 10]));
    static assert(counting!"[)"[0 .. 10].sequenceEqual([0, 1, 2, 3, 4, 5, 6, 7, 8, 9    ]));
}

/++
 + 指定されたレンジの要素を返します。レンジが空の場合はデフォルト値を返します。
 +
 + このメソッドは遅延実行を使用して実装されます。
 + アクションの実行に必要なすべての情報を格納するレンジがすぐに返されます。
 + このプロパティによって取得したレンジは、$(D_KEYWORD foreach) ステートメントなどで列挙を開始するまで評価されません。
 +
 + $(D_PARAM range) の要素を順番に返します。ただし、$(D_PARAM range) が空の場合はデフォルト値を返します。
 +
 + Params:
 + range = 操作対象のレンジ。
 + defaultValue = レンジが空の場合に返す値。
 +
 + Returns:
 + $(D_PARAM range) が空の場合はデフォルト値 ($(D_PARAM defaultValue) または $(INLINE_CODE ElementType!Range.init)) をただひとつ含むレンジ。それ以外の場合は $(D_PARAM range)。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(PARLANCE InputRange)))
 +   $(TR $(TD Infinite)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Length)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Slicing)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD LvalueElements)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD AssignableElements)
 +        $(TD $(PARLANCE No))))
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.DefaultIfEmpty)
 +
 + Bugs:
 + $(LI コンパイルタイムに評価可能なレンジを取得することができません)
 +/
auto defaultIfEmpty(Range, T)(Range range, T defaultValue)
if (isInputRange!Range)
{
    alias E = CommonType!(ElementType!Range, T);
    return block!((Yield!E yield)
    {
        if (range.empty)
        {
            yield = defaultValue;
        }
        else
        {
            foreach (item; range)
            {
                yield = item;
            }
        }
    });
}

/// ditto
@property auto defaultIfEmpty(Range)(Range range)
if (isInputRange!Range)
{
    return range.defaultIfEmpty(ElementType!Range.init);
}

///
unittest
{
    assert([1, 2, 3].defaultIfEmpty.sequenceEqual([1, 2, 3]));
    assert(nothing!int.defaultIfEmpty.sequenceEqual([int.init]));
    assert(nothing!int.defaultIfEmpty(123).sequenceEqual([123]));
}

private struct DistinctRange(Range, alias compare)
if (isInputRange!Range)
{
    private enum isDefaultComparison = is(typeof(compare) : string) && compare == "a == b";

    private Range _source;
    static if (isDefaultComparison)
    {
        Nothing[ElementType!Range] _memo;
    }
    else
        private const(ElementType!Range)[] _memo;

    static if (isInfinite!Range)
        enum empty = false;
    else
        @property auto empty()
        {
            return _source.empty;
        }

    @property auto front()
    {
        assert(!empty);
        return _source.front;
    }

    void popFront()
    {
        assert(!empty);
        static if (isDefaultComparison)
        {
            _memo[_source.front] = Nothing.init;
            do
            {
                _source.popFront();
            } while (!_source.empty && _source.front in _memo);
        }
        else
        {
            _memo ~= _source.front;
            do
            {
                _source.popFront();
            } while (!_source.empty && _memo.contains!compare(_source.front));
        }
    }
}

/++
 + レンジから一意の要素のみを抽出します。
 +
 + このメソッドは遅延実行を使用して実装されます。
 + アクションの実行に必要なすべての情報を格納するレンジがすぐに返されます。
 + このプロパティによって取得したレンジは、$(D_KEYWORD foreach) ステートメントなどで列挙を開始するまで評価されません。
 +
 + $(D_PARAM range) から重複した要素を取り除き、一意の要素のみを取得します。
 + $(U レンジの要素がソートされている必要はありません。)
 +
 + 要素の比較には、$(D_STRING "a == b") を使用します。この場合、一意性の判定に連想配列を使用します。
 + 独自の比較関数を指定した場合、一意性の判定には配列を使用します。
 +
 + Params:
 + compare = 値を比較する関数。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + $(D_PARAM range) の一意の要素を格納するレンジ。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(PARLANCE InputRange)))
 +   $(TR $(TD Infinite)
 +        $(TD $(D_PARAM range) と同様))
 +   $(TR $(TD Length)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Slicing)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD LvalueElements)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD AssignableElements)
 +        $(TD $(PARLANCE No))))
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Distinct)
 +/
@property auto distinct(alias compare = "a == b", Range)(Range range)
if (isInputRange!Range)
{
    return DistinctRange!(Range, compare)(range);
}

///
unittest
{
    static assert([1, 2, 3, 3, 2, 1, 4].distinct.sequenceEqual([1, 2, 3, 4]));
    static assert([1, 2, 3, 4, 5, 6, 7].distinct!"a % 4 == b % 4".sequenceEqual([1, 2, 3, 4]));
}

private template DeduceDistributingYieldTypes(alias iterationBlock)
{
    alias DeduceDistributingYieldTypes = Internal!(Parameters!iterationBlock);

    static assert(DeduceDistributingYieldTypes.length >= 2);

    private template Internal(Yields...)
    {
        static if (Yields.length == 0)
            alias Internal = TypeTuple!();
        else static if (is(Yields[0] YieldType == DistributingYield!YieldType))
            alias Internal = TypeTuple!(YieldType, Internal!(Yields[1 .. $]));
        else
            static assert(false);
    }
}

private class DistributingRange(alias iterationBlock)
if (is(DeduceDistributingYieldTypes!iterationBlock))
{
    private alias YieldTypes = DeduceDistributingYieldTypes!iterationBlock;

    private template ReferenceToPointer(T)
    {
        static if (is(T U == Reference!U))
            alias ReferenceToPointer = U*;
        else
            alias ReferenceToPointer = T;
    }

    private alias ToArray(T) = T[];

    private staticMap!(ToArray, staticMap!(ReferenceToPointer, YieldTypes)) _cache;
    private Fiber _fiber;

    private this()
    {
        _fiber = new Fiber(
        {
            staticMap!(DistributingYield, YieldTypes) yields;
            foreach (i, _; YieldTypes)
            {
                yields[i] = DistributingYield!(YieldTypes[i])(&_cache[i]);
            }
            iterationBlock(yields);
        });
        while (_fiber.state != Fiber.State.TERM)
        {
            _fiber.call();
            if ({   foreach (i, _; YieldTypes)
                    {
                        if (_cache[i].length == 0)
                            return false;
                    }
                    return true;
                }())
                break;
        }
    }

    private static struct Range(YieldType)
    {
        private
        {
            static if (is(YieldType Y == Reference!Y))
                Y*[]* _cache;
            else
                YieldType[]* _cache;
            Fiber _fiber;
        }

        @property bool empty()
        {
            return _fiber.state == Fiber.State.TERM && _cache.length == 0;
        }

        @property auto ref front()
        {
            assert(!empty);
            static if (is(Y))
                return *(*_cache)[0];
            else
                return asRvalue((*_cache)[0]);
        }

        static if (is(Y))
            @property void front(Y value)
            {
                assert(!empty);
                *(*_cache)[0] = value;
            }

        void popFront()
        {
            assert(!empty);
            *_cache = (*_cache)[1 .. $];
            while (_fiber.state != Fiber.State.TERM)
            {
                if ((*_cache).length != 0)
                    break;
                _fiber.call();
            }
        }
    }

    @property auto channel(size_t index)()
    {
        return Range!(YieldTypes[index])(&_cache[index], _fiber);
    }
}

/++
 + 分配可能なイテレータ ブロック構文を実現します。
 +
 + 単一の $(REF Yield) を受け取る $(D_PSYMBOL block) に対して、
 + $(D_PSYMBOL distribute) では、複数の $(D_PSYMBOL DistributingYield) を受け取ります。
 +
 + Params:
 + iterationBlock = レンジの要素を生産するイテレータ ブロック。
 +
 + Returns:
 + $(D_PARAM iterationBlock) によって生産された要素をもつレンジマネージャ。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(PARLANCE InputRange)))
 +   $(TR $(TD Infinite)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Length)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Slicing)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD LvalueElements)
 +        $(TD $(D_PSYMBOL DistributingYield) で $(REF Reference) 指定した場合は $(PARLANCE Yes)))
 +   $(TR $(TD AssignableElements)
 +        $(TD $(D_PSYMBOL DistributingYield) で $(REF Reference) 指定した場合は $(PARLANCE Yes))))
 +/
@property DistributingRange!iterationBlock distribute(alias iterationBlock)()
if (is(DeduceDistributingYieldTypes!iterationBlock))
{
    return new typeof(return);
}

/// ditto
struct DistributingYield(YieldType)
{
    static if (is(YieldType Y == Reference!Y))
        private Y*[]* _cache;
    else
        private YieldType[]* _cache;

    void opAssign(typeof(this) rhs)
    {
        _cache = rhs._cache;
    }

    static if (is(Y))
        void opAssign(ref Y value)
        {
            *_cache ~= &value;
            Fiber.yield();
        }
    else
        void opAssign(YieldType value)
        {
            *_cache ~= value;
            Fiber.yield();
        }
}

/// ditto
alias DistributingYieldReference(YieldType) = DistributingYield!(Reference!YieldType);

///
unittest
{
    auto m = distribute!((DistributingYield!int yield1, DistributingYield!string yield2)
    {
        yield1 = 1;
        yield2 = "A";
        yield1 = 2;
        yield2 = "B";
        yield1 = 3;
        yield2 = "C";
        yield1 = 4;
        yield2 = "D";
        yield1 = 5;
        yield2 = "E";
    });
    assert(equal(m.channel!0, [1, 2, 3, 4, 5]));
    assert(equal(m.channel!1, ["A", "B", "C", "D", "E"]));
}

///
unittest
{
    int[] a = [1, 2, 3, 4, 5];
    auto m = distribute!((DistributingYieldReference!int yield1, DistributingYield!string yield2)
    {
        yield1 = a[0];
        yield2 = "A";
        yield1 = a[1];
        yield2 = "B";
        yield1 = a[2];
        yield2 = "C";
    });
    foreach (ref x; m.channel!0)
    {
        x *= x;
    }
    assert(a == [1*1, 2*2, 3*3, 4, 5]);
    assert(equal(m.channel!1, ["A", "B", "C"]));
}

/++
 + レンジ内の指定されたインデックス位置にある要素を取得します。
 +
 + $(D_PARAM range) が $(PARLANCE RandomAccessRange) の場合、$(PARLANCE Range.opIndex($(D_PARAM index))) が使用されます。
 + ランダムアクセスをサポートしていない場合は、$(I O(n)) のコストを払って要素を取得します。
 +
 + インデックスが範囲外の場合は例外をスローします。
 +
 + Params:
 + range = 操作対象のレンジ。
 + index = 取得する要素の、0 から始まるインデックス値。
 +
 + Returns:
 + $(D_PARAM range) の指定された位置にある要素。
 + $(D_PARAM range) の要素が $(D_KEYWORD ref) 修飾されている場合は、戻り値も $(D_KEYWORD ref) 修飾されます。
 +
 + Throws:
 + $(D_PARAM index) が $(D_PARAM source) に含まれている要素数以上の値です。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.ElementAt)
 +/
auto ref elementAt(Range)(Range range, in size_t index)
if (isInputRange!Range)
{
    static if (hasLength!Range)
    {
        if (index >= range.length)
            throw new Exception("Index is greater than or equal to the number of elements in source sequence.");
    }
    static if (isRandomAccessRange!Range)
    {
        return range[index];
    }
    else
    {
        for (size_t n = 0; !range.empty; ++n, range.popFront())
        {
            if (n == index)
                return range.front;
        }
        static if (!isInfinite!Range)
            throw new Exception("Index is greater than or equal to the number of elements in source sequence.");
    }
}

///
unittest
{
    static assert([1, 2, 3].elementAt(0) == 1);
    static assert([1, 2, 3].elementAt(1) == 2);
    static assert([1, 2, 3].elementAt(2) == 3);
    static assert([1, 2, 3].asInputRange.elementAt(2) == 3);
    static assert(__traits(compiles, &[1, 2, 3].elementAt(2)));
    static assert(__traits(compiles, &[1, 2, 3].asInputRange.elementAt(2)));
    static assert(!__traits(compiles, &[1, 2, 3].asRvalueElements.elementAt(2)));
}

/++
 + レンジ内の指定されたインデックス位置にある要素を取得します。
 +
 + $(D_PARAM range) が $(PARLANCE RandomAccessRange) の場合、$(PARLANCE Range.opIndex($(D_PARAM index))) が使用されます。
 + ランダムアクセスをサポートしていない場合は、$(I O(n)) のコストを払って要素を取得します。
 +
 + インデックスが範囲外の場合は要素型の初期値を返します。
 +
 + Params:
 + range = 操作対象のレンジ。
 + index = 取得する要素の、0 から始まるインデックス値。
 +
 + Returns:
 + $(D_PARAM range) の指定された位置にある要素。
 + インデックスが範囲外の場合は要素型の初期値。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.ElementAtOrDefault)
 +/
ElementType!Range elementAtOrDefault(Range)(Range range, in size_t index)
if (isInputRange!Range)
{
    static if (hasLength!Range)
    {
        if (index >= range.length)
            return typeof(return).init;
    }
    static if (isRandomAccessRange!Range)
    {
        return range[index];
    }
    else
    {
        for (size_t n = 0; !range.empty; ++n, range.popFront())
        {
            if (n == index)
                return range.front;
        }
        static if (!isInfinite!Range)
            return typeof(return).init;
    }
}

///
unittest
{
    static assert([1, 2, 3].elementAtOrDefault(0) == 1);
    static assert([1, 2, 3].elementAtOrDefault(1) == 2);
    static assert([1, 2, 3].elementAtOrDefault(2) == 3);
    static assert([1, 2, 3].elementAtOrDefault(3) == 0);
}

/++
 + レンジの最初の要素を取得します。
 +
 + $(D_PARAM range) の最初の要素を取得します。
 + 条件 $(D_PARAM predicate) を指定するオーバーロードでは、条件を満たす最初の要素を取得します。
 + レンジが空の場合、もしくは条件を満たす要素がひとつも存在しない場合は例外をスローします。
 +
 + Params:
 + predicate = 返される要素が満たすべき条件。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + $(D_PARAM range) の最初の要素。
 + $(D_PARAM range) の要素が $(D_KEYWORD ref) 修飾されている場合は、戻り値も $(D_KEYWORD ref) 修飾されます。
 +
 + Throws:
 + $(D_PARAM range) に要素が含まれていません。
 + または、$(D_PARAM range) に条件 $(D_PARAM predicate) を満たす要素が含まれていません。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.First)
 +/
@property auto ref first(alias predicate, Range)(Range range)
if (isInputRange!Range)
{
    for (; !range.empty; range.popFront())
    {
        if (buildFunction!predicate(range.front))
            return range.front;
    }
    static if (!isInfinite!Range)
        throw new Exception("No element satisfies the condition in predicate.");
}

/// ditto
@property auto ref first(Range)(Range range)
if (isInputRange!Range)
{
    if (range.empty)
        throw new Exception("The source sequence is empty.");
    return range.front;
}

///
unittest
{
    static assert([1, 2, 3].first == 1);
    static assert([1, 2, 3].first!(x => x % 2 == 0) == 2);
    static assert(__traits(compiles, addressof([1, 2, 3].first)));
    static assert(!__traits(compiles, addressof([1, 2, 3].asRvalueElements.first)));
}

/++
 + レンジの最初の要素を取得します。
 +
 + $(D_PARAM range) の最初の要素を取得します。
 + 条件 $(D_PARAM predicate) を指定するオーバーロードでは、条件を満たす最初の要素を取得します。
 + レンジが空の場合、もしくは条件を満たす要素がひとつも存在しない場合は要素型の初期値を返します。
 +
 + Params:
 + predicate = 返される要素が満たすべき条件。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + $(D_PARAM range) の最初の要素。
 + レンジが空の場合、もしくは条件を満たす要素がひとつも存在しない場合は要素型の初期値。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.FirstOrDefault)
 +/
@property ElementType!Range firstOrDefault(alias predicate, Range)(Range range)
if (isInputRange!Range)
{
    for (; !range.empty; range.popFront())
    {
        if (buildFunction!predicate(range.front))
            return range.front;
    }
    static if (!isInfinite!Range)
        return typeof(return).init;
}

/// ditto
@property ElementType!Range firstOrDefault(Range)(Range range)
if (isInputRange!Range)
{
    if (range.empty)
        return typeof(return).init;
    return range.front;
}

///
unittest
{
    static assert([1, 2, 3].firstOrDefault == 1);
    static assert([1, 2, 3].firstOrDefault!"a == 4" == int.init);
}

/++
 + レンジの最後の要素を取得します。
 +
 + $(D_PARAM range) の最後の要素を取得します。
 + 条件 $(D_PARAM predicate) を指定するオーバーロードでは、条件を満たす最後の要素を取得します。
 +
 + $(D_PARAM range) が $(PARLANCE BidirectionalRange) の場合、$(PARLANCE Range.back) を利用します。
 + それ以外の場合は先頭から末尾の要素を検索します。
 +
 + レンジが空の場合、もしくは条件を満たす要素がひとつも存在しない場合は例外をスローします。
 +
 + Params:
 + predicate = 返される要素が満たすべき条件。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + $(D_PARAM range) の最後の要素。
 + $(D_PARAM range) の要素が $(D_KEYWORD ref) 修飾されている場合は、戻り値も $(D_KEYWORD ref) 修飾されます。
 +
 + Throws:
 + $(D_PARAM range) に要素が含まれていません。
 + または、$(D_PARAM range) に条件 $(D_PARAM predicate) を満たす要素が含まれていません。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Last)
 +/
@property auto ref last(alias predicate, Range)(Range range)
if (isInputRange!Range && !isInfinite!Range)
{
    static if (isBidirectionalRange!Range)
    {
        for (; !range.empty; range.popBack())
        {
            if (buildFunction!predicate(range.back))
                return range.back;
        }
    }
    else
    {
        static if (hasLvalueElements!Range)
            ElementType!Range* value;
        else
        {
            ElementType!Range value = void;
            bool found = false;
        }
        for (; !range.empty; range.popFront())
        {
            if (!buildFunction!predicate(range.front))
                continue;
            static if (hasLvalueElements!Range)
                value = addressof(range.front);
            else
            {
                value = range.front;
                found = true;
            }
        }
        static if (hasLvalueElements!Range)
        {
            if (value !is null)
                return *value;
        }
        else
        {
            if (found)
                return asRvalue(value);
        }
    }
    throw new Exception("No element satisfies the condition in predicate.");
}

/// ditto
@property auto ref last(Range)(Range range)
if (isInputRange!Range && !isInfinite!Range)
{
    if (range.empty)
        throw new Exception("The source sequence is empty.");
    static if (isBidirectionalRange!Range)
    {
        return range.back;
    }
    else
    {
        static if (hasLvalueElements!Range)
            auto value = addressof(range.front);
        else
            auto value = range.front;
        range.popFront();
        for (; !range.empty; range.popFront())
        {
            static if (hasLvalueElements!Range)
                value = addressof(range.front);
            else
                value = range.front;
        }
        static if (hasLvalueElements!Range)
            return *value;
        else
            return asRvalue(value);
    }
}

///
unittest
{
    static assert([1, 2, 3].last == 3);
    static assert([1, 2, 3].last!"a % 2 != 0" == 3);
    static assert(__traits(compiles, [1, 2, 3].last = 0));
    static assert(!__traits(compiles, [1, 2, 3].asRvalueElements.last = 0));
}

///
unittest
{
    static assert([1, 2, 3].asInputRange.last == 3);
    static assert([1, 2, 3].asInputRange.last!"a % 2 != 0" == 3);
    static assert(__traits(compiles, [1, 2, 3].asInputRange.last = 0));
    static assert(!__traits(compiles, [1, 2, 3].asInputRange.asRvalueElements.last = 0));
}

/++
 + レンジの最後の要素を取得します。
 +
 + $(D_PARAM range) の最後の要素を取得します。
 + 条件 $(D_PARAM predicate) を指定するオーバーロードでは、条件を満たす最後の要素を取得します。
 +
 + $(D_PARAM range) が $(PARLANCE BidirectionalRange) の場合、$(PARLANCE Range.back) を利用します。
 + それ以外の場合は先頭から末尾の要素を検索します。
 +
 + レンジが空の場合、もしくは条件を満たす要素がひとつも存在しない場合は要素型の初期値を返します。
 +
 + Params:
 + predicate = 返される要素が満たすべき条件。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + $(D_PARAM range) の最後の要素。
 + レンジが空の場合、もしくは条件を満たす要素がひとつも存在しない場合は要素型の初期値。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.LastOrDefault)
 +/
@property ElementType!Range lastOrDefault(alias predicate, Range)(Range range)
if (isInputRange!Range && !isInfinite!Range)
{
    static if (isBidirectionalRange!Range)
    {
        for (; !range.empty; range.popBack())
        {
            if (buildFunction!predicate(range.back))
                return range.back;
        }
    }
    else
    {
        static if (hasLvalueElements!Range)
            ElementType!Range* value;
        else
        {
            ElementType!Range value = void;
            bool found = false;
        }
        for (; !range.empty; range.popFront())
        {
            if (!buildFunction!predicate(range.front))
                continue;
            static if (hasLvalueElements!Range)
                value = addressof(range.front);
            else
            {
                value = range.front;
                found = true;
            }
        }
        static if (hasLvalueElements!Range)
        {
            if (value !is null)
                return *value;
        }
        else
        {
            if (found)
                return asRvalue(value);
        }
    }
    return typeof(return).init;
}

/// ditto
@property ElementType!Range lastOrDefault(Range)(Range range)
if (isInputRange!Range && !isInfinite!Range)
{
    if (range.empty)
        return typeof(return).init;
    static if (isBidirectionalRange!Range)
    {
        return range.back;
    }
    else
    {
        static if (hasLvalueElements!Range)
            auto value = addressof(range.front);
        else
            auto value = range.front;
        range.popFront();
        for (; !range.empty; range.popFront())
        {
            static if (hasLvalueElements!Range)
                value = addressof(range.front);
            else
                value = range.front;
        }
        static if (hasLvalueElements!Range)
            return *value;
        else
            return value;
    }
}

///
unittest
{
    static assert([1, 2, 3].lastOrDefault == 3);
    static assert([1, 2, 3].lastOrDefault!"a % 2 != 0" == 3);
}

///
unittest
{
    static assert([1, 2, 3].asInputRange.lastOrDefault == 3);
    static assert([1, 2, 3].asInputRange.lastOrDefault!"a % 2 != 0" == 3);
}

/++
 + レンジの要素の最小値を取得します。
 +
 + Params:
 + range = 操作対象のレンジ。
 +
 + Returns:
 + $(D_PARAM range) の最小値。
 + $(D_PARAM range) の要素が $(D_KEYWORD ref) 修飾されている場合は、戻り値も $(D_KEYWORD ref) 修飾されます。
 +
 + Throws:
 + $(D_PARAM range) に要素が含まれていません。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Min)
 +/
@property auto ref minimum(alias compare = "a < b", Range)(Range range)
if (isInputRange!Range && !isInfinite!Range)
{
    if (range.empty)
        throw new Exception("The source sequence is empty.");
    static if (hasLvalueElements!Range)
        auto value = addressof(range.front);
    else
        auto value = range.front;
    range.popFront();
    for (; !range.empty; range.popFront())
    {
        static if (hasLvalueElements!Range)
        {
            if (buildFunction!compare(range.front, *value))
            {
                value = addressof(range.front);
            }
        }
        else
        {
            if (buildFunction!compare(range.front, asRvalue(value)))
            {
                value = range.front;
            }
        }
    }
    static if (hasLvalueElements!Range)
        return *value;
    else
        return asRvalue(value);
}

///
unittest
{
    static assert([1, 2, 3].asRvalueElements.minimum == 1);
    static assert([1, 2, 3].asRvalueElements.minimum!"a > b" == 3);
    static assert(__traits(compiles, addressof([1, 2, 3].minimum)));
    static assert(!__traits(compiles, addressof([1, 2, 3].asRvalueElements.minimum)));
}

/++
 + レンジの要素の最大値を取得します。
 +
 + Params:
 + range = 操作対象のレンジ。
 +
 + Returns:
 + $(D_PARAM range) の最大値。
 + $(D_PARAM range) の要素が $(D_KEYWORD ref) 修飾されている場合は、戻り値も $(D_KEYWORD ref) 修飾されます。
 +
 + Throws:
 + $(D_PARAM range) に要素が含まれていません。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Max)
 +/
@property auto ref maximum(alias compare = "a < b", Range)(Range range)
if (isInputRange!Range && !isInfinite!Range)
{
    if (range.empty)
        throw new Exception("The source sequence is empty.");
    static if (hasLvalueElements!Range)
        auto value = addressof(range.front);
    else
        auto value = range.front;
    range.popFront();
    for (; !range.empty; range.popFront())
    {
        static if (hasLvalueElements!Range)
        {
            if (buildFunction!compare(*value, range.front))
            {
                value = addressof(range.front);
            }
        }
        else
        {
            if (buildFunction!compare(asRvalue(value), range.front))
            {
                value = range.front;
            }
        }
    }
    static if (hasLvalueElements!Range)
        return *value;
    else
        return asRvalue(value);
}

///
unittest
{
    static assert([1, 2, 3].asRvalueElements.maximum == 3);
    static assert([1, 2, 3].asRvalueElements.maximum!"a > b" == 1);
    static assert(__traits(compiles, addressof([1, 2, 3].maximum)));
    static assert(!__traits(compiles, addressof([1, 2, 3].asRvalueElements.maximum)));
}

private struct NothingRange(ElementType)
{
    enum empty = true;

    enum size_t length = 0;

    auto opSlice(in size_t lower, in size_t upper)
    {
        assert(lower <= upper);
        assert(upper <= length);
        return typeof(this).init;
    }

    @property ElementType front()
    {
        throw new Exception("Range is empty.");
    }

    @property void front(ElementType value)
    {
        throw new Exception("Range is empty.");
    }

    @property ElementType moveFront()
    {
        throw new Exception("Range is empty.");
    }

    void popFront()
    {
        throw new Exception("Range is empty.");
    }

    @property auto save()
    {
        return typeof(this).init;
    }

    @property ElementType back()
    {
        throw new Exception("Range is empty.");
    }

    @property void back(ElementType value)
    {
        throw new Exception("Range is empty.");
    }

    @property ElementType moveBack()
    {
        throw new Exception("Range is empty.");
    }

    void popBack()
    {
        throw new Exception("Range is empty.");
    }

    ElementType opIndex(in size_t index)
    {
        throw new Exception("Range is empty.");
    }

    void opIndexAssign(ElementType value, in size_t index)
    {
        throw new Exception("Range is empty.");
    }

    ElementType moveAt(in size_t index)
    {
        throw new Exception("Range is empty.");
    }
}

/++
 + 指定した型の空のレンジを取得します。
 +
 + 要素型 $(D_PARAM ElementType) の空のレンジを取得します。
 +
 + Params:
 + ElementType = 取得するレンジの要素型。
 +
 + Returns:
 + 要素型 $(D_PARAM ElementType) をもつ空のレンジ。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(PARLANCE RandomAccessRange)))
 +   $(TR $(TD Infinite)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Length)
 +        $(TD $(PARLANCE Yes)))
 +   $(TR $(TD Slicing)
 +        $(TD $(PARLANCE Yes)))
 +   $(TR $(TD LvalueElements)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD AssignableElements)
 +        $(TD $(PARLANCE Yes))))
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Empty)
 +/
@property auto nothing(ElementType)()
{
    return NothingRange!ElementType.init;
}

///
unittest
{
    static assert(nothing!int.empty);
    alias R = typeof(nothing!int);
    static assert(isRandomAccessRange!R);
}

private struct OfTypeRange(Range, Target)
if (isInputRange!Range)
{
    private Range _source;

    this(Range source)
    {
        _source = source;
        while (!_source.empty && cast(Target)_source.front is null)
        {
            _source.popFront();
        }
        static if (isBidirectionalRange!Range)
            while (!_source.empty && cast(Target)_source.back is null)
            {
                _source.popBack();
            }
    }

    @property bool empty()
    {
        return _source.empty;
    }

    @property Target front()
    {
        assert(!_source.empty);
        return cast(Target)_source.front;
    }

    static if (hasAssignableElements!Range)
        @property void front(ElementType!Range value)
        {
            assert(!_source.empty);
            _source.front = value;
        }

    void popFront()
    {
        assert(!_source.empty);
        do
        {
            _source.popFront();
        } while (!_source.empty && cast(Target)_source.front is null);
    }

    static if (isForwardRange!Range)
        @property auto save()
        {
            return typeof(this)(_source.save);
        }

    static if (isBidirectionalRange!Range)
    {
        @property Target back()
        {
            assert(!_source.empty);
            return cast(Target)_source.back;
        }

        static if (hasAssignableElements!Range)
            @property void back(ElementType!Range value)
            {
                assert(!_source.empty);
                _source.back = value;
            }

        void popBack()
        {
            assert(!_source.empty);
            do
            {
                _source.popBack();
            } while (!_source.empty && cast(Target)_source.back is null);
        }
    }
}

/++
 + 指定された型に基づいてレンジの要素をフィルタ処理します。
 +
 + このメソッドは遅延実行を使用して実装されます。
 + アクションの実行に必要なすべての情報を格納するレンジがすぐに返されます。
 + このプロパティによって取得したレンジは、$(D_KEYWORD foreach) ステートメントなどで列挙を開始するまで評価されません。
 +
 + $(D_PARAM range) の各要素に対して、$(D_PARAM Target) にキャストして $(D_KEYWORD null) にならない要素のみを列挙します。
 +
 + Params:
 + Target = レンジの要素をフィルタ処理する型。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + $(D_PARAM Target) 型の入力レンジの要素を格納するレンジ。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(D_PARAM range) と同様、かつ $(PARLANCE BidirectionalRange) 以下))
 +   $(TR $(TD Infinite)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Length)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Slicing)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD LvalueElements)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD AssignableElements)
 +        $(TD $(D_PARAM range) と同様)))
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.OfType)
 +/
@property auto ofType(Target, Range)(Range range)
if (isInputRange!Range)
{
    return OfTypeRange!(Range, Target)(range);
}

///
unittest
{
    class A { }
    class B : A { }
    class C : A { }
    enum source = [new A, new B, new C, new C, new B, new A, new B];
    static assert(source.ofType!B.count == 3);
    static assert(source.ofType!C.count == 2);
}

private struct PermuteRange(Range)
if (isRandomAccessRange!Range && !isInfinite!Range && hasLength!Range)
{
    private Range _source;
    private const(size_t)[] _indexes;

    @property auto empty()
    {
        return _indexes.empty;
    }

    @property auto length()
    {
        return _indexes.length;
    }

    alias opDollar = length;

    auto opSlice(in size_t lower, in size_t upper)
    {
        assert(lower <= upper);
        assert(upper <= length);
        return typeof(this)(_source, _indexes[lower .. upper]);
    }

    @property auto ref front()
    {
        assert(!empty);
        return _source[_indexes.front];
    }

    static if (hasAssignableElements!Range)
        @property void front(ElementType!Range value)
        {
            assert(!empty);
            _source[_indexes.front] = value;
        }

    void popFront()
    {
        assert(!empty);
        _indexes.popFront();
    }

    @property auto save()
    {
        return typeof(this)(_source, _indexes.save);
    }

    @property auto ref back()
    {
        assert(!empty);
        return _source[_indexes.back];
    }

    static if (hasAssignableElements!Range)
        @property void back(ElementType!Range value)
        {
            assert(!empty);
            _source[_indexes.back] = value;
        }

    void popBack()
    {
        assert(!empty);
        _indexes.popBack();
    }

    auto ref opIndex(in size_t index)
    {
        assert(index < _source.length);
        return _source[_indexes[index]];
    }

    static if (hasAssignableElements!Range)
        void opIndexAssign(ElementType!Range value, in size_t index)
        {
            assert(index < _source.length);
            _source[_indexes[index]] = value;
        }
}

/++
 + 指定された比較子を使用してレンジの要素を並べ替えます。
 +
 + このメソッドは遅延実行を使用して実装されます。
 + アクションの実行に必要なすべての情報を格納するレンジがすぐに返されます。
 + このプロパティによって取得したレンジは、$(D_KEYWORD foreach) ステートメントなどで列挙を開始するまで評価されません。
 +
 + $(D_PARAM range) の要素を比較関数 $(D_PARAM compare) に基づいてソートします。比較を行うキーは $(D_PARAM keyof) によって取得されます。
 + $(D_PARAM range) 自体の要素をソートした場合は、デフォルトのセレクタ $(D_STRING "a") を使用します。
 +
 + Params:
 + keyof = 要素からキーを取得する関数。
 + compare = キーの比較を行う関数。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + 要素がキーに従って並び変えられているレンジ。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(PARLANCE RandomAccessRange)))
 +   $(TR $(TD Infinite)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Length)
 +        $(TD $(PARLANCE Yes)))
 +   $(TR $(TD Slicing)
 +        $(TD $(PARLANCE Yes)))
 +   $(TR $(TD LvalueElements)
 +        $(TD $(D_PARAM range) と同様))
 +   $(TR $(TD AssignableElements)
 +        $(TD $(D_PARAM range) と同様)))
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.OrderBy)
 +/
@property auto orderBy(alias keyof = "a", alias compare = "a < b", Range)(Range range)
if (isRandomAccessRange!Range && !isInfinite!Range && hasLength!Range)
{
    auto indexes = new size_t[range.length];
    makeIndex!((x, y) => buildFunction!compare(buildFunction!keyof(x), buildFunction!keyof(y)))(range, indexes);
    return PermuteRange!Range(range, cast(immutable(size_t)[])indexes);
}

///
unittest
{
    static assert([1, 3, 5, 2, 4].orderBy.sequenceEqual([1, 2, 3, 4, 5]));
    static assert([1, 3, 5, 2, 4].orderBy!"-a".sequenceEqual([5, 4, 3, 2, 1]));
    static assert([1, 3, 5, 2, 4].orderBy!("-a", "a > b").sequenceEqual([1, 2, 3, 4, 5]));
}

private struct PermutationRange(Range, alias compare)
if (isInputRange!Range && !isInfinite!Range)
{
    private ElementType!Range[] _elements;

    this(Range range)
    {
        if (!range.empty)
        {
            _elements = array(range);
        }
    }

    @property auto empty()
    {
        return _elements is null;
    }

    @property auto length()
    {
        size_t length = 1;
        foreach (n; counting!"[]"[2 .. _elements.length])
        {
            length *= n;
        }
        return length;
    }

    alias opDollar = length;

    @property auto front()
    {
        assert(!empty);
        return cast(const(ElementType!Range)[])_elements;
    }

    void popFront()
    {
        assert(!empty);
        foreach_reverse (i; 0 .. _elements.length - 1)
        {
            if (!buildFunction!compare(_elements[i], _elements[i + 1]))
                continue;
            foreach_reverse (ii; 0 .. _elements.length)
            {
                if (!buildFunction!compare(_elements[i], _elements[ii]))
                    continue;
                swap(_elements[i], _elements[ii]);
                _elements[i + 1 .. $].reverse();
                return;
            }
            assert(false);
        }
        _elements = null;
    }
}

/++
 + すべての順列を列挙します。
 +
 + $(D_PARAM range) の全要素について、あらゆる組み合わせを列挙します。
 +
 + このメソッドは遅延実行を使用して実装されます。
 + アクションの実行に必要なすべての情報を格納するレンジがすぐに返されます。
 + このプロパティによって取得したレンジは、$(D_KEYWORD foreach) ステートメントなどで列挙を開始するまで評価されません。
 +
 + Params:
 + range = 操作対象のレンジ。
 +
 + Returns:
 + レンジが表す要素のあらゆる組み合わせ。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(PARLANCE InputRange)))
 +   $(TR $(TD Infinite)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Length)
 +        $(TD $(PARLANCE Yes)))
 +   $(TR $(TD Slicing)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD LvalueElements)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD AssignableElements)
 +        $(TD $(PARLANCE No))))
 +
 + See_Also:
 + $(LI C++ algorithm next_permutation)
 +/
@property auto permutations(alias compare = "a < b", Range)(Range range)
if (isInputRange!Range && !isInfinite!Range)
{
    return PermutationRange!(Range, compare)(range);
}

///
unittest
{
    static assert("012".permutations.elementAt(0) == "012");
    static assert("012".permutations.elementAt(1) == "021");
    static assert("012".permutations.elementAt(2) == "102");
    static assert("012".permutations.elementAt(3) == "120");
    static assert("012".permutations.elementAt(4) == "201");
    static assert("012".permutations.elementAt(5) == "210");
    static assert("012".permutations.length == 6);
    static assert("0123".permutations.length == 24);
}

private struct SelectionRange(Range, alias selector)
if (isInputRange!Range)
{
    private alias E = typeof(buildFunction!selector(Range.init.front));
    private enum isAssignable = is(typeof(addressof(buildFunction!selector(Range.init.front))));
    private Range _source;

    static if (isInfinite!Range)
        enum empty = false;
    else
        @property auto empty()
        {
            return _source.empty;
        }

    static if (hasLength!Range)
    {
        @property auto length()
        {
            return _source.length;
        }

        alias opDollar = length;
    }

    static if (hasSlicing!Range)
        auto opSlice(in size_t lower, in size_t upper)
        {
            assert(lower <= upper);
            static if (hasLength!Range)
                assert(upper <= _source.length);
            return typeof(this)(_source[lower .. upper]);
        }

    @property auto ref front()
    {
        assert(!_source.empty);
        return buildFunction!selector(_source.front);
    }

    static if (isAssignable)
        @property void front(E value)
        {
            assert(!_source.empty);
            *addressof(front) = value;
        }

    void popFront()
    {
        assert(!_source.empty);
        _source.popFront();
    }

    static if (isForwardRange!Range)
        @property auto save()
        {
            return typeof(this)(_source.save);
        }

    static if (isBidirectionalRange!Range)
    {
        @property auto ref back()
        {
            assert(!_source.empty);
            return buildFunction!selector(_source.back);
        }

        static if (isAssignable)
            @property void back(E value)
            {
                assert(!_source.empty);
                *addressof(back) = value;
            }

        void popBack()
        {
            assert(!_source.empty);
            _source.popBack();
        }
    }

    static if (isRandomAccessRange!Range)
    {
        auto ref opIndex(in size_t index)
        {
            static if (hasLength!Range)
                assert(index < _source.length);
            return buildFunction!selector(_source[index]);
        }

        static if (isAssignable)
            void opIndexAssign(E value, in size_t index)
            {
                static if (hasLength!Range)
                    assert(index < _source.length);
                *addressof(this[index]) = value;
            }
    }
}

/++
 + レンジの各要素を新しいフォームに射影します。
 +
 + このメソッドは遅延実行を使用して実装されます。
 + アクションの実行に必要なすべての情報を格納するレンジがすぐに返されます。
 + このプロパティによって取得したレンジは、$(D_KEYWORD foreach) ステートメントなどで列挙を開始するまで評価されません。
 +
 + $(D_PARAM range) の各要素に対して $(D_PARAM selector) を適用した結果から構成されるレンジを作成します。
 + $(D_PARAM selector) の結果はキャッシュされないため、このプロパティによって取得したレンジの
 + $(PARLANCE Range.front) プロパティなどの複数回アクセスした場合は、その回数だけ $(D_PARAM selector) が呼び出されます。
 +
 + Params:
 + selector = 各要素に適用する変換関数。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + レンジの各要素に対して変換関数を呼び出した結果として得られる要素を含むレンジ。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(D_PARAM range) と同様))
 +   $(TR $(TD Infinite)
 +        $(TD $(D_PARAM range) と同様))
 +   $(TR $(TD Length)
 +        $(TD $(D_PARAM range) と同様))
 +   $(TR $(TD Slicing)
 +        $(TD $(D_PARAM range) と同様))
 +   $(TR $(TD LvalueElements)
 +        $(TD $(D_PARAM selector) の戻り値が $(D_KEYWORD ref) 修飾されているなら $(PARLANCE Yes)))
 +   $(TR $(TD AssignableElements)
 +        $(TD $(D_PARAM selector) の戻り値が $(D_KEYWORD ref) 修飾されているなら $(PARLANCE Yes))))
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Select)
 +/
@property auto select(alias selector, Range)(Range range)
if (isInputRange!Range)
{
    return SelectionRange!(Range ,selector)(range);
}

///
unittest
{
    static assert([1, 2, 3].select!"a * a".sequenceEqual([1, 4, 9]));
    static assert([1, 2, 3].select!"a * a"[$ - 1] == 9);
}

/++
 + ふたつのレンジが等しいかどうかを判断します。
 +
 + 比較演算子 $(D_PARAM compare) を使用して、ふたつのレンジ $(D_PARAM range1) および $(D_PARAM range2) が等しいかどうかを判断します。
 +
 + Params:
 + compare = 要素の比較を行う関数。
 + range1 = 操作対象のレンジ。
 + range2 = 操作対象のレンジ。
 +
 + Returns:
 + $(D_PARAM range1) と $(D_PARAM range2) の要素数が等しく、かつ、同じインデックス値の要素同士に対して
 + $(D_PARAM compare) が $(D_KEYWORD true) を返す場合は $(D_KEYWORD true)。それ以外は $(D_KEYWORD false)。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.SequenceEqual)
 +/
@property bool sequenceEqual(alias compare = "a == b", Range1, Range2)(Range1 range1, Range2 range2)
if (isInputRange!Range1 && isInputRange!Range2 && (!isInfinite!Range1 || !isInfinite!Range2))
{
    static if (isInfinite!Range1 != isInfinite!Range2)
    {
        // 有限 vs 無限は常に等しくない
        return false;
    }
    static if (hasLength!Range1 && hasLength!Range2)
    {
        if (range1.length != range2.length)
            return false;
        for (; !range1.empty; range1.popFront(), range2.popFront())
        {
            if (!buildFunction!compare(range1.front, range2.front))
                return false;
        }
        return true;
    }
    else
    {
        for (; !range1.empty && !range2.empty; range1.popFront(), range2.popFront())
        {
            if (!buildFunction!compare(range1.front, range2.front))
                return false;
        }
        return range1.empty && range2.empty;
    }
}

///
unittest
{
    static assert([1, 2, 3].sequenceEqual([1, 2, 3]));
    static assert(![1, 2, 3].sequenceEqual([1, 2, 3, 4]));
    static assert(![1, 2, 3, 4].sequenceEqual([1, 2, 3]));
    static assert([1, 2, 3].asDisabledLength.sequenceEqual([1, 2, 3].asReadOnlyElements));
    static assert([1, 3, 5].sequenceEqual!((x, y) => x % 2 == y)([1, 1, 1]));
}

/++
 + レンジの唯一の要素を取得します。
 +
 + $(D_PARAM range) の唯一の要素を取得します。
 + 条件 $(D_PARAM predicate) を指定するオーバーロードでは、条件を満たす唯一の要素を取得します。
 + レンジが空の場合、もしくは条件を満たす要素が複数存在する場合は例外をスローします。
 +
 + Params:
 + predicate = 返される要素が満たすべき条件。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + $(D_PARAM range) の唯一の要素。
 + $(D_PARAM range) の要素が $(D_KEYWORD ref) 修飾されている場合は、戻り値も $(D_KEYWORD ref) 修飾されます。
 +
 + Throws:
 + $(D_PARAM range) に要素が含まれていません。
 + または、$(D_PARAM range) に複数の要素が含まれています。
 + または、$(D_PARAM range) に条件 $(D_PARAM predicate) を満たす要素が含まれていません。
 + または、$(D_PARAM range) に条件 $(D_PARAM predicate) を満たす複数の要素が含まれています。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Single)
 +/
@property auto ref single(alias predicate, Range)(Range range)
if (isInputRange!Range)
{
    for (; !range.empty && !buildFunction!predicate(range.front); range.popFront()) { }
    if (range.empty)
        throw new Exception("No element satisfies the condition in predicate.");
    static if (hasLvalueElements!Range)
        auto value = addressof(range.front);
    else
        auto value = range.front;
    range.popFront();
    for (; !range.empty; range.popFront())
    {
        if (buildFunction!predicate(range.front))
            throw new Exception("More than one element satisfies the condition in predicate.");
    }
    static if (hasLvalueElements!Range)
        return *value;
    else
        return asRvalue(value);
}

/// ditto
@property auto ref single(Range)(Range range)
if (isInputRange!Range)
{
    if (range.empty)
        throw new Exception("The source sequence is empty.");
    static if (hasLvalueElements!Range)
        auto value = addressof(range.front);
    else
        auto value = range.front;
    range.popFront();
    if (!range.empty)
        throw new Exception("More than one element in source sequence.");
    static if (hasLvalueElements!Range)
        return *value;
    else
        return asRvalue(value);
}

///
unittest
{
    static assert([1].single == 1);
    static assert([1, 2, 3].single!"a % 2 == 0" == 2);
}

/++
 + レンジの唯一の要素を取得します。
 +
 + $(D_PARAM range) の唯一の要素を取得します。
 + 条件 $(D_PARAM predicate) を指定するオーバーロードでは、条件を満たす唯一の要素を取得します。
 + レンジが空の場合、もしくは条件を満たす要素が複数存在する場合は要素型の初期値を返します。
 +
 + Params:
 + predicate = 返される要素が満たすべき条件。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + $(D_PARAM range) の唯一の要素。
 + レンジが空の場合、もしくは条件を満たす要素が複数存在する場合は要素型の初期値。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.SingleOrDefault)
 +/
@property ElementType!Range singleOrDefault(alias predicate, Range)(Range range)
if (isInputRange!Range)
{
    for (; !range.empty && !buildFunction!predicate(range.front); range.popFront()) { }
    if (range.empty)
        return typeof(return).init;
    auto value = range.front;
    range.popFront();
    for (; !range.empty; range.popFront())
    {
        if (buildFunction!predicate(range.front))
            return typeof(return).init;
    }
    return value;
}

/// ditto
@property ElementType!Range singleOrDefault(Range)(Range range)
if (isInputRange!Range)
{
    if (!range.empty)
    {
        auto value = range.front;
        range.popFront();
        if (range.empty)
            return value;
    }
    return typeof(return).init;
}

///
unittest
{
    static assert([1].singleOrDefault == 1);
    static assert([1, 2, 3].singleOrDefault == int.init);
    static assert([1, 2, 3].singleOrDefault!"a % 2 == 0" == 2);
    static assert([1, 2, 3].singleOrDefault!"a % 2 != 0" == int.init);
}

/++
 + レンジ内の指定された数の要素をバイパスし、残りの要素を返します。
 +
 + $(D_PARAM range) の要素を先頭から $(D_PARAM n) 個バイパスします。
 + 要素数が $(D_PARAM n) よりすくない場合は、空のレンジが返されます。
 +
 + Params:
 + range = 操作対象のレンジ。
 + n = 残りの要素を返す前にスキップする要素の数。
 +
 + Returns:
 + 入力レンジで指定されたインデックスの後に出現する要素を含むレンジ。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Skip)
 +/
Range skip(Range)(Range range, in size_t n)
if (isInputRange!Range)
{
    return std.range.drop(range, n);
}

///
unittest
{
    static assert([1, 2, 3].skip(1) == [2, 3]);
}

/++
 + 指定された条件が満たされる限り、レンジの要素をバイパスした後、残りの要素を返します。
 +
 + $(D_PARAM range) の先頭から $(D_PARAM predicate) が $(D_KEYWORD true) を返すすべての要素をバイパスします。
 +
 + Params:
 + predicate = 各要素が条件を満たしているかどうかをテストする関数。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + $(D_PARAM predicate) で指定されたテストに合格しない連続する最初の要素から入力シーケンスの要素を含むレンジ。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.SkipWhile)
 +/
@property Range skipWhile(alias predicate, Range)(Range range)
if (isInputRange!Range)
{
    for (; !range.empty && buildFunction!predicate(range.front); range.popFront()) { }
    return range;
}

///
unittest
{
    static assert(counting[0 .. 10].skipWhile!(x => x < 5).sequenceEqual([5, 6, 7, 8, 9]));
}

/++
 + レンジの各要素の合計値を取得します。
 +
 + $(D_PARAM range) の各要素を合計します。要素は、$(D_PARAM selector) によって選択することができます。
 + 初期値 $(D_PARAM seed) を指定した場合は、集計の初期値とされます。
 +
 + Params:
 + selector = レンジの各要素から集計のための値を取得する関数。
 + range = 操作対象のレンジ。
 + seed = 集計値の初期値。
 +
 + Returns:
 + レンジの各要素の合計値。
 +
 + Throws:
 + $(D_PARAM seed) 受け取らないオーバーロードで、$(D_PARAM range) に要素が含まれていません。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Sum)
 +/
auto sum(alias selector = "a", Range, T)(Range range, T seed)
if (isInputRange!Range && !isInfinite!Range)
{
    for (; !range.empty; range.popFront())
    {
        seed += buildFunction!selector(range.front);
    }
    return seed;
}

/// ditto
@property auto sum(alias selector = "a", Range)(Range range)
if (isInputRange!Range && !isInfinite!Range)
{
    if (range.empty)
        throw new Exception("The source sequence is empty.");
    auto seed = buildFunction!selector(range.front);
    range.popFront();
    return range.sum!selector(seed);
}

///
unittest
{
    static assert([1, 2, 3, 4, 5].sum == 15);
    static assert([1, 2, 3, 4, 5].sum!"a * a"(0) == 1 + 4 + 9 + 16 + 25);
}

private struct TakeWhileRange(Range, alias predicate)
if (isInputRange!Range)
{
    private Range _source;
    private bool _done;

    this(Range source)
    {
        _source = source;
        _done = _source.empty || !buildFunction!predicate(_source.front);
    }

    @property bool empty()
    {
        return _done;
    }

    @property auto ref front()
    {
        assert(!_source.empty);
        return _source.front;
    }

    static if (hasAssignableElements!Range)
        @property void front(ElementType!Range value)
        {
            assert(!_source.empty);
            _source.front = value;
        }

    static if (hasMobileElements!Range)
        @property auto moveFront()
        {
            assert(!_source.empty);
            return .moveFront(_source);
        }

    void popFront()
    {
        assert(!empty);
        _source.popFront();
        _done = _source.empty || !buildFunction!predicate(_source.front);
    }

    static if (isForwardRange!Range)
        @property auto save()
        {
            return typeof(this)(_source.save);
        }
}

/++
 + 指定された条件が満たされる限り、レンジから要素を返します。
 +
 + このメソッドは遅延実行を使用して実装されます。
 + アクションの実行に必要なすべての情報を格納するレンジがすぐに返されます。
 + このプロパティによって取得したレンジは、$(D_KEYWORD foreach) ステートメントなどで列挙を開始するまで評価されません。
 +
 + $(D_PARAM range) の先頭から、各要素が $(D_PARAM predicate) を満たし続ける間、要素を返します。
 +
 + Params:
 + predicate = 各要素が条件を満たしているかどうかをテストする関数。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + テストに合格しなくなった要素の前に出現する、入力レンジの要素を含むレンジ。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(D_PARAM range) と同様、かつ $(PARLANCE ForwardRange) 以下))
 +   $(TR $(TD Infinite)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Length)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Slicing)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD LvalueElements)
 +        $(TD $(D_PARAM range) と同様))
 +   $(TR $(TD AssignableElements)
 +        $(TD $(D_PARAM range) と同様)))
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.TakeWhile)
 +/
@property auto takeWhile(alias predicate, Range)(Range range)
if (isInputRange!Range)
{
    return TakeWhileRange!(Range, predicate)(range);
}

///
unittest
{
    static assert(counting[0 .. 10].takeWhile!"a < 5".sequenceEqual([0, 1, 2, 3, 4]));
}

/++
 + レンジから配列を作成します。
 +
 + $(D_PARAM range) を強制的に評価し、$(D_PARAM range) のすべての要素を含む配列を作成します。
 +
 + このメソッドは、純粋に配列を必要としている場合に使用される他、
 + レンジの要素をキャッシュしたい場合に使用されます。
 +
 + レンジの要素が $(D_KEYWORD ref) 修飾されている場合、作成される配列はレンジの要素へのポインタとなります。
 + ポインタとして構築される場合は、キャッシュなどが正しく動作しない可能性があります。
 + 純粋に配列が必要な場合は、$(REF asRvalueElements) プロパティを併用してください。
 +
 + Params:
 + range = 操作対象のレンジ。
 +
 + Returns:
 + レンジの要素を含む配列。ただし、元の入力が配列の場合は、何も行われずそのまま返されます。
 + レンジの順序は保たれます。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.ToArray)
 +/
@property auto toArray(Range)(Range range)
if (isInputRange!Range && !isInfinite!Range)
{
    static if (is(Range T : T[]))
    {
        return range;
    }
    else static if (hasLvalueElements!Range)
    {
        ElementType!Range*[] elements;
        foreach (ref item; range)
        {
            elements ~= addressof(item);
        }
        return elements;
    }
    else
    {
        ElementType!Range[] elements;
        foreach (ref item; range)
        {
            elements ~= item;
        }
        return elements;
    }
}

///
unittest
{
    static assert([1, 2, 3].toArray == [1, 2, 3]);
    static assert([1, 2, 3].asRvalueElements.toArray == [1, 2, 3]);
    static assert([1, 2, 3].asInputRange.asRvalueElements.toArray == [1, 2, 3]);
}

/++
 + レンジから連想配列を作成します。
 +
 + $(D_PARAM range) を強制的に評価し、$(D_PARAM keyof) によって生成されたキーと、
 + それに対応する $(D_PARAM valueof) によって生成されたバリューによる連想配列を作成します。
 +
 + $(REF toArray) プロパティの動作と同じく、$(D_PARAM valueof) の結果が左辺値の場合は、
 + 結果の連想配列の要素がポインタになります。
 +
 + このプロパティは、連想配列を作成する際に、キーの重複を許可しません。
 +
 + Params:
 + keyof = 要素からキーを選択するセレクタ。
 + valueof = 要素からバリューを選択するセレクタ。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + レンジの要素を含む連想配列。
 +
 + Throws:
 + $(D_PARAM keyof) が 2 つの要素に対して重複するキーを生成しています。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.ToDictionary)
 +/
@property auto toDictionary(alias keyof, alias valueof = "a", Range)(Range range)
if (isInputRange!Range && !isInfinite!Range)
{
    enum isLvalue = __traits(compiles, addressof(buildFunction!valueof(range.front)));
    alias K = typeof(buildFunction!keyof(range.front));
    static if (isLvalue)
        alias V = typeof(buildFunction!valueof(range.front))*;
    else
        alias V = typeof(buildFunction!valueof(range.front));
    V[K] result;
    for (; !range.empty; range.popFront())
    {
        auto key = buildFunction!keyof(range.front);
        if (key in result)
            throw new Exception("Key selector produces duplicate keys for two elements.");
        static if (isLvalue)
            result[key] = addressof(buildFunction!valueof(range.front));
        else
            result[key] = buildFunction!valueof(range.front);
    }
    result.rehash;
    return result;
}

///
unittest
{
    static assert([1, 2, 3].asRvalueElements.toDictionary!"a" == [1:1, 2:2, 3:3]);
    static assert([1, 2, 3].asRvalueElements.toDictionary!"a * a" == [1:1, 4:2, 9:3]);
    static assert([1, 2, 3].asRvalueElements.toDictionary!("a * a", "a + a") == [1:2, 4:4, 9:6]);
    static assert([1, 2, 3].asRvalueElements.toDictionary!"a"[1] == 1);
}

/++
 + レンジから連想配列を作成します。
 + $(REF toDictionary) と異なり、キーの重複を許可します。
 +
 + $(D_PARAM range) を強制的に評価し、$(D_PARAM keyof) によって生成されたキーと、
 + それに対応する $(D_PARAM valueof) によって生成されたバリューの配列による連想配列を作成します。
 +
 + $(REF toArray) プロパティの動作と同じく、$(D_PARAM valueof) の結果が左辺値の場合は、
 + 結果の連想配列の要素がポインタになります。
 +
 + Params:
 + keyof = 要素からキーを選択するセレクタ。
 + valueof = 要素からバリューを選択するセレクタ。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + レンジの要素を含む連想配列。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.ToLookup)
 +/
@property auto toLookup(alias keyof, alias valueof = "a", alias compare = "a == b", Range)(Range range)
if (isInputRange!Range && !isInfinite!Range)
{
    enum isLvalue = __traits(compiles, addressof(buildFunction!valueof(range.front)));
    alias K = typeof(buildFunction!keyof(range.front));
    static if (isLvalue)
        alias V = typeof(buildFunction!valueof(range.front))*;
    else
        alias V = typeof(buildFunction!valueof(range.front));
    V[][K] result;
    for (; !range.empty; range.popFront())
    {
        auto key = buildFunction!keyof(range.front);
        static if (isLvalue)
            result[key] ~= addressof(buildFunction!valueof(range.front));
        else
            result[key] ~= buildFunction!valueof(range.front);
    }
    result.rehash;
    return result;
}

///
unittest
{
    assert([1, 2, 3, 4, 5, 6].asRvalueElements.toLookup!"a" == [1:[1], 2:[2], 3:[3], 4:[4], 5:[5], 6:[6]]);
    assert([1, 2, 3, 4, 5, 6].asRvalueElements.toLookup!"a % 3" == [0:[3, 6], 1:[1, 4], 2:[2, 5]]);
}

private struct WhereRange(Range, alias predicate)
if (isInputRange!Range)
{
    private Range _source;

    this(Range source)
    {
        _source = source;
        while (!_source.empty && !buildFunction!predicate(_source.front))
        {
            _source.popFront();
        }
        static if (isBidirectionalRange!Range)
            while (!_source.empty && !buildFunction!predicate(_source.back))
            {
                _source.popBack();
            }
    }

    @property bool empty()
    {
        return _source.empty;
    }

    @property auto ref front()
    {
        assert(!_source.empty);
        return _source.front;
    }

    static if (hasAssignableElements!Range)
        @property void front(ElementType!Range value)
        {
            assert(!_source.empty);
            _source.front = value;
        }

    void popFront()
    {
        assert(!_source.empty);
        do
        {
            _source.popFront();
        } while (!_source.empty && !buildFunction!predicate(_source.front));
    }

    static if (isForwardRange!Range)
        @property auto save()
        {
            return typeof(this)(_source.save);
        }

    static if (isBidirectionalRange!Range)
    {
        @property auto ref back()
        {
            assert(!_source.empty);
            return _source.back;
        }

        static if (hasAssignableElements!Range)
            @property void back(ElementType!Range value)
            {
                assert(!_source.empty);
                _source.back = value;
            }

        void popBack()
        {
            assert(!_source.empty);
            do
            {
                _source.popBack();
            } while (!_source.empty && !buildFunction!predicate(_source.back));
        }
    }
}

/++
 + 述語に基づいて値のレンジをフィルタ処理します。
 +
 + このメソッドは遅延実行を使用して実装されます。
 + アクションの実行に必要なすべての情報を格納するレンジがすぐに返されます。
 + このプロパティによって取得したレンジは、$(D_KEYWORD foreach) ステートメントなどで列挙を開始するまで評価されません。
 +
 + $(D_PARAM range) のすべての要素について、条件 $(D_PARAM predicate) を満たさない要素を削除します。
 +
 + Params:
 + predicate = 各要素が条件を満たしているかどうかをテストする関数。
 + range = 操作対象のレンジ。
 +
 + Returns:
 + 条件を満たす、入力レンジの要素を含むレンジ。
 +
 + $(TABLE
 +   $(TR $(TD Category)
 +        $(TD $(D_PARAM range) と同様、かつ $(PARLANCE BidirectionalRange) 以下))
 +   $(TR $(TD Infinite)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Length)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD Slicing)
 +        $(TD $(PARLANCE No)))
 +   $(TR $(TD LvalueElements)
 +        $(TD $(D_PARAM range) と同様))
 +   $(TR $(TD AssignableElements)
 +        $(TD $(D_PARAM range) と同様)))
 +
 + Remarks:
 + $(D_PARAM range) が $(PARLANCE BidirectionalRange) の場合は、結果のレンジも $(PARLANCE BidirectionalRange) になります。
 + この動作のサポートには、わずかなコストが発生します。
 + これを回避するには、$(REF asForwardRange) を使用して $(D_PARAM range) から $(PARLANCE BidirectionalRange) の機能を削除します。
 +
 + See_Also:
 + $(LINK2 https://msdn.microsoft.com/library/system.linq.enumerable.aspx, System.Linq.Enumerable.Where)
 +/
@property auto where(alias predicate, Range)(Range range)
if (isInputRange!Range)
{
    return WhereRange!(Range, predicate)(range);
}

///
unittest
{
    static assert([1, 2, 3].where!"a % 2 == 0".single == 2);
    static assert([1, 2, 3].where!(x => x % 2 == 0).single == 2);
}
