# SNK68 Hardware

- [MAD Pictures](#mad-pictures)
- [PCBs / ROM sets](#pcbs--rom-sets)
  - [Ikari III (ikari3)](#ikari-iii-ikari3)
    - [MAD Eprom](#mad-eprom)
    - [RAM Locations](#ram-locations)
    - [Manual](#manual)
- [Errors/Error Codes](#errorserror-codes)
  - [Main CPU](#main-cpu)
  - [Sound CPU](#sound-cpu)
- [MAD Notes](#mad-notes)
  - [Sprite RAM](#sprite-ram)
- [MAME vs Hardware](#mame-vs-hardware)

## MAD Pictures
![mad snk68 main menu](docs/images/mad_snk68_main_menu.png)
![mad snk68 tile viewer](docs/images/mad_snk68_tile_viewer.png)
![mad snk68 sprite viewer](docs/images/mad_snk68_sprite_viewer.png)

## PCBs / ROM sets
### Ikari III (ikari3)
<a href="docs/images/ikari3/ikari3_main_pcb_top.png"><img src="docs/images/ikari3/ikari3_main_pcb_top.png" width="40%"></a>
<a href="docs/images/ikari3/ikari3_main_pcb_bottom.png"><img
src="docs/images/ikari3/ikari3_main_pcb_bottom.png" width="40%"></a><br>
<a href="docs/images/ikari3/ikari3_rom_pcb_top.png"><img src="docs/images/ikari3/ikari3_rom_pcb_top.png" width="40%"></a>
<a href="docs/images/ikari3/ikari3_rom_pcb_bottom.png"><img src="docs/images/ikari3/ikari3_rom_pcb_bottom.png" width="40%"></a>

#### MAD Eprom
| Diag | Eprom Type | Location |
| ---- | ---------- | ----------- |
| Main | 27c301 | ik3-2-ver1.c10 @ C10<br>ik3-3-ver1.c9 @ C9 |
| Sound | 27c512 | ik3-5.16d @ D16 |

#### RAM Locations
| RAM | Location | Type |
| -------- | :------- | ----- |
| Tile RAM Lower | J15 | UM6116-2 (2k x 8bit) |
| Tile RAM Upper | K15 | UM6116-2 (2k x 8bit) |
| Palette RAM Lower | C4 | UM6116-2 (2k x 8bit) |
| Palette RAM Upper | C5 | UM6116-2 (2k x 8bit) |
| Sound RAM | C15 | UM6116-2 (2k x 8bit) |
| Sprite #1 RAM | N15 | D3462C-12LL (8k x 8bit) |
| Sprite #2 RAM | P15 | D3462C-12LL (8k x 8bit) |
| Sprite #3 RAM | R15 | D3462C-12LL (8k x 8bit) |
| Work RAM Lower | C7 | D3462C-12LL (2k x 8bit) |
| Work RAM Upper | C13 | D3464C-12LL (2k x 8bit) |

#### Manual
[Ikari III Manual](docs/ikari3_manual.pdf)

## Errors/Error Codes
The main CPU and sound CPU MAD rom should be used independently from each
other.  ie: MAD for the main CPU is expecting the games origin sound rom to be there
in order to play sounds, including making beep codes.

### Main CPU
The main CPU is a motorola 68000.  If an error is encountered during tests
MAD will print the error to the screen, play the beep code, then jump to the
error address

On 68000 the error address is `$6000 | error_code << 5`.  Error codes on 68000
are 7 bits.

<!-- ec_table_main_start -->
| Hex  | Number | Beep Code |     Error Address (A23..A1)    |           Error Text           |
| ---: | -----: | --------: | :----------------------------: | :----------------------------- |
| 0x01 |      1 | 0000 0001 |  000 0000 0011 0000 0001 xxxx  | PALETTE RAM ADDRESS            |
| 0x02 |      2 | 0000 0010 |  000 0000 0011 0000 0010 xxxx  | PALETTE RAM DATA LOWER         |
| 0x03 |      3 | 0000 0011 |  000 0000 0011 0000 0011 xxxx  | PALETTE RAM DATA UPPER         |
| 0x04 |      4 | 0000 0100 |  000 0000 0011 0000 0100 xxxx  | PALETTE RAM DATA BOTH          |
| 0x05 |      5 | 0000 0101 |  000 0000 0011 0000 0101 xxxx  | PALETTE RAM MARCH LOWER        |
| 0x06 |      6 | 0000 0110 |  000 0000 0011 0000 0110 xxxx  | PALETTE RAM MARCH UPPER        |
| 0x07 |      7 | 0000 0111 |  000 0000 0011 0000 0111 xxxx  | PALETTE RAM MARCH BOTH         |
| 0x08 |      8 | 0000 1000 |  000 0000 0011 0000 1000 xxxx  | PALETTE RAM OUTPUT LOWER       |
| 0x09 |      9 | 0000 1001 |  000 0000 0011 0000 1001 xxxx  | PALETTE RAM OUTPUT UPPER       |
| 0x0a |     10 | 0000 1010 |  000 0000 0011 0000 1010 xxxx  | PALETTE RAM OUTPUT BOTH        |
| 0x0b |     11 | 0000 1011 |  000 0000 0011 0000 1011 xxxx  | PALETTE RAM WRITE LOWER        |
| 0x0c |     12 | 0000 1100 |  000 0000 0011 0000 1100 xxxx  | PALETTE RAM WRITE UPPER        |
| 0x0d |     13 | 0000 1101 |  000 0000 0011 0000 1101 xxxx  | PALETTE RAM WRITE BOTH         |
| 0x0e |     14 | 0000 1110 |  000 0000 0011 0000 1110 xxxx  | SPRITE RAM ADDRESS             |
| 0x0f |     15 | 0000 1111 |  000 0000 0011 0000 1111 xxxx  | SPRITE RAM DATA                |
| 0x12 |     18 | 0001 0010 |  000 0000 0011 0001 0010 xxxx  | SPRITE RAM MARCH               |
| 0x15 |     21 | 0001 0101 |  000 0000 0011 0001 0101 xxxx  | SPRITE RAM OUTPUT              |
| 0x18 |     24 | 0001 1000 |  000 0000 0011 0001 1000 xxxx  | SPRITE RAM WRITE               |
| 0x1b |     27 | 0001 1011 |  000 0000 0011 0001 1011 xxxx  | TILE RAM ADDRESS               |
| 0x1c |     28 | 0001 1100 |  000 0000 0011 0001 1100 xxxx  | TILE RAM DATA LOWER            |
| 0x1d |     29 | 0001 1101 |  000 0000 0011 0001 1101 xxxx  | TILE RAM DATA UPPER            |
| 0x1e |     30 | 0001 1110 |  000 0000 0011 0001 1110 xxxx  | TILE RAM DATA BOTH             |
| 0x1f |     31 | 0001 1111 |  000 0000 0011 0001 1111 xxxx  | TILE RAM MARCH LOWER           |
| 0x20 |     32 | 0010 0000 |  000 0000 0011 0010 0000 xxxx  | TILE RAM MARCH UPPER           |
| 0x21 |     33 | 0010 0001 |  000 0000 0011 0010 0001 xxxx  | TILE RAM MARCH BOTH            |
| 0x22 |     34 | 0010 0010 |  000 0000 0011 0010 0010 xxxx  | TILE RAM OUTPUT LOWER          |
| 0x23 |     35 | 0010 0011 |  000 0000 0011 0010 0011 xxxx  | TILE RAM OUTPUT UPPER          |
| 0x24 |     36 | 0010 0100 |  000 0000 0011 0010 0100 xxxx  | TILE RAM OUTPUT BOTH           |
| 0x25 |     37 | 0010 0101 |  000 0000 0011 0010 0101 xxxx  | TILE RAM WRITE LOWER           |
| 0x26 |     38 | 0010 0110 |  000 0000 0011 0010 0110 xxxx  | TILE RAM WRITE UPPER           |
| 0x27 |     39 | 0010 0111 |  000 0000 0011 0010 0111 xxxx  | TILE RAM WRITE BOTH            |
| 0x28 |     40 | 0010 1000 |  000 0000 0011 0010 1000 xxxx  | WORK RAM ADDRESS               |
| 0x29 |     41 | 0010 1001 |  000 0000 0011 0010 1001 xxxx  | WORK RAM DATA LOWER            |
| 0x2a |     42 | 0010 1010 |  000 0000 0011 0010 1010 xxxx  | WORK RAM DATA UPPER            |
| 0x2b |     43 | 0010 1011 |  000 0000 0011 0010 1011 xxxx  | WORK RAM DATA BOTH             |
| 0x2c |     44 | 0010 1100 |  000 0000 0011 0010 1100 xxxx  | WORK RAM MARCH LOWER           |
| 0x2d |     45 | 0010 1101 |  000 0000 0011 0010 1101 xxxx  | WORK RAM MARCH UPPER           |
| 0x2e |     46 | 0010 1110 |  000 0000 0011 0010 1110 xxxx  | WORK RAM MARCH BOTH            |
| 0x2f |     47 | 0010 1111 |  000 0000 0011 0010 1111 xxxx  | WORK RAM OUTPUT LOWER          |
| 0x30 |     48 | 0011 0000 |  000 0000 0011 0011 0000 xxxx  | WORK RAM OUTPUT UPPER          |
| 0x31 |     49 | 0011 0001 |  000 0000 0011 0011 0001 xxxx  | WORK RAM OUTPUT BOTH           |
| 0x32 |     50 | 0011 0010 |  000 0000 0011 0011 0010 xxxx  | WORK RAM WRITE LOWER           |
| 0x33 |     51 | 0011 0011 |  000 0000 0011 0011 0011 xxxx  | WORK RAM WRITE UPPER           |
| 0x34 |     52 | 0011 0100 |  000 0000 0011 0011 0100 xxxx  | WORK RAM WRITE BOTH            |
| 0x7e |    126 | 0111 1110 |  000 0000 0011 0111 1110 xxxx  | MAD ROM ADDRESS                |
| 0x7f |    127 | 0111 1111 |  000 0000 0011 0111 1111 xxxx  | MAD ROM CRC32                  |

<sup>Table last updated by gen-error-codes-markdown-table on 2026-11-23 @ 02:38 UTC</sup>
<!-- ec_table_main_end -->

### Sound CPU
The sound CPU is a z80. No MAD rom exists yet for the sound CPU.

## MAD Notes
### Sprite RAM
Sprite RAM has a weird setup on this machine.  There are 3x 8bit chips that
comprise 24 bits out of every 32bits

```
 ADDR
100000 = not connected
100001 = sprite ram #1
100002 = sprite ram #2
100003 = sprite ram #3
100004 = not connected
100005 = sprite ram #1
100006 = sprite ram #2
100007 = sprite ram #3
...
```

Currently MAD is only testing the lower byte of each word of the sprite ram.  So
sprite ram #2 is not being tested.  At some point I will write one-off ram tests
to handle this.

## MAME vs Hardware
  * MAME has button 2 and 3 swapped compared to hardware
