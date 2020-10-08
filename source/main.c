#include <raylib.h>

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

void UpdateDrawFrame();

int main() {
	InitWindow(800, 600, "PONGStruct");

	SetTargetFPS(60);

#ifdef __EMSCRIPTEN__
	emscripten_set_main_loop(UpdateDrawFrame, 0, 1);
#else
	while (!WindowShouldClose())
	{
		UpdateDrawFrame();
	}
#endif

	CloseWindow();
}
