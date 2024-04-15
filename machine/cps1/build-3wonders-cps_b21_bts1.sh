#!/bin/bash
CPS_B=cps_b_21_bts1
ROMSET=3wonders

make -f Makefile.$ROMSET-$CPS_B clean && make -f Makefile.$ROMSET-$CPS_B && cp build/$ROMSET/rte* ../../../mame/roms/$ROMSET/
