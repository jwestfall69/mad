# MAD - Multiple Arcade Diagnostic
**IMPORTANT**: This is an experiment at this point.  There maybe
large changes as I get things figured out.

Having created a couple different diagnostic roms/bios for arcade boards I
wanted to look into making it easier/faster to write new ones.  The idea behind
this project is to have a framework that contains all of the common code that
exists between diag roms from different boards.  Stuff like ram tests, menu
systems, memory viewer, displaying player/dsw inputs, sending a byte to the
sound latch, etc.

In general adding a new board entails understanding how to initialize the
hardware, figuring out how to print to the screen (including palette setup),
then just hooking up the common tests (ram, io, sound, etc).  MAD has already
helped me track down issues in my toki (bad joystick inputs) and wwfsstar
(failed palette upper ram chip) boards. Additionally its been used to help
[MAME](https://github.com/search?q=repo%3Amamedev%2Fmame+Westfall&type=commits) better understand how some of the custom chips work.

You can grab the latest compiled version here

https://www.mvs-scans.com/mad/mad-main.zip

Support boards

### 1943 (1943)
![1943](machine/1943/docs/images/mad_1943_main_menu.png)

### Aliens (aliens)
![Aliens](machine/aliens/docs/images/mad_aliens_main_menu.png)

### Alpha68K II based games
![alpha68k_ii](machine/alpha68k_ii/docs/images/mad_alpha68k_ii_main_menu.png)<br>
**Sky Solder (skysoldr)**<br>
**Time Solder (timesold)**<br>

### Blades of Steel (bladestl)
![bladestl](machine/blades_of_steel/docs/images/mad_blades_of_steel_main_menu.png)

### Block Hole (blockhl)
![blockhl](machine/block_hole/docs/images/mad_block_hole_main_menu.png)

### Capcom 85608 Board
![capcom 85608](machine/capcom_85608/docs/images/mad_85608_main_menu.png)

**Avengers (avengers)**<br>
**Trojan (trojan)**

### Contra (contra)
![contra](machine/contra/docs/images/mad_contra_main_menu.png)

### CPS1
**Three Wonders** (3wonders with cps_b21_bts1)<br>
![cps1 3wonders](docs/images/cps1/3wonders.png)

**Captain Commando** (captcomm with cps_b21_bts3)<br>
![cps1 captcomm](docs/images/cps1/captcomm.png)

**Ghouls'n Ghosts** (ghouls with cps_b01)<br>
![cps1 ghouls](docs/images/cps1/ghouls.png)

**Street Fighter II: The World Warrior** (sf2 with cps_b11)<br>
![cps1 sf2](docs/images/cps1/sf2.png)

### CPS2 (suicided & encrypted boards)
![cps2](machine/cps2/docs/images/mad_cps2_main_menu.png)

**1944: The Loop Master (Euro)** (1944)<br>
**19XX: The War Against Destiny (Euro)** (19xx)<br>
**Dungeons & Dragons: Tower of Doom (Euro)** (ddotd)<br>
**Vampire Savior: The Lord of Vampire (USA)** (vsavu)<br>
**X-Men: Children of the Atom (Asia)** (xmcotaa)<br>
**Generic Suicided Games**

### Crime Fighters (crimfght)
![crimfght](machine/crime_fighters/docs/images/mad_crime_fighters_main_menu.png)

### dec0 based games
**Bad Dudes vs. Dragonninja** (baddudes)<br>
![dec0 baddudes](docs/images/dec0/baddudes.png)

**Heavy Barrel** (hbarrel)<br>
![dec0 hbarrel](docs/images/dec0/hbarrel.png)

**Hippodrome** (hippodrm)<br>
![dec0 hippodrm](docs/images/dec0/hippodrm.png)

**Hyper Dyne Side Arms** (sidearms)<br>
![sidearms](machine/sidearms/docs/images/mad_sidearms_main_menu.png)

**Robocop** (robocop)<br>
![dec0 robocop](docs/images/dec0/robocop.png)

### Devastators (devstors)
![devstors](machine/devastators/docs/images/mad_devastators_main_menu.png)

### Mitchell based games
![mitchell](machine/mitchell/docs/images/mad_mitchell_main_menu.png)<br>
**Mahjong Gakuen 2 Gakuen-chou no Fukushuu (mgakeun2)**<br>
**Pang/Buster Bros**<br>
**Poker Ladies**<br>
**Quiz Sangokushi**<br>
**Quiz Tonosama no Yabou (qtono1)**<br>
**Super Pang/Super Buster Bros**<br>

### MX5000 / Flak Attack (mx5000)
![mx5000](machine/mx5000/docs/images/mad_mx5000_main_menu.png)

### Ninja Gaiden (gaiden)
![gaiden](machine/ninja_gaiden/docs/images/mad_gaiden_main_menu.png)

### Rollergames (rollerg)
![rollerg](machine/rollergames/docs/images/mad_rollerg_main_menu.png)

### Rush 'n Attack (rushatck)
![rushatck](machine/rush_n_attack/docs/images/mad_rush_n_attack_main_menu.png)

### Teenage Mutant Ninja Turtles (tmnt)
![tmnt](machine/tmnt/docs/images/mad_tmnt_main_menu.png)

### The Main Event (mainevt)
![mainevt](machine/the_main_event/docs/images/mad_the_main_event_main_menu.png)

### The Real Ghostbusters (ghostb)
![ghostb](machine/the_real_ghostbusters/docs/images/mad_the_real_ghostbusters_main_menu.png)

### The Simpsons (simpsons)
![simpsons](machine/the_simpsons/docs/images/mad_simpsons_main_menu.png)

### Toki (toki)
![toki](machine/toki/docs/images/mad_toki_main_menu.png)

### Vendetta (vendetta)
![vendetta](machine/vendetta/docs/images/mad_vendetta_main_menu.png)

### WWF Superstars (wwfsstar)
![wwfsstar](machine/wwf_superstars/docs/images/mad_wwfsstar_main_menu.png)

### WWF Wrestlefest (wwfwfest)
![wwfwfest](machine/wwf_wrestlefest/docs/images/mad_wwfwfest_main_menu.png)

### X-Men (xmen)
![xmen](machine/x-men/docs/images/mad_xmen_main_menu.png)

## Building
I've been doing most of my development in window subsystem for linux (wsl).
This makes it easy to compile, test in mame, and then burn to an eprom for
testing on hardware.

I'm using debian wsl.  You will want to `apt-get install build-essential` to get gcc/make.

vasm and vlink are need to for compiling the m68k source code, which are available here

http://sun.hasenbraten.de/vasm/<br>
http://sun.hasenbraten.de/vlink/

The version of vasm needs to be >= 2.0c.  For vasm you will need the
vasm6809_mot, vasmm68k_mot and vasmz80_mot variants. If you are building vasm
from source, you can build it with the following commands from where ever you
decompressed vasm.tar.gz.

```
$ make CPU=6809 SYNTAX=mot
$ make CPU=m68k SYNTAX=mot
$ make CPU=z80 SYNTAX=mot
```

Copy the resulting vasm6809_mot, vasmm68k_mot and vasmz80_mot (and vlink, when
you get that compiled) so they are within your $PATH (ie: /usr/local/bin/)

The top level `Makefile` should be able to build everything.

```
jwestfall@DESKTOP-7LADK23:/mnt/c/Users/jwestfall/Desktop/mad$ make
make -C util
make[1]: Entering directory '/mnt/c/Users/jwestfall/Desktop/mad/util'
cc rom-byte-split.c -o rom-byte-split
cc rom-inject-crc-mirror.c -o rom-inject-crc-mirror
make[1]: Leaving directory '/mnt/c/Users/jwestfall/Desktop/mad/util'
make -C machine
make[1]: Entering directory '/mnt/c/Users/jwestfall/Desktop/mad/machine'
for DIR in aliens/main/ alpha68k_ii/main/ blades_of_steel/main/ block_hole/main/ contra/main/ cps1/main/ cps2/main/ crime_fighters/main/ dec0/main/ devastators/main/ mitchell/main/ ninja_gaiden/main/ rollergames/main/ rush_n_attack/main/ the_main_event/main/ the_real_ghostbusters/main/ tmnt/main/ toki/main/ vendetta/main/ wwf_superstars/main/ wwf_wrestlefest/main/; do \
        make -C $DIR; \
done
make[2]: Entering directory '/mnt/c/Users/jwestfall/Desktop/mad/machine/aliens/main'
mkdir -p build/work
make[2]: Warning: File 'build' has modification time 74 s in the future
vasm6809_mot -konami2 -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet -D_CPU_KONAMI2_ -D_DEBUG_HARDWARE_ -o build/obj/cpu/6x09/src/header.o ../../../common/cpu/6x09/src/header.asm
vasm6809_mot -konami2 -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet -D_CPU_KONAMI2_ -D_DEBUG_HARDWARE_ -o build/obj/cpu/6x09/src/input_update.o ../../../common/cpu/6x09/src/input_update.asm
vasm6809_mot -konami2 -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet -D_CPU_KONAMI2_ -D_DEBUG_HARDWARE_ -o build/obj/cpu/6x09/src/print_error.o ../../../common/cpu/6x09/src/print_error.asm
vasm6809_mot -konami2 -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet -D_CPU_KONAMI2_ -D_DEBUG_HARDWARE_ -o build/obj/cpu/6x09/src/util.o ../../../common/cpu/6x09/src/util.asm
vasm6809_mot -konami2 -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet -D_CPU_KONAMI2_ -D_DEBUG_HARDWARE_ -o build/obj/cpu/6x09/src/xy_string.o ../../../common/cpu/6x09/src/xy_string.asm
vasm6809_mot -konami2 -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet -D_CPU_KONAMI2_ -D_DEBUG_HARDWARE_ -o build/obj/cpu/6x09/src/debug/error_address_test.o ../../../common/cpu/6x09/src/debug/error_address_test.asm
vasm6809_mot -konami2 -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet -D_CPU_KONAMI2_ -D_DEBUG_HARDWARE_ -o build/obj/cpu/6x09/src/debug/mad_git_hash.o ../../../common/cpu/6x09/src/debug/mad_git_hash.asm
vasm6809_mot -konami2 -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet -D_CPU_KONAMI2_ -D_DEBUG_HARDWARE_ -o build/obj/cpu/6x09/src/handlers/auto_test.o ../../../common/cpu/6x09/src/handlers/auto_test.asm
vasm6809_mot -konami2 -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet -D_CPU_KONAMI2_ -D_DEBUG_HARDWARE_ -o build/obj/cpu/6x09/src/handlers/error.o ../../../common/cpu/6x09/src/handlers/error.asm
vasm6809_mot -konami2 -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet -D_CPU_KONAMI2_ -D_DEBUG_HARDWARE_ -o build/obj/cpu/6x09/src/handlers/memory_viewer.o ../../../common/cpu/6x09/src/handlers/memory_viewer.asm
vasm6809_mot -konami2 -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet -D_CPU_KONAMI2_ -D_DEBUG_HARDWARE_ -o build/obj/cpu/6x09/src/handlers/menu.o ../../../common/cpu/6x09/src/handlers/menu.asm
vasm6809_mot -konami2 -Fvobj -spaces -chklabels -Iinclude -I../../../common -wfail -quiet -D_CPU_KONAMI2_ -D_DEBUG_HARDWARE_ -o build/obj/cpu/6x09/src/handlers/sound.o ../../../common/cpu/6x09/src/handlers/sound.asm
...
```

If you are want to mess with a specific machine/board you can run the `Makefile`
under `machine/<machine>`.  Each machine will have a `main` directory which will
be MAD for the main CPU.  Some machines will have a `sound` directory which will
be MAD for the sound CPU.

Once compiled the roms will be located under
`machine/<machine>/(main|sound)/build` directory.  In some cases there will be
separate builds for MAME and hardware.  This will be because MAME is doing
something different from hardware and it warrents having the different builds.
