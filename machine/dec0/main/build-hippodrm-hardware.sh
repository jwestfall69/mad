#!/bin/bash
ROMSET=hippodrm

make -f Makefile.$ROMSET-hardware clean && make -f Makefile.$ROMSET-hardware
