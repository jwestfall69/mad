#!/bin/bash
make -f Makefile.mame clean && make -f Makefile.mame && cp build/mame/633* ../../../../mame/roms/contra/
