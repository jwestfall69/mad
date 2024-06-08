#!/bin/bash
ROMSET=hbarrel

make -f Makefile.$ROMSET-hardware clean && make -f Makefile.$ROMSET-hardware
