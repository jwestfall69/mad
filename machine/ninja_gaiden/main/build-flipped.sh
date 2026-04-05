#!/bin/bash

make -f Makefile.flipped clean && make -f Makefile.flipped && cp build/flipped/gaiden_* ../../../../mame/roms/gaiden/
