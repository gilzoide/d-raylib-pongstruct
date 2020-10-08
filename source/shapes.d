module shapes;

import inherit_struct;
import raylib;

struct Circle
{
	Vector2 position = { 0, 0 };
	float radius = 10;

	bool CheckCollision(Vector2 point) const {
		return CheckCollisionPointCircle(point, position, radius);
	}
    bool CheckCollision(Circle other) const {
        return CheckCollisionCircles(position, radius, other.position, other.radius);
    }
    bool CheckCollision(Rectangle rect) const {
        return CheckCollisionCircleRec(position, radius, rect);
    }
}

struct FilledCircle
{
    mixin InheritStruct!Circle;

	Color color = Colors.WHITE;

	void draw() const {
		DrawCircleV(position, radius, color);
	}
}


struct FilledRectangle
{
	Rectangle rect = { 0, 0, 100, 100 };
	Color color = Colors.WHITE;

	void draw() const {
		DrawRectangleRec(rect, color);
	}
}
