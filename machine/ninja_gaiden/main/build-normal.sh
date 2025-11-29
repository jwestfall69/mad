#!/bin/bash

make -f Makefile.normal clean && make -f Makefile.normal && cp build/normal/gaiden_* ../../../../mame/roms/gaiden/
