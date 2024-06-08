#!/bin/bash
CPS_B=cps_b_11
ROMSET=sf2

make -f Makefile.$ROMSET-$CPS_B clean && make -f Makefile.$ROMSET-$CPS_B && cp build/$ROMSET/sf2e* ../../../../mame/roms/$ROMSET/
