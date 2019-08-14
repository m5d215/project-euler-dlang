/++
 + コア API を定義します。
 +/
module system.core;

/++
 +
 +/
struct Nothing { }

/++
 + $(D_PARAM value) のアドレス値を取得します。
 +
 + 任意の左辺値式に対して、その式のアドレス値を取得します。
 + この関数を使うことで、プロパティに対してもアドレス値を取得することができます。
 +
 + Params:
 + value = アドレスを取得する対象の変数。
 +
 + Returns:
 + $(D_PARAM value) のアドレス値。
 +/
T* addressof(T)(ref T value) nothrow pure
{
    return &value;
}

///
unittest
{
    int x = 3;
    assert(addressof(x) == &x);
    assert(*addressof(x) == 3);
}

///
unittest
{
    struct Foo
    {
        int internal;

        @property ref inout(int) reference() inout
        {
            return internal;
        }
    }
    immutable foo = Foo(3);
    // & 演算子ではプロパティが返す値のアドレスを取得できませんが・・・
    static assert(!__traits(compiles, &foo.reference == &foo.internal));
    // addressof を使用するとアドレスを取得できます。
    static assert(addressof(foo.reference) == &foo.internal);
}

/++
 + 指定した左辺値を右辺値に変換します。
 +
 + Params:
 + value = 右辺値に変換したい左辺値。
 +
 + Returns:
 + $(D_PARAM value) をそのまま返します。
 +/
T asRvalue(T)(auto ref T value)
{
    return value;
}

///
unittest
{
    int a = 3;
    assert(asRvalue(a) == 3);
}

/++
 + 参照型をエミュレーションします。
 +
 + Params:
 + T = 参照する型。
 +/
struct Reference(T)
{
    private T* pointer;

    invariant
    {
        assert(pointer !is null);
    }

    /// クラスの新しいインスタンスを初期化します。
    ///
    /// Params:
    /// reference = この参照型が保持するオブジェクト。
    this(ref T reference)
    {
        pointer = &reference;
    }

    /// この参照型が保持しているオブジェクトへの参照を取得します。
    ///
    /// Returns:
    /// この参照型が保持しているオブジェクトへの参照。
    /// これは、コンストラクタで指定したオブジェクトと等しいです。
    @property ref inout(T) __reference() inout
    {
        return *pointer;
    }

    alias __reference this;
}

/// ditto
@property Reference!T asReference(T)(ref T value)
{
    return typeof(return)(value);
}

///
unittest
{
    auto s = "123";
    auto r = asReference(s);
    static ref string unwrap(Reference!string reference)
    {
        // Reference!T から T に自動変換できます。
        return reference;
    }
    assert(unwrap(r) is s);
    // Reference!T は T のプロパティ等が直接使用できます。
    assert(r.length == s.length);
}
