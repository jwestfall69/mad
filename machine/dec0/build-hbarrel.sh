#!/bin/bash
ROMSET=hbarrel

make -f Makefile.$ROMSET clean && make -f Makefile.$ROMSET && cp build/$ROMSET/e* ~/.mame/roms/$ROMSET/
