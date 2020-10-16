import cdefs;
import objects;
import object_list;
import raylib;

Game!2 game;

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
    debug {} else
    {
        SetTraceLogLevel(TraceLogType.LOG_ERROR);
    }
    InitWindow(800, 600, "PongStruct");

    game.addObject(PongGame.create());

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
