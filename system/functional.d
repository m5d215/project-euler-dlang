/++
 + 関数型プログラミングを支援します。
 +/
module system.functional;

import std.conv : to;

/++
 + 関数本体を表す文字列を関数に変換します。
 +
 + このテンプレートは、$(D std.functional.unaryFun) および $(D std.functional.binaryFun) を一般化します。
 +/
template buildFunction(alias source)
{
    static if (is(typeof(source) : string))
        auto ref buildFunction(Args...)(auto ref Args __args)
        {
            static assert(Args.length <= 26, "Too many arguments");
            static generateAliasDeclarations()
            {
                string code;
                foreach (i; 0 .. Args.length)
                {
                    immutable s = to!string(i);
                    code ~= "alias __args[" ~ s ~ "] _" ~ s ~ ";"
                          ~ "alias __args[" ~ s ~ "] " ~ cast(char)('a' + i) ~ ";";
                }
                return code;
            }
            mixin(generateAliasDeclarations());
            mixin("return " ~ source ~ ";");
        }
    else
        alias source buildFunction;
}

///
unittest
{
    // 文字列を指定して関数を構築します。
    // 引数の名前は "a"、"b"、"c"、...、"z" を使用します。
    alias add = buildFunction!"a + b";
    static assert(add(3, 4) == 7);
    static assert(add(3.5, 4.5) == 8);
}

///
unittest
{
    static auto addImpl(T)(T x, T y)
    {
        return x + y;
    }
    alias add = buildFunction!addImpl;
    // テンプレート パラメータに関数を指定した場合は、指定した関数へのエイリアスになります。
    static assert(__traits(isSame, addImpl, add));
}
