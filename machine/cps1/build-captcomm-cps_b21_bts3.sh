#!/bin/bash
CPS_B=cps_b_21_bts3
ROMSET=captcomm

make -f Makefile.$ROMSET-$CPS_B clean && make -f Makefile.$ROMSET-$CPS_B && cp build/$ROMSET/cce* ../../../mame/roms/$ROMSET/
