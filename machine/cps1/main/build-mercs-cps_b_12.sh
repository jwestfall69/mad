#!/bin/bash
ROMSET=mercs
CPS_B=cps_b_12

make -f Makefile.$ROMSET-$CPS_B clean && make -f Makefile.$ROMSET-$CPS_B && cp build/$ROMSET/so2* ../../../../mame/roms/$ROMSET/
