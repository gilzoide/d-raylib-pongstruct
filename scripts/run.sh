#!/bin/sh
#curdir=$(realpath $(dirname $0))  # OSX doesn't have `realpath`
curdir=$(perl -e 'use File::Basename; use Cwd "abs_path"; print dirname(abs_path(@ARGV[0]));' -- "$0")

env LD_LIBRARY_PATH=$curdir DYLD_LIBRARY_PATH=$curdir $curdir/rayd-base
