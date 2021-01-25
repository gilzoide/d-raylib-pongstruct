import gargula;

import constants;
import shapes;

struct ButtonWithText
{
    mixin Node;

    Frame frame = Frame.from(0, 0, 100, 100);

    StaticText title = {
        anchor: 0.5,
        fontSize: menuFontSize,
    };

    void initialize()
    {
        title.x = cast(int) frame.centerX;
        title.y = cast(int) frame.centerY;
    }

    void draw()
    {
        title.draw();

        auto mouse = GetMousePosition();
        if (frame.checkCollision(mouse))
        {
            frame.drawLines(2, YELLOW);
        }
    }
}

struct Menu
{
    mixin Node;

    ButtonWithText playButton = {
        frame: Frame.from(200, 200, 400, 100),
        title: {
            anchor: 0.5,
            fontSize: menuFontSize,
            text: "PLAY",
        }
    };

    ButtonWithText exitButton = {
        frame: Frame.from(200, 300, 400, 100),
        title: {
            anchor: 0.5,
            fontSize: menuFontSize,
            text: "EXIT",
        }
    };
}
