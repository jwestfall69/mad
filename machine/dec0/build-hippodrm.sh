#!/bin/bash
ROMSET=hippodrm

make -f Makefile.$ROMSET clean && make -f Makefile.$ROMSET && cp build/$ROMSET/e* ../../../mame/roms/$ROMSET/
