module object_list;

import core.stdc.stdlib;

alias updateMethod = void delegate(float);
alias drawMethod = void delegate();

struct GameObject
{
    void *object;
    updateMethod update;
    drawMethod draw;
}

struct Game(uint N = 8)
{
    GameObject[N] objects;
    int size = 0;

    void update(float dt)
    {
        foreach (i; 0 .. size)
        {
            objects[i].update(dt);
        }
    }
    void draw()
    {
        foreach (i; 0 .. size)
        {
            objects[i].draw();
        }
    }

    void addObject(T)(T* object)
    {
        objects[size] = GameObject(object, &object.update, &object.draw);
        size++;
    }

    ~this()
    {
        foreach (i; 0 .. size)
        {
            free(objects[i].object);
        }
        size = 0;
    }
}
