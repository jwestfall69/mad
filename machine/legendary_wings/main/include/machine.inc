ROM_START			equ $0
ROM_SIZE			equ $8000

FIX_TILE_RAM			equ $e000
FIX_TILE_RAM_SIZE		equ $800
FIX_TILE_RAM_ADDRESS_LINES	equ 11

FIX_TILE			equ $e000
FIX_TILE_SIZE			equ $400
FIX_TILE_ATTR			equ $e400
FIX_TILE_ATTR_SIZE		equ $400
FIX_TILE_PALETTE		equ PALETTE_RAM + $200
FIX_TILE_PALETTE_EXT		equ PALETTE_EXT_RAM + $200
FIX_TILE_PALETTE_SIZE		equ $8

BG_TILE_RAM			equ $e800
BG_TILE_RAM_SIZE		equ $800
BG_TILE_RAM_ADDRESS_LINES	equ 11

BG_TILE				equ $e800
BG_TILE_SIZE			equ $400
BG_TILE_ATTR			equ $ec00
BG_TILE_ATTR_SIZE		equ $400
BG_TILE_PALETTE			equ PALETTE_RAM
BG_TILE_PALETTE_EXT		equ PALETTE_EXT_RAM
BG_TILE_PALETTE_SIZE		equ $20

PALETTE_RAM			equ $f000
PALETTE_RAM_SIZE		equ $400
PALETTE_RAM_ADDRESS_LINES	equ 10

PALETTE_EXT_RAM			equ $f400
PALETTE_EXT_RAM_SIZE		equ $400
PALETTE_EXT_RAM_ADDRESS_LINES	equ 10

WORK_RAM_CHIP			equ $c000
WORK_RAM_CHIP_SIZE		equ $2000
WORK_RAM_CHIP_ADDRESS_LINES	equ 13

; work and sprite share the same phsyical ram chip
WORK_RAM			equ $c000
WORK_RAM_SIZE			equ $1000

SPRITE_RAM			equ $de00
SPRITE_RAM_SIZE			equ $180	; ??
SPRITE_PALETTE			equ PALETTE_RAM + $180
SPRITE_PALETTE_EXT		equ PALETTE_EXT_RAM + $180
SPRITE_PALETTE_SIZE		equ $20

REG_CONTROL			equ $f80e
REG_SPRITE_COPY_REQUEST		equ $f80d
REG_SOUND			equ $f80c

CTRL_NMI_ENABLE			equ $08
CTRL_NMI_DISABLE		equ $00
CTRL_SND_RESET_ON		equ $20
CTRL_SND_RESET_OFF		equ $00
CTRL_SCREEN_FLIP		equ $01

REG_INPUT_P1			equ $f809
REG_INPUT_P2			equ $f80a
REG_INPUT_DSW1			equ $f80b
REG_INPUT_DSW2			equ $f80c
REG_INPUT_SYS			equ $f808

REG_BG_SCROLL_X			equ $f808
REG_BG_SCROLL_Y			equ $f80a

CHAR_COLON			equ $25


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
		ld	a, $ff
		ld	(REG_SOUND), a

		ld	de, $7ff
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
