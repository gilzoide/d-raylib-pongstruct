module raylib_ext;

import raylib;

// Rectangle methods
float top(Rectangle r)
{
    return r.y;
}
float left(Rectangle r)
{
    return r.x;
}
float bottom(Rectangle r)
{
    return r.y + r.height;
}
float right(Rectangle r)
{
    return r.x + r.width;
}
float centerX(Rectangle r)
{
    return r.x + r.width * 0.5;
}
float centerY(Rectangle r)
{
    return r.y + r.height * 0.5;
}
Vector2 center(Rectangle r)
{
    return Vector2(r.centerX, r.centerY);
}
Vector2 size(Rectangle r)
{
    return Vector2(r.width, r.height);
}
