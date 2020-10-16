#!/bin/sh
curdir=$(realpath $(dirname $0))

env LD_LIBRARY_PATH=$curdir $curdir/rayd-base
