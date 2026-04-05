#!/bin/bash

make -f Makefile.vsavu clean && make -f Makefile.vsavu && cp build/vsavu/encrypted-vm3u.03d ../../../../mame/roms/vsavu/vm3u.03d && cp build/vsavu/suicide-vm3u.03d ../../../../mame/roms/vsavd/vm3ed.03d
