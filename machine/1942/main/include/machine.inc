ROM_START			equ $0
ROM_SIZE			equ $8000

BG_TILE_RAM			equ $d800
BG_TILE_RAM_SIZE		equ $400
BG_TILE_RAM_ADDRESS_LINES	equ 10

BG_TILE				equ $d800
BG_TILE_SIZE			equ $400

FIX_TILE_RAM			equ $d000
FIX_TILE_RAM_SIZE		equ $800
FIX_TILE_RAM_ADDRESS_LINES	equ 11

FIX_TILE			equ $d000
FIX_TILE_SIZE			equ $400

FIX_TILE_ATTR			equ $d400
FIX_TILE_ATTR_SIZE		equ $400

; work ram is 2x $800 chips, we are only
; using the lower $800
WORK_RAM_CHIP			equ $e000
WORK_RAM_CHIP_SIZE		equ $800
WORK_RAM_CHIP_ADDRESS_LINES	equ 11

WORK_HIGH_RAM			equ $e800
WORK_HIGH_RAM_SIZE		equ $800
WORK_HIGH_RAM_ADDRESS_LINES	equ 11

WORK_RAM			equ $e000
WORK_RAM_SIZE			equ $800

SPRITE_RAM			equ $cc00
SPRITE_RAM_SIZE			equ $80

REG_BG_SCROLL_X			equ $c802
REG_CONTROL			equ $c804
REG_PALETTE_BANK		equ $c805
REG_ROM_BANK			equ $c806
REG_SOUND			equ $c800

REG_INPUT_P1			equ $c001
REG_INPUT_P2			equ $c002
REG_INPUT_DSW1			equ $c003
REG_INPUT_DSW2			equ $c004
REG_INPUT_SYS			equ $c000

CHAR_COLON			equ ':'


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
