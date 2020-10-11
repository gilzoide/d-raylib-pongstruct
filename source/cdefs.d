module cdefs;

extern(C):

// core.stdc.stdio gives an error for mingw, so import definitions here
int printf(const char *, ...);
int sprintf(char *, const char *, ...);

// emscripten definitions
version (WebAssembly)
{
    alias em_callback_func = void function();
    void emscripten_set_main_loop(em_callback_func, int, int);
}
