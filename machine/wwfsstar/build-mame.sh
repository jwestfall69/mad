#!/bin/bash
make -f Makefile.mame clean && make -f Makefile.mame && cp build/mame/24* ../../../mame/roms/wwfsstar/
