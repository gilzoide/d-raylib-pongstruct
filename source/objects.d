module objects;

import cdefs;
import constants;
import inherit_struct;
import raylib;
import shapes;

import std.algorithm.comparison : max, min;

version (WebAssembly)
{
    version = TouchSupport;
}

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
    mixin GameObject;

    Circle circle;
    alias circle this;

    Vector2 velocity = { ballVelocity, ballVelocity };
    Color color = Colors.WHITE;
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

    void draw()
    {
        circle.draw(color);
    }
}

struct Paddle
{
    mixin GameObject;

    Frame rect = {
        rect: {
            width: paddleWidth,
            height: paddleHeight,
        },
    };
    alias rect this;

    float linearVelocity = paddleVelocity;
    Color color = Colors.WHITE;

    float targetY;
    MoveDirection movingTo;

    void update(float dt)
    {
        float targetDelta = targetY - centerY;
        if (targetDelta < -float.epsilon)
        {
            movingTo = MoveDirection.up;
            float delta = max(targetDelta, -dt * linearVelocity);
            rect.y += delta;
            if (rect.y < 0)
            {
                rect.y = 0;
            }
        }
        else if (targetDelta > float.epsilon)
        {
            movingTo = MoveDirection.down;
            float delta = min(targetDelta, dt * linearVelocity);
            rect.y += delta;
            if (rect.bottom > windowHeight)
            {
                rect.y = windowHeight - rect.height;
            }
        }
        else
        {
            movingTo = MoveDirection.none;
        }
    }
    
    void draw()
    {
        rect.drawRounded(rect.width, 12, color);
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

    bool paused;
    Paddle paddle1;
    Paddle paddle2;

    version (TouchSupport)
    {
        Rectangle paddle1TouchArea = {
            x: 1,
            y: paddleHeight * 0.5,
            width: windowWidth * 0.4,
            height: windowHeight - paddleHeight * 0.5,
        };
        Rectangle paddle2TouchArea = {
            x: windowWidth * 0.6,
            y: paddleHeight * 0.5,
            width: windowWidth * 0.4,
            height: windowHeight - paddleHeight * 0.5,
        };
    }

    Score score1 = {
        x: cast(int) (windowWidth * 0.25),
        y: 20,
    };
    Score score2 = {
        x: cast(int) (windowWidth * 0.75),
        y: 20,
    };

    Ball ball = {
        circle: {
            center: { windowWidth * 0.5, windowHeight * 0.5 },
            radius: 15,
        },
    };

    CenteredText pauseText = {
        x: windowWidth / 2,
        y: windowHeight / 2,
        fontSize: 70,
        text: "PAUSED",
    };

    void initialize()
    {
        SetGesturesEnabled(GestureType.GESTURE_TAP);
        initializeChildren();
        paddle1.x = paddleWidth * 0.5;
        paddle1.centerY = 0.5 * windowHeight;
        paddle2.x = windowWidth - paddleWidth * 1.5;
        paddle2.centerY = 0.5 * windowHeight;
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

    float paddleTargetY(const Frame paddle, KeyboardKey upKey, KeyboardKey downKey)
    {
        auto movingTo = directionFromUpDown(IsKeyDown(upKey), IsKeyDown(downKey));
        switch (movingTo)
        {
            case MoveDirection.up: return 0;
            case MoveDirection.down: return windowHeight;
            default: return paddle.centerY;
        }
    }

    float paddleTargetY(const Frame paddle, const Rectangle touchArea, KeyboardKey upKey, KeyboardKey downKey)
    {
        auto movingTo = directionFromUpDown(IsKeyDown(upKey), IsKeyDown(downKey));
        switch (movingTo)
        {
            case MoveDirection.up: return 0;
            case MoveDirection.down: return windowHeight;
            default: break;
        }

        import touch_input;
        Vector2 touch = touchInsideRect(touchArea);
        if (touch.y >= 0)
        {
            return touch.y;
        }
        else
        {
            return paddle.centerY;
        }
    }

    void update(float dt)
    {
        if (IsKeyPressed(KeyboardKey.KEY_ENTER))
        {
            paused = !paused;
        }

        if (!paused)
        {
            version (TouchSupport)
            {
                paddle1.targetY = paddleTargetY(paddle1, paddle1TouchArea, KeyboardKey.KEY_W, KeyboardKey.KEY_S);
                paddle2.targetY = paddleTargetY(paddle2, paddle2TouchArea, KeyboardKey.KEY_UP, KeyboardKey.KEY_DOWN);
            }
            else
            {
                paddle1.targetY = paddleTargetY(paddle1, KeyboardKey.KEY_W, KeyboardKey.KEY_S);
                paddle2.targetY = paddleTargetY(paddle2, KeyboardKey.KEY_UP, KeyboardKey.KEY_DOWN);
            }

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

    void draw()
    {
        drawChildrenBut!("pauseText");
        if (paused)
        {
            pauseText.draw();
        }
    }
}
