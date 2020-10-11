import raylib;
import objects;

PongGame game;

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

version (WebAssembly)
{
    alias em_callback_func = void function();
    extern(C) void emscripten_set_main_loop(em_callback_func, int, int);
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
