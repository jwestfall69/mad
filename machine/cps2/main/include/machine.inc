	include "cps_a.inc"
	include "cps_b.inc"
	include "romset.inc"

ROM_START			equ $0
ROM_SIZE			equ $20000

OBJECT_RAM_START		equ $708000
OBJECT_RAM_SIZE			equ $2000
OBJECT_RAM_ADDRESS_LINES	equ 12
OBJECT_RAM_MASK			equ $ffff

; the next 4 rams are what we are configuring
; the cps A chip with
SCROLL1_RAM_START		equ $90c000
SCROLL1_RAM_SIZE		equ $4000

SCROLL2_RAM_START		equ $904000
SCROLL2_RAM_SIZE		equ $4000

SCROLL3_RAM_START		equ $908000
SCROLL3_RAM_SIZE		equ $4000

ROW_SCROLL_RAM_START		equ $920000
ROW_SCROLL_RAM_SIZE		equ $4000

PALETTE_RAM_START		equ $900000
PALETTE_RAM_SIZE		equ $4000
PALETTE_SIZE			equ $20

GFX_RAM_START			equ $900000
GFX_RAM_SIZE			equ $30000
GFX_RAM_ADDRESS_LINES		equ 17
GFX_RAM_MASK			equ $ffff

WORK_RAM_START			equ $ff0000
WORK_RAM_SIZE			equ $fff0
WORK_RAM_ADDRESS_LINES		equ 16
WORK_RAM_MASK			equ $ffff

REG_SOUND1			equ $800181
REG_SOUND2			equ $800189
REG_COIN_CTRL			equ $800030

REG_INPUT_P1			equ $804001
REG_INPUT_P2			equ $804000
REG_INPUT_P3			equ $804011
REG_INPUT_P4			equ $804010
REG_INPUT_SYSTEM1		equ $804021
REG_INPUT_SYSTEM2		equ $804020

CHAR_COLON			equ ':'

;SOUND_NUM_STOP			equ $xx

SCREEN_TILES_PER_LINE		equ 32
SCREEN_BYTES_PER_TILE		equ 4
SCREEN_BYTES_PER_LINE		equ (SCREEN_BYTES_PER_TILE * SCREEN_TILES_PER_LINE)

	ifd _SCREEN_TATE_
		macro SEEK_XY
			lea	(SCROLL1_RAM_START + $1788 - ((\2 * SCREEN_BYTES_PER_LINE)) + (\1 * SCREEN_BYTES_PER_TILE)), a6
		endm

		macro SEEK_LN
			lea	(SCROLL1_RAM_START + $1788 - (\1 * SCREEN_BYTES_PER_LINE)), a6
		endm
	else
		macro SEEK_XY
			lea	(SCROLL1_RAM_START + $8 + (\1 * SCREEN_BYTES_PER_LINE)) + (\2 * SCREEN_BYTES_PER_TILE), a6
		endm

		macro SEEK_LN
			lea	(SCROLL1_RAM_START + $8 + (\1 * SCREEN_BYTES_PER_TILE)), a6
		endm
	endif

	macro SOUND_PLAY
	endm

	macro SOUND_STOP
	endm

	; This comes from razoola's suicided tester /
	; phoenix roms.
	macro SUICIDE_INIT
		move.w	#$0, $8040a0
		move.w	#$7000, $fffff0
		move.w	#$807d, $fffff2
		move.w	#$0, $fffff4
		move.w	#$0, $fffff6
		move.w	#$0, $fffff8
		move.w	#$0, $fffffa
	endm
