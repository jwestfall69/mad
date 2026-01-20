ROM_START			equ $0
ROM_SIZE			equ $8000

TILE_RAM			equ $d000
TILE_RAM_SIZE			equ $800
TILE_RAM_ADDRESS_LINES		equ 11

FIX_TILE			equ $d000
FIX_TILE_SIZE			equ $400

FIX_TILE_ATTR			equ $d400
FIX_TILE_ATTR_SIZE		equ $400

WORK_RAM_CHIP			equ $e000
WORK_RAM_CHIP_SIZE		equ $2000
WORK_RAM_CHIP_ADDRESS_LINES	equ 13

; work and sprite share the same phsyical ram chip
WORK_RAM			equ $e000
WORK_RAM_SIZE			equ $1000

SPRITE_RAM			equ $f000
SPRITE_RAM_SIZE			equ $1000

REG_SPRITE_COPY_REQUEST		equ $c806
REG_SOUND			equ $c800

REG_INPUT_P1			equ $c001
REG_INPUT_P2			equ $c002
REG_INPUT_DSW1			equ $c003
REG_INPUT_DSW2			equ $c004
REG_INPUT_SYS			equ $c000

REG_LAYER			equ $d806
LAYER_BG1_ENABLE		equ $10
LAYER_BG2_ENABLE		equ $20
LAYER_SPRITE_ENABLE		equ $40

REG_BG1_SCROLL_X		equ $d800
REG_BG1_SCROLL_Y		equ $d802

REG_BG2_SCROLL_X		equ $d803

CHAR_COLON			equ $2c


	macro WATCHDOG
;		ld	($c806), a
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
