ROM_START			equ $0
ROM_SIZE			equ $8000

; palette ram is write-only
PALETTE_RAM			equ $c000
PALETTE_RAM_SIZE		equ $800
PALETTE_RAM_ADDRESS_LINES	equ 11
PALETTE_EXT_RAM			equ PALETTE_RAM + $400
PALETTE_SIZE			equ $20

TILE_RAM			equ $d000
TILE_RAM_SIZE			equ $1000
TILE_RAM_ADDRESS_LINES		equ 12

FIX_TILE			equ $d000
FIX_TILE_SIZE			equ $800
FIX_TILE_PALETTE		equ PALETTE_RAM + $300
FIX_TILE_PALETTE_EXT		equ PALETTE_EXT_RAM + $300
FIX_TILE_PALETTE_SIZE		equ $8

FIX_TILE_ATTR			equ $d800
FIX_TILE_ATTR_SIZE		equ $800

BG_TILE_PALETTE			equ PALETTE_RAM
BG_TILE_PALETTE_EXT		equ PALETTE_EXT_RAM

WORK_RAM_CHIP			equ $e000
WORK_RAM_CHIP_SIZE		equ $2000
WORK_RAM_CHIP_ADDRESS_LINES	equ 13

; work and sprite share the same phsyical ram chip
WORK_RAM			equ $e000
WORK_RAM_SIZE			equ $1000

SPRITE_RAM			equ $f000
SPRITE_RAM_SIZE			equ $1000
SPRITE_PALETTE			equ PALETTE_RAM + $200
SPRITE_PALETTE_EXT		equ PALETTE_EXT_RAM + $200

STARFIELD_PALETTE		equ $c37c
STARFIELD_PALETTE_SIZE		equ $8

REG_SPRITE_COPY_REQUEST		equ $c802
REG_PAL_WRITE_ERROR_CLEAR	equ $c803
REG_STARFIELD_SCROLL_X		equ $c805
REG_STARFIELD_SCROLL_Y		equ $c806

REG_SOUND			equ $c800

REG_INPUT_P1			equ $c801
REG_INPUT_P2			equ $c802
REG_INPUT_DSW1			equ $c803
REG_INPUT_DSW2			equ $c804
REG_INPUT_DSW3			equ $c805
REG_INPUT_SYS			equ $c800

SYS_PAL_WRITE_ERROR_BIT		equ $2
SYS_VBLANK_BIT			equ $3

REG_LAYER			equ $c80c
LAYER_BG_ENABLE			equ $01
LAYER_SPRITE_ENABLE		equ $02

REG_BG_SCROLL_X			equ $c808
REG_BG_SCROLL_Y			equ $c80a

REG_STAR_SCROLL_X		equ $c805
REG_STAR_SCROLL_Y		equ $c806

CHAR_COLON			equ $2c


	macro WATCHDOG
	endm

	; Sound commands are sent through a latch, but the main CPU
	; has no way to tell the sound CPU to read the latch.  Insead
	; the sound CPU is constantly reading the latch.  If it sees
	; the same value as the previous read it will just ignore it.
	; This is problematic for beep codes, so to work around this
	; we need to send it a stop playing command, wait a bit, then
	; send our actual sound command.
	macro SOUND_PLAY
		ld	b, a
		ld	a, 0
		ld	(REG_SOUND), a

		ld	de, $8ff
	.\@:
		cp	$0
		cp	$0
		cp	$0
		dec	de
		ld	a, e
		or	d
		jr	nz, .\@

		ld	a, b
		ld	(REG_SOUND), a

	endm

	macro SOUND_STOP
		ld	a, $0
		ld	(REG_SOUND), a
	endm
