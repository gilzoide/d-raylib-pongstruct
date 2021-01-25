import gargula;

import constants;
import shapes;

package enum GameConfig config = {
    title: "PongStruct",
    clearColor: BLACK,
    width: windowWidth,
    height: windowHeight,
};
alias Game = GameTemplate!(config);

// main
version (D_BetterC)
{
    extern(C) void main(int argc, const char** argv)
    {
        auto game = Game(argc, argv);
        game.create!PongGame;
        game.run();
    }
}
else
{
    void main(string[] args)
    {
        auto game = Game(args);
        game.create!PongGame;
        game.run();
    }
}

// game objects
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
    mixin Node;

    Circle circle;
    alias circle this;

    Vector2 velocity = [ballVelocity, ballVelocity];
    Color color = WHITE;
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

    void update()
    {
        const float dt = GetFrameTime();
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
    mixin Node;

    Frame rect = Frame.from(0, 0, paddleWidth, paddleHeight);
    alias rect this;

    float linearVelocity = paddleVelocity;
    Color color = WHITE;

    float targetY;
    MoveDirection movingTo;

    void update()
    {
        const float dt = GetFrameTime();
        float targetDelta = targetY - centerY;
        if (targetDelta < -float.epsilon)
        {
            movingTo = MoveDirection.up;
            float delta = max(targetDelta, -dt * linearVelocity);
            rect.start.y += delta;
            if (rect.start.y < 0)
            {
                rect.start.y = 0;
            }
        }
        else if (targetDelta > float.epsilon)
        {
            movingTo = MoveDirection.down;
            float delta = min(targetDelta, dt * linearVelocity);
            rect.start.y += delta;
            if (rect.bottom > windowHeight)
            {
                rect.start.y = windowHeight - rect.height;
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
    mixin Node;

    int x, y;
    Color color = WHITE;
    

    int points;
    char[4] buffer = "0";

    void increment()
    {
        import core.stdc.stdio : sprintf;
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
    mixin Node;

    bool paused;
    Paddle paddle1;
    Paddle paddle2;

    version (TouchSupport)
    {
        Rectangle paddle1TouchArea = {
            [1, paddleHeight * 0.5],
            [windowWidth * 0.4, windowHeight - paddleHeight * 0.5],
        };
        Rectangle paddle2TouchArea = {
            [windowWidth * 0.6, paddleHeight * 0.5],
            [windowWidth * 0.4, windowHeight - paddleHeight * 0.5],
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
            center: Game.config.size / 2,
            radius: 15,
        },
    };

    StaticText pauseText = {
        x: windowWidth / 2,
        y: windowHeight / 2,
        anchor: 0.5,
        fontSize: pausedFontSize,
        text: "PAUSED",
    };

    //Menu menu = {};

    void initialize()
    {
        SetGesturesEnabled(GESTURE_TAP);
    }
    void lateInitialize()
    {
        paddle1.start.x = paddleWidth * 0.5;
        paddle1.centerY = 0.5 * windowHeight;
        paddle2.start.x = windowWidth - paddleWidth * 1.5;
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

    float paddleTargetY(const Frame paddle, int upKey, int downKey)
    {
        auto movingTo = directionFromUpDown(IsKeyDown(upKey), IsKeyDown(downKey));
        switch (movingTo)
        {
            case MoveDirection.up: return 0;
            case MoveDirection.down: return windowHeight;
            default: return paddle.centerY;
        }
    }

    float paddleTargetY(const Frame paddle, const Rectangle touchArea, int upKey, int downKey)
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

    void update()
    {
        //if (IsKeyPressed(KEY_ENTER))
        //{
            //paused = !paused;
        //}

        //if (!paused)
        //{
            version (TouchSupport)
            {
                paddle1.targetY = paddleTargetY(paddle1, paddle1TouchArea, KEY_W, KEY_S);
                paddle2.targetY = paddleTargetY(paddle2, paddle2TouchArea, KEY_UP, KEY_DOWN);
            }
            else
            {
                paddle1.targetY = paddleTargetY(paddle1, KEY_W, KEY_S);
                paddle2.targetY = paddleTargetY(paddle2, KEY_UP, KEY_DOWN);
            }

        }

    void lateUpdate()
    {
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

    void draw()
    {
        //drawChildrenBut!("pauseText");
        //if (paused)
        //{
            //pauseText.draw();
        //}
    }
}
