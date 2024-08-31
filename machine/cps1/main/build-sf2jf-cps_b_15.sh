#!/bin/bash
CPS_B=cps_b_15
ROMSET=sf2jf

make -f Makefile.$ROMSET-$CPS_B clean && make -f Makefile.$ROMSET-$CPS_B && cp build/$ROMSET/sf2j* ../../../../mame/roms/$ROMSET/
