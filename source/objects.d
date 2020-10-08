module objects;

import constants;
import inherit_struct;
import raylib;
import shapes;

struct Ball
{
    mixin InheritStruct!FilledCircle;

    Vector2 velocity = { ballVelocity, ballVelocity };

    void update(float dt)
    {
        position.x += dt * velocity.x;
        position.y += dt * velocity.y;

        if (position.x - radius < 0 || position.x + radius > windowWidth) {
            velocity.x = -velocity.x;
        }
        if (position.y - radius < 0 || position.y + radius > windowHeight) {
            velocity.y = -velocity.y;
        }
    }
}

struct Paddle
{
    Vector2 position;
    Vector2 size = { paddleWidth, paddleHeight };
    float linearVelocity = paddleVelocity;
    Color color = Colors.WHITE;

    KeyboardKey upKey = KeyboardKey.KEY_UP;
    KeyboardKey downKey = KeyboardKey.KEY_DOWN;

	Rectangle getRectangle() const
    {
        Rectangle r = {
            x: position.x - size.x * 0.5f,
            y: position.y - size.y * 0.5f,
            width: size.x,
            height: size.y
        };
        return r;
    }

    void update(float dt)
    {
        bool goingUp = IsKeyDown(upKey), goingDown = IsKeyDown(downKey);
        float halfHeight = 0.5 * size.y;
        if (goingUp && !goingDown)
        {
            position.y -= dt * linearVelocity;
            if (position.y - halfHeight < 0)
            {
                position.y = halfHeight;
            }
        }
        else if (!goingUp && goingDown)
        {
            position.y += dt * linearVelocity;
            if (position.y + halfHeight > windowHeight)
            {
                position.y = windowHeight - halfHeight;
            }
        }
    }
    
    void draw()
    {
        DrawRectangleRounded(getRectangle(), 12, 12, color);
    }
}


struct PongGame
{
    Paddle paddle1 = {
        position: { paddleWidth, 0.5 * windowHeight },
        upKey: KeyboardKey.KEY_W,
        downKey: KeyboardKey.KEY_S,
    };
    Paddle paddle2 = {
        position: { windowWidth - paddleWidth, 0.5 * windowHeight },
    };

    Ball ball = {
        position: { windowWidth * 0.5, windowHeight * 0.5 },
        radius: 20,
    };

    void update(float dt)
    {
        paddle1.update(dt);
        paddle2.update(dt);
        ball.update(dt);
    }

    void draw()
    {
        paddle1.draw();
        paddle2.draw();
        ball.draw();
    }
}
