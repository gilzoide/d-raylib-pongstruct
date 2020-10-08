module inherit_struct;

mixin template InheritStruct(T)
{
    alias T superStruct;

    T* asInherited() return
    {
        return cast(T*) &this;
    }

    alias asInherited this;

    import std.traits : Fields, FieldNameTuple;
    static foreach (i, fieldName; FieldNameTuple!T)
    {
        mixin(Fields!T[i].stringof ~ " " ~ fieldName ~ " = " ~ T.stringof ~ ".init." ~ fieldName ~ ";\n");
    }
}
