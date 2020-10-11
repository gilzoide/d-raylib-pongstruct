module objects;

import constants;
import inherit_struct;
import raylib;
import raylib_ext;
import shapes;

enum MoveDirection {
    none,
    up,
    down,
}
MoveDirection directionFromUpDown(bool up, bool down)
{
    if (up && !down)
    {
        return MoveDirection.up;
    }
    else if (!up && down)
    {
        return MoveDirection.down;
    }
    else
    {
        return MoveDirection.none;
    }
}

struct Ball
{
    mixin InheritStruct!FilledCircle;
    mixin GameObject;

    Vector2 velocity = { ballVelocity, ballVelocity };
    bool hitLeftEdge = false;
    bool hitRightEdge = false;

    void reflect(MoveDirection moving)
    {
        velocity.x = -velocity.x;
        switch (moving)
        {
            case MoveDirection.up:
                velocity.y -= ballReflectionVelocity;
                break;
            case MoveDirection.down:
                velocity.y += ballReflectionVelocity;
                break;
            default: break;
        }
    }

    void update(float dt)
    {
        center.x += dt * velocity.x;
        center.y += dt * velocity.y;

        hitLeftEdge = center.x - radius < 0;
        hitRightEdge = center.x + radius > windowWidth;

        if (center.y - radius < 0)
        {
            center.y = radius;
            velocity.y = ballVelocity;
        }
        else if (center.y + radius > windowHeight)
        {
            center.y = windowHeight - radius;
            velocity.y = -ballVelocity;
        }
    }
}

struct Paddle
{
    mixin GameObject;

    Rectangle rect = {
        width: paddleWidth,
        height: paddleHeight,
    };

    alias rect this;

    float linearVelocity = paddleVelocity;
    Color color = Colors.WHITE;

    KeyboardKey upKey = KeyboardKey.KEY_UP;
    KeyboardKey downKey = KeyboardKey.KEY_DOWN;
    MoveDirection movingTo;

    void update(float dt)
    {
        movingTo = directionFromUpDown(IsKeyDown(upKey), IsKeyDown(downKey));
        float halfHeight = 0.5 * rect.height;
        if (movingTo == MoveDirection.up)
        {
            rect.y -= dt * linearVelocity;
            if (rect.y < 0)
            {
                rect.y = 0;
            }
        }
        else if (movingTo == MoveDirection.down)
        {
            rect.y += dt * linearVelocity;
            if (rect.bottom > windowHeight)
            {
                rect.y = windowHeight - rect.height;
            }
        }
    }
    
    void draw()
    {
        DrawRectangleRounded(rect, 12, 12, color);
    }
}

struct Score
{
    mixin GameObject;

    int x, y;
    Color color = Colors.WHITE;
    

    int points;
    private char[4] buffer = "0";

    void increment()
    {
        points++;
        import core.stdc.stdio;
        sprintf(cast(char *) buffer, "%d", points);
    }

    void draw()
    {
        DrawText(cast(char *) buffer, x, y, scoreFontSize, color);
    }
}


struct PongGame
{
    mixin GameObject;

    Paddle paddle1 = {
        upKey: KeyboardKey.KEY_W,
        downKey: KeyboardKey.KEY_S,
    };
    Paddle paddle2 = {
    };

    Score score1 = {
        x: cast(int) (windowWidth * 0.25),
        y: 20,
    };
    Score score2 = {
        x: cast(int) (windowWidth * 0.75),
        y: 20,
    };

    Ball ball = {
        center: { windowWidth * 0.5, windowHeight * 0.5 },
        radius: 15,
    };

    void initialize()
    {
        initializeChildren();
        paddle1.x = paddleWidth * 0.5;
        paddle1.y = 0.5 * windowHeight;
        paddle2.x = windowWidth - paddleWidth * 1.5;
        paddle2.y = 0.5 * windowHeight;
        resetBall(true);
    }

    void resetBall(bool goingLeft)
    {
        with (ball)
        {
            center = PongGame.init.ball.center;
            velocity = Vector2((goingLeft ? ballVelocity : -ballVelocity), ballVelocity);
        }
    }

    void update(float dt)
    {
        updateChildren(dt);

        if (ball.center.x < windowWidth * 0.5)
        {
            if (ball.checkCollision(paddle1))
            {
                ball.reflect(paddle1.movingTo);
                ball.left = paddle1.right;
            }
        }
        else
        {
            if (ball.checkCollision(paddle2))
            {
                ball.reflect(paddle2.movingTo);
                ball.right = paddle2.left;
            }
        }

        if (ball.hitLeftEdge)
        {
            score2.increment();
            ball.hitLeftEdge = false;
            resetBall(true);
        }
        else if (ball.hitRightEdge)
        {
            score1.increment();
            ball.hitRightEdge = false;
            resetBall(false);
        }
    }
}
