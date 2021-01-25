import gargula;

private enum MAX_TOUCH_POINTS = 10;

Vector2 touchInsideRect(Rectangle rect)
{
    foreach (i; 0 .. MAX_TOUCH_POINTS)
    {
        Vector2 v = GetTouchPosition(i);
        if (v.x >= 0 && v.y >= 0 && CheckCollisionPointRec(v, rect))
        {
            return v;
        }
    }
    return Vector2(-1, -1);
}
