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

mixin template UpdateDraw()
{
    void updateChildren(this T)(float dt)
    {
        import std.traits : Fields, FieldNameTuple, hasMember;
        static foreach (i, fieldName; FieldNameTuple!T)
        {
            static if (hasMember!(Fields!T[i], "update"))
            {
                __traits(getMember, this, fieldName).update(dt);
            }
        }
    }

    void drawChildren(this T)()
    {
        import std.traits : Fields, FieldNameTuple, hasMember;
        static foreach (i, fieldName; FieldNameTuple!T)
        {
            static if (hasMember!(Fields!T[i], "draw"))
            {
                __traits(getMember, this, fieldName).draw();
            }
        }
    }
}


