#!/bin/sh

script_root=$(dirname $(realpath $0))
project_root="$script_root/.."

build_ninja="$project_root/build/release/win32/build.ninja"
sed -i -E 's/-m(32|64) //g' "$build_ninja"
