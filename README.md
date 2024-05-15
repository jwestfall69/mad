# MAD - Multiple Arcade Diag
**IMPORTANT**: This is an experiment at this point.  There maybe large changes as I get things figured out.

Having created a couple different diagnostic roms/bios for arcade boards I wanted to look into making it easier/faster to write new ones.  The idea behind this project is to have a framework that contains all of the common code that exists between diag roms from different boards.  Stuff like ram tests, menu systems, memory viewer, displaying player/dsw inputs, sending a byte to the sound latch, etc.

Currently I've been soley focusing on m68k based boards.  Once I'm satisfied with the m68k code and layout I want to look into adding other cpus.  I think ideally I would want to be able to have diag roms for both the main cpu and the sound cpu for each board.  But thats a long way off.

In general adding a new board entails understanding how to initialize the hardware, figuring out how to print to the screen (including palette setup), then just hooking up the commom tests (ram, io, sound, etc).  MAD has already helped me track down issues in my toki (bad joystick inputs) and wwfsstar (failed palette upper ram chip) boards.

Below is the list of boards that I'm currently using to develope MAD.  These were picked because I have them and its a good mix of manufacturers, individual game boards vs multiple games (rom boards) on a single platform.  This has been to help me understand what all can be merged into common code and what type of one-offs may exist and how to deal with them.

### CPS1
**Three Wonders** (3wonders with cps_b21_bts1)<br>
![cps1 3wonders](docs/images/cps1-3wonders.png)

**Captain Commando** (captcomm with cps_b21_bts3)<br>
![cps1 captcomm](docs/images/cps1-captcomm.png)

**Ghouls'n Ghosts** (ghouls with cps_b01)<br>
![cps1 ghouls](docs/images/cps1-ghouls.png)

**Street Fighter II: The World Warrior** (sf2 with cps_b11)<br>
![cps1 sf2](docs/images/cps1-sf2.png)

### dec0 based games
**Bad Dudes vs. Dragonninja** (baddudes)<br>
![dec0 baddudes](docs/images/dec0-baddudes.png)

**Heavy Barrel** (hbarrel)<br>
![dec0 hbarrel](docs/images/dec0-hbarrel.png)

**Hippodrome** (hippodrm)<br>
![dec0 hippodrm](docs/images/dec0-hippodrm.png)

**Robocop** (robocop)<br>
![dec0 robocop](docs/images/dec0-robocop.png)

### Toki
![toki](docs/images/toki.png)

### WWF Superstars (wwfsstar)
![wwfsstar](docs/images/wwfsstar.png)

### WWF Wrestlefest (wwfwfest)
![wwfwfest](docs/images/wwfwfest.png)

## Building
I've been doing most of my developemnt in window subsystem for linux (wsl).  This makes it easy to compile, test in mame, and then burn to an eprom for testing on hardware.

I'm using debian wsl.  You will want to `apt-get install build-essential` to get gcc/make.

vasm and vlink are need to for compiling the m68k source code, which are available here

http://sun.hasenbraten.de/vasm/<br>
http://sun.hasenbraten.de/vlink/

For vasm you will need the vasmm68k_mot variant.  If you are building vasm from source, you can build it with the following command from where ever you decompressed vasm.tar.gz.

```
$ make CPU=m68k SYNTAX=mot
```

Copy the resulting vasmm68k_mot (and vlink, when you get that compiled) so they are within your $PATH (ie: /usr/local/bin/)

The first thing you will want to is run `make` in the `util` dir, which has a couple utils that deal with crc/mirror injection and rom splitting.

Under the machine/ directory are the available board types:

```
jwestfall@DESKTOP-7LADK23:/mnt/c/Users/jwestfall/Desktop/mad/machine$ ls -la
total 0
drwxrwxrwx 1 jwestfall jwestfall 4096 May  9 17:56 .
drwxrwxrwx 1 jwestfall jwestfall 4096 May 13 18:31 ..
drwxrwxrwx 1 jwestfall jwestfall 4096 May 12 14:22 cps1
drwxrwxrwx 1 jwestfall jwestfall 4096 May 12 14:22 dec0
drwxrwxrwx 1 jwestfall jwestfall 4096 May 12 14:22 toki
drwxrwxrwx 1 jwestfall jwestfall 4096 May 12 14:21 wwfsstar
drwxrwxrwx 1 jwestfall jwestfall 4096 May 12 14:19 wwfwfest
```

Inside of these will be Makefiles for generating the roms for the given board/romset.

```
jwestfall@DESKTOP-7LADK23:/mnt/c/Users/jwestfall/Desktop/mad/machine/dec0$ ls -la
total 4
drwxrwxrwx 1 jwestfall jwestfall 4096 May 13  2024 .
drwxrwxrwx 1 jwestfall jwestfall 4096 May  9 17:56 ..
-rwxrwxrwx 1 jwestfall jwestfall  139 Apr 14 18:31 build-baddudes.sh
-rwxrwxrwx 1 jwestfall jwestfall  138 Apr 14 18:34 build-hbarrel.sh
-rwxrwxrwx 1 jwestfall jwestfall  139 Apr 14 18:34 build-hippodrm.sh
-rwxrwxrwx 1 jwestfall jwestfall  138 Apr 14 18:34 build-robocop.sh
-rwxrwxrwx 1 jwestfall jwestfall 2438 May 12 14:22 common.mk
-rwxrwxrwx 1 jwestfall jwestfall  267 Apr  9 17:59 diag_rom.ld
drwxrwxrwx 1 jwestfall jwestfall 4096 May 12 10:17 include
-rwxrwxrwx 1 jwestfall jwestfall   99 Apr  9 17:59 Makefile.baddudes
-rwxrwxrwx 1 jwestfall jwestfall  114 Apr  9 17:59 Makefile.hbarrel
-rwxrwxrwx 1 jwestfall jwestfall  121 Apr  9 17:59 Makefile.hippodrm
-rwxrwxrwx 1 jwestfall jwestfall   99 Apr  9 17:59 Makefile.robocop
drwxrwxrwx 1 jwestfall jwestfall 4096 May 11 11:09 src
```

The build*.sh are specific to my setup and may not work for you.  They build the roms then copy them into my mame's roms/[romset]/ directory.  However you can just run `make -f Makefile.xxx` to build the roms for the specific board/romset.

```
jwestfall@DESKTOP-7LADK23:/mnt/c/Users/jwestfall/Desktop/mad/machine/dec0$ make -f Makefile.robocop
mkdir -p build/robocop/work
mkdir -p build/robocop/obj/tests build/robocop/obj/cpu/68000/handlers build/robocop/obj/cpu/68000/tests
vasmm68k_mot -Fvobj -m68000 -spaces -chklabels -Iinclude -I../../common/include  -quiet -D_ROMSET_ROBOCOP_ -o build/robocop/obj/cpu/68000/crc32.o ../../common/src/cpu/68000/crc32.asm
vasmm68k_mot -Fvobj -m68000 -spaces -chklabels -Iinclude -I../../common/include  -quiet -D_ROMSET_ROBOCOP_ -o build/robocop/obj/cpu/68000/dsub.o ../../common/src/cpu/68000/dsub.asm
vasmm68k_mot -Fvobj -m68000 -spaces -chklabels -Iinclude -I../../common/include  -quiet -D_ROMSET_ROBOCOP_ -o build/robocop/obj/cpu/68000/input_update.o ../../common/src/cpu/68000/input_update.asm

...

vasmm68k_mot -Fvobj -m68000 -spaces -chklabels -Iinclude -I../../common/include  -quiet -D_ROMSET_ROBOCOP_ -o build/robocop/obj/tests/sprite_ram.o src/tests/sprite_ram.asm
vasmm68k_mot -Fvobj -m68000 -spaces -chklabels -Iinclude -I../../common/include  -quiet -D_ROMSET_ROBOCOP_ -o build/robocop/obj/tests/work_ram.o src/tests/work_ram.asm
vlink -brawbin1 -Tdiag_rom.ld -o build/robocop/work/dec0_diag.bin build/robocop/obj/cpu/68000/crc32.o build/robocop/obj/cpu/68000/dsub.o build/robocop/obj/cpu/68000/input_update.o build/robocop/obj/cpu/68000/memory_fill.o build/robocop/obj/cpu/68000/menu_input_generic.o build/robocop/obj/cpu/68000/print_error.o build/robocop/obj/cpu/68000/util.o build/robocop/obj/cpu/68000/xy_string.o build/robocop/obj/cpu/68000/handlers/error.o build/robocop/obj/cpu/68000/handlers/memory_viewer.o build/robocop/obj/cpu/68000/handlers/memory_tests.o build/robocop/obj/cpu/68000/handlers/menu.o build/robocop/obj/cpu/68000/handlers/sound.o build/robocop/obj/cpu/68000/tests/auto.o build/robocop/obj/cpu/68000/tests/diag_rom.o build/robocop/obj/cpu/68000/tests/input.o build/robocop/obj/cpu/68000/tests/memory.o build/robocop/obj/dec0_diag.o build/robocop/obj/errors.o build/robocop/obj/footer.o build/robocop/obj/main_menu.o build/robocop/obj/memory_viewer_menu.o build/robocop/obj/print.o build/robocop/obj/screen.o build/robocop/obj/vector_table.o build/robocop/obj/tests/auto.o build/robocop/obj/tests/input.o build/robocop/obj/tests/palette_ram.o build/robocop/obj/tests/palette_ext_ram.o build/robocop/obj/tests/sound.o build/robocop/obj/tests/sprite_ram.o build/robocop/obj/tests/work_ram.o
../../util/rom-inject-crc-mirror -f build/robocop/work/dec0_diag.bin -t 131072
Using ROM: build/robocop/work/dec0_diag.bin
Start Size:   0x8000
Target Size:  0x20000
CRC32 Range:  0x0 - 0x7ffb
CRC32:        0x87fe30dc
Mirrors:      0x3
../../util/rom-byte-split build/robocop/work/dec0_diag.bin build/robocop/ep05-4.11c build/robocop/ep01-4.11b
Input ROM: build/robocop/work/dec0_diag.bin (131072 bytes)
Output ROM #1: build/robocop/ep05-4.11c (65536 bytes)
Output ROM #2: build/robocop/ep01-4.11b (65536 bytes)
```

From there you can use the Output ROMs in the build/ directory with mame or burn them to eproms to use on the hardware.

In some cases there will be different Makefiles for mame vs hardware.

```
jwestfall@DESKTOP-7LADK23:/mnt/c/Users/jwestfall/Desktop/mad/machine/wwfsstar$ ls -l
total 12
-rwxrwxrwx 1 jwestfall jwestfall   73 Apr 24 19:16 build-hardware.sh
-rwxrwxrwx 1 jwestfall jwestfall  115 Apr 24 19:16 build-mame.sh
-rwxrwxrwx 1 jwestfall jwestfall 2350 May 12 14:21 common.mk
-rwxrwxrwx 1 jwestfall jwestfall  267 Apr  9 17:59 diag_rom.ld
drwxrwxrwx 1 jwestfall jwestfall 4096 May 12 10:17 include
-rwxrwxrwx 1 jwestfall jwestfall  183 Apr 24 19:13 Makefile.hardware
-rwxrwxrwx 1 jwestfall jwestfall  193 Apr 24 19:13 Makefile.mame
-rwxrwxrwx 1 jwestfall jwestfall  792 Apr 28 12:43 README.md
drwxrwxrwx 1 jwestfall jwestfall 4096 May 11 11:08 src
```
These will be do to a behavior difference between mame vs hardware.  The most common case is mame not allowing reads on some memory regions while its allowed on hardware.  The mame build will have the corresponding tests disabled to prevent false errors.