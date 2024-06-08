#!/bin/bash
ROMSET=ghouls
CPS_B=cps_b_01

make -f Makefile.$ROMSET-$CPS_B clean && make -f Makefile.$ROMSET-$CPS_B && cp build/$ROMSET/dme* ../../../../mame/roms/$ROMSET/
