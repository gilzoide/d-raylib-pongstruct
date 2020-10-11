import cdefs;
import objects;
import raylib;

PongGame game;

extern(C)
void UpdateDrawFrame()
{
    float dt = GetFrameTime();
    game.update(dt);

	BeginDrawing();
		ClearBackground(Colors.BLACK);
        game.draw();
        debug
        {
            DrawFPS(0, 0);
        }
	EndDrawing();
}

extern(C)
void main()
{
    InitWindow(800, 600, "PongStruct");

    game.initialize();

    version (WebAssembly)
    {
        emscripten_set_main_loop(&UpdateDrawFrame, 0, 1);
    }
    else
    {
        SetTargetFPS(61);
        while (!WindowShouldClose())
        {
            UpdateDrawFrame();
        }
    }

    CloseWindow();
}
