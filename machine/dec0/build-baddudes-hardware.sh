#!/bin/bash
ROMSET=baddudes

make -f Makefile.$ROMSET-hardware clean && make -f Makefile.$ROMSET-hardware
