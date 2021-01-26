#!/bin/sh

script_root=$(dirname $(realpath $0))
project_root="$script_root/.."

maybewipe() {
    dir="$project_root/$1"
    wipeflag=$([ -d "$dir" ] && echo --wipe)
    echo "$dir" $wipeflag
}

env DC=gdc meson setup $(maybewipe build)
env DC=ldc meson setup $(maybewipe build/betterC)
env DC=ldc meson setup --buildtype release $(maybewipe build/release)
meson setup --cross-file subprojects/gargula/cross-file/web.ini $(maybewipe build/web)
meson setup --cross-file subprojects/gargula/cross-file/web.ini -Ddebug=false -Doptimization=s $(maybewipe build/release/web)

meson setup --buildtype release --cross-file subprojects/gargula/cross-file/windows32.ini $(maybewipe build/release/win32)
