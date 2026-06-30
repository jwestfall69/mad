#!/bin/bash

make -f Makefile clean && make -f Makefile && cp build/tse* ../../../../mame/roms/bionicc/
