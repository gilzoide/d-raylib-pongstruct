module shapes;

import gargula;

struct Circle
{
	Vector2 center = 0;
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

    void drawCircle(Color color = WHITE) const
    {
        DrawCircleV(center, radius, color);
    }
    void drawGradient(Color color1 = WHITE, Color color2 = BLACK) const
    {
        DrawCircleGradient(cast(int) center.x, cast(int) center.y, radius, color1, color2);
    }
}

struct Frame
{
    Rectangle rect;
    alias rect this;

    static typeof(this) from(float x, float y, float width, float height)
    {
        return from(Vector2(x, y), Vector2(width, height));
    }
    static typeof(this) from(Vector2 origin, Vector2 size)
    {
        typeof(return) obj = {
            rect: { origin, size },
        };
        return obj;
    }
    static typeof(this) from(Rectangle rect)
    {
        typeof(return) obj = {
            rect: rect,
        };
        return obj;
    }

    Frame inset(float x, float y)
    {
        return Frame.from(left + x, top + y, width - 2 * x, height - 2 * y);
    }

    @property float top() const
    {
        return rect.origin.y;
    }
    @property void top(float value)
    {
        rect.height = bottom() - value;
        rect.origin.y = value;
    }
    @property float left() const
    {
        return rect.origin.x;
    }
    @property void left(float value)
    {
        rect.width = right() - value;
        rect.origin.x = value;
    }
    @property float bottom() const
    {
        return rect.origin.y + rect.height;
    }
    @property void bottom(float value)
    {
        rect.height = value - top();
    }
    @property float right() const
    {
        return rect.origin.x + rect.width;
    }
    @property void right(float value)
    {
        rect.width = value - left();
    }

    @property float centerX() const
    {
        return rect.origin.x + rect.width * 0.5;
    }
    @property void centerX(float value)
    {
        rect.origin.x = value - rect.width * 0.5;
    }
    @property float centerY() const
    {
        return rect.origin.y + rect.height * 0.5;
    }
    @property void centerY(float value)
    {
        rect.origin.y = value - rect.height * 0.5;
    }
    @property Vector2 center() const
    {
        return Vector2(centerX, centerY);
    }
    @property void center(Vector2 value)
    {
        centerX = value.x;
        centerY = value.y;
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

    void drawRectangle(Color color = WHITE) const
    {
        DrawRectangleRec(rect, color);
    }
    void drawLines(int lineThick = 1, Color color = WHITE) const
    {
        DrawRectangleLinesEx(rect, lineThick, color);
    }
    void drawRounded(float roundness, int segments, Color color = WHITE) const
    {
        DrawRectangleRounded(rect, roundness, segments, color);
    }
}

struct AnchoredFrame
{
    Frame frame;
    alias frame this;

    Vector2 anchor;

    static typeof(this) from(float x, float y, float width, float height, Vector2 anchor)
    {
        typeof(return) obj = {
            frame: Frame.from(x, y, width, height),
            anchor: anchor,
        };
        return obj;
    }
    static typeof(this) from(Vector2 origin, Vector2 size, Vector2 anchor)
    {
        typeof(return) obj = {
            frame: Frame.from(origin, size),
            anchor: anchor,
        };
        return obj;
    }
    static typeof(this) from(Rectangle rect, Vector2 anchor)
    {
        typeof(return) obj = {
            frame: Frame.from(rect),
            anchor: anchor,
        };
        return obj;
    }

    @property float top() const
    {
        return rect.origin.y - rect.height * anchor.y;
    }
    @property float left() const
    {
        return rect.origin.x - rect.width * anchor.x;
    }
    @property float bottom() const
    {
        return top + rect.height;
    }
    @property float right() const
    {
        return left + rect.width;
    }

    @property float centerX() const
    {
        return top + rect.width * 0.5;
    }
    @property float centerY() const
    {
        return left + rect.height * 0.5;
    }
    @property Vector2 center() const
    {
        return Vector2(centerX, centerY);
    }
}

struct StaticText
{
    int fontSize = 12;
    int x, y, width;
    Vector2 anchor = 0;
    Color color = WHITE;
    string text = "";

    @property int height()
    {
        return fontSize;
    }

    void initialize()
    {
        width = MeasureText(cast(const char*) text, fontSize);
    }

    void draw()
    {
        int offsetX = cast(int) (width * anchor.x);
        int offsetY = cast(int) (height * anchor.y);
        DrawText(cast(const char*) text, x - offsetX, y - offsetY, fontSize, color);
    }
}

