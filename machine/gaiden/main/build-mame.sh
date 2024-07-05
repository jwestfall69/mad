#!/bin/bash

make -f Makefile.mame clean && make -f Makefile.mame && cp build/mame/gaiden_* ../../../../mame/roms/gaiden/
