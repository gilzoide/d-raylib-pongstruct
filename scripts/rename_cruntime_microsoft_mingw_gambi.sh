#!/bin/sh

script_root=$(dirname $(realpath $0))
project_root="$script_root/.."

stdio_file="$project_root/lib/druntime/src/core/stdc/stdio.d"
errno_file="$project_root/lib/druntime/src/core/stdc/errno.d"

sed_script='s/CRuntime_Microsoft/MinGW/g'
sed -i "$sed_script" "$stdio_file"
sed -i "$sed_script" "$errno_file"
