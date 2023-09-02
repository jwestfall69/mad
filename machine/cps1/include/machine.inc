	include "cps_a.inc"
	include "cps_b.inc"
	include "romset.inc"

ROM_START			equ $0
ROM_SIZE			equ $20000

; using the values from sf2
OBJECT_RAM_START		equ $910000
OBJECT_RAM_SIZE			equ $800

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

	macro SEEK_XY
		lea	(SCROLL1_RAM_START + $8 + (\1 * $80)) + (\2 * 4), a6
	endm

	macro SEEK_LN
		lea	(SCROLL1_RAM_START + $8 + (\1 * 4)), a6
	endm

REG_P1_INPUT			equ $800000
