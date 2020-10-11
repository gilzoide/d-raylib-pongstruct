module shapes;

import inherit_struct;
import raylib;

struct Circle
{
	Vector2 center = { 0, 0 };
	float radius = 10;

    @property float top() const
    {
        return center.y - radius;
    }
    @property void top(float value)
    {
        center.y = value + radius;
    }
    @property float left() const
    {
        return center.x - radius;
    }
    @property void left(float value)
    {
        center.x = value + radius;
    }
    @property float bottom() const
    {
        return center.y + radius;
    }
    @property void bottom(float value)
    {
        center.y = value - radius;
    }
    @property float right() const
    {
        return center.x + radius;
    }
    @property void right(float value)
    {
        center.x = value - radius;
    }

	bool checkCollision(Vector2 point) const
    {
		return CheckCollisionPointCircle(point, center, radius);
	}
    bool checkCollision(Circle other) const
    {
        return CheckCollisionCircles(center, radius, other.center, other.radius);
    }
    bool checkCollision(Rectangle rect) const
    {
        return CheckCollisionCircleRec(center, radius, rect);
    }
}

struct FilledCircle
{
    mixin InheritStruct!Circle;

	Color color = Colors.WHITE;

	void draw()
    {
		DrawCircleV(center, radius, color);
	}
}


struct FilledRectangle
{
	Rectangle rect = { 0, 0, 100, 100 };
	Color color = Colors.WHITE;

	void draw()
    {
		DrawRectangleRec(rect, color);
	}
}
