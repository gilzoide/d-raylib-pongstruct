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
        mixin(Fields!T[i].stringof ~ " " ~ fieldName ~ " = superStruct.init." ~ fieldName ~ ";\n");
    }

}

mixin template GameObject()
{
    import std.traits : Fields, FieldNameTuple, hasMember;
    void initializeChildren(this T)()
    {
        static foreach (i, fieldName; FieldNameTuple!T)
        {
            static if (hasMember!(Fields!T[i], "initialize"))
            {
                __traits(getMember, this, fieldName).initialize();
            }
        }
    }

    void updateChildren(this T)(float dt)
    {
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
        static foreach (i, fieldName; FieldNameTuple!T)
        {
            static if (hasMember!(Fields!T[i], "draw"))
            {
                __traits(getMember, this, fieldName).draw();
            }
        }
    }

    static if (!hasMember!(typeof(this), "initialize"))
    {
        void initialize()
        {
            initializeChildren();
        }
    }
    static if (!hasMember!(typeof(this), "update"))
    {
        void update(float dt)
        {
            updateChildren(dt);
        }
    }
    static if (!hasMember!(typeof(this), "draw"))
    {
        void draw()
        {
            drawChildren();
        }
    }
}


