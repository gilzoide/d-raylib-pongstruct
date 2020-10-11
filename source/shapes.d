module shapes;

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

    void draw(Color color = Colors.WHITE) const
    {
        DrawCircleV(center, radius, color);
    }
    void drawGradient(Color color1 = Colors.WHITE, Color color2 = Colors.BLACK) const
    {
        DrawCircleGradient(cast(int) center.x, cast(int) center.y, radius, color1, color2);
    }
}

struct Frame
{
    Rectangle rect;
    alias rect this;

    @property float top() const
    {
        return rect.y;
    }
    @property void top(float value)
    {
        rect.height = bottom() - value;
        rect.y = value;
    }
    @property float left() const
    {
        return rect.x;
    }
    @property void left(float value)
    {
        rect.width = right() - value;
        rect.x = value;
    }
    @property float bottom() const
    {
        return rect.y + rect.height;
    }
    @property void bottom(float value)
    {
        rect.height = value - top();
    }
    @property float right() const
    {
        return rect.x + rect.width;
    }
    @property void right(float value)
    {
        rect.width = value - left();
    }

    @property float centerX() const
    {
        return rect.x + rect.width * 0.5;
    }
    @property void centerX(float value)
    {
        rect.x = value - rect.width * 0.5;
    }
    @property float centerY() const
    {
        return rect.y + rect.height * 0.5;
    }
    @property void centerY(float value)
    {
        rect.y = value - rect.height * 0.5;
    }
    @property Vector2 center() const
    {
        return Vector2(centerX, centerY);
    }
    @property void center(Vector2 value)
    {
        rect.x = value.x - rect.width * 0.5;
        rect.y = value.y - rect.height * 0.5;
    }

    bool checkCollision(Vector2 point) const
    {
        return CheckCollisionPointRec(point, rect);
    }
    bool checkCollision(Circle circle) const
    {
        return CheckCollisionCircleRec(circle.center, circle.radius, rect);
    }
    bool checkCollision(Rectangle other) const
    {
        return CheckCollisionRecs(rect, other);
    }

    void draw(Color color = Colors.WHITE) const
    {
        DrawRectangleRec(rect, color);
    }
    void drawRounded(float roundness, int segments, Color color = Colors.WHITE) const
    {
        DrawRectangleRounded(rect, roundness, segments, color);
    }
}

