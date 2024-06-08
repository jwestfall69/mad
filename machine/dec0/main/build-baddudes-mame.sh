#!/bin/bash
ROMSET=baddudes

make -f Makefile.$ROMSET-mame clean && make -f Makefile.$ROMSET-mame && cp build/mame/$ROMSET/e* ../../../../mame/roms/$ROMSET/
