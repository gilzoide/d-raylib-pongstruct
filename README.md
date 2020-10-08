# PongStruct
[D](https://dlang.org/) + [raylib](https://github.com/raysan5/raylib)
powered Pong game with no class (structs only).


## Compiling
This project is configured using [DUB](https://code.dlang.org/) and may be run with the following command:

    $ dub [--parallel]


There is also a configuration for [emscripten](https://emscripten.org/)
based Web builds. For Web builds, `emcc` must be available in `PATH` and the [ldc](https://github.com/ldc-developers/ldc) compiler must be used:

    $ dub build --compiler=ldc --config=web [--parallel]


Build artifacts are located in the `build` folder.
