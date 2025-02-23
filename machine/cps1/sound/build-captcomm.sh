#!/bin/bash
ROMSET=captcomm

make -f Makefile.$ROMSET clean && make -f Makefile.$ROMSET && cp build/$ROMSET/cc* ../../../../mame/roms/$ROMSET/
