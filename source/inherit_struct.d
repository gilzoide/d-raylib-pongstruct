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
    private alias T = typeof(this);

    import std.traits : Fields, FieldNameTuple, hasMember;
    void initializeChildren()
    {
        static foreach (i, fieldName; FieldNameTuple!T)
        {
            static if (hasMember!(Fields!T[i], "initialize"))
            {
                __traits(getMember, this, fieldName).initialize();
            }
        }
    }

    void updateChildren(float dt)
    {
        static foreach (i, fieldName; FieldNameTuple!T)
        {
            static if (hasMember!(Fields!T[i], "update"))
            {
                __traits(getMember, this, fieldName).update(dt);
            }
        }
    }

    void drawChildren()
    {
        static foreach (i, fieldName; FieldNameTuple!T)
        {
            static if (hasMember!(Fields!T[i], "draw"))
            {
                __traits(getMember, this, fieldName).draw();
            }
        }
    }

    static if (!hasMember!(T, "initialize"))
    {
        void initialize()
        {
            initializeChildren();
        }
    }
    static if (!hasMember!(T, "update"))
    {
        void update(float dt)
        {
            updateChildren(dt);
        }
    }
    static if (!hasMember!(T, "draw"))
    {
        void draw()
        {
            drawChildren();
        }
    }
}


