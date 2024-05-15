#!/bin/bash
ROMSET=robocop

make -f Makefile.$ROMSET-hardware clean && make -f Makefile.$ROMSET-hardware
