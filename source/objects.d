module objects;

import constants;
import inherit_struct;
import raylib;
import shapes;

struct Ball
{
    mixin InheritStruct!FilledCircle;

    Vector2 velocity = { ballVelocity, ballVelocity };
    bool hitLeftEdge = false;
    bool hitRightEdge = false;

    void update(float dt)
    {
        position.x += dt * velocity.x;
        position.y += dt * velocity.y;

        hitLeftEdge = position.x - radius < 0;
        hitRightEdge = position.x + radius > windowWidth;

        if (position.y - radius < 0) {
            velocity.y = ballVelocity;
        }
        else if (position.y + radius > windowHeight)
        {
            velocity.y = -ballVelocity;
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
    
    void draw() const
    {
        DrawRectangleRounded(getRectangle(), 12, 12, color);
    }
}

struct Score
{
    Vector2 position;
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
        DrawText(cast(char *) buffer, cast(int) position.x, cast(int) position.y, scoreFontSize, color);
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

    Score score1 = {
        position: { windowWidth * 0.25, 20 },
    };
    Score score2 = {
        position: { windowWidth * 0.75, 20 },
    };

    Ball ball = {
        position: { windowWidth * 0.5, windowHeight * 0.5 },
        radius: 15,
    };

    int p1Points = 0;
    int p2Points = 0;

    void resetBall(bool goingLeft)
    {
        with (ball)
        {
            position = PongGame.init.ball.position;
            velocity = Vector2((goingLeft ? ballVelocity : -ballVelocity), ballVelocity);
        }
    }

    mixin UpdateDraw;

    void update(float dt)
    {
        updateChildren(dt);

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

    void draw()
    {
        drawChildren();
    }
}
