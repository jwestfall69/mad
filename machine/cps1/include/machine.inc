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

GFX_RAM_START			equ $900000
GFX_RAM_SIZE			equ $30000
GFX_RAM_ADDRESS_LINES		equ 17
GFX_RAM_MASK			equ $ffff

WORK_RAM_START			equ $ff0000
WORK_RAM_SIZE			equ $10000
WORK_RAM_ADDRESS_LINES		equ 16
WORK_RAM_MASK			equ $ffff

REG_SOUND1			equ $800181
REG_SOUND2			equ $800189
REG_COIN_CTRL			equ $800030

REG_INPUT_DSW1			equ $80001a
REG_INPUT_DSW2			equ $80001c
REG_INPUT_DSW3			equ $80001e
REG_INPUT_P1			equ $800001
REG_INPUT_P2			equ $800000
REG_INPUT_IN2			equ $800177
REG_INPUT_IN3			equ $800179
REG_INPUT_SYSTEM		equ $800018

P1_RIGHT_BIT			equ $0
P1_LEFT_BIT			equ $1
P1_DOWN_BIT			equ $2
P1_UP_BIT			equ $3
P1_B1_BIT			equ $4
P1_B2_BIT			equ $5
P1_B3_BIT			equ $6

P1_RIGHT			equ $01
P1_LEFT				equ $02
P1_DOWN				equ $04
P1_UP				equ $08
P1_B1				equ $10
P1_B2				equ $20
P1_B3				equ $40

SYS_START1			equ $10

CHAR_COLON			equ ':'

SOUND_NUM_STOP			equ $f0

	macro SEEK_XY
		lea	(SCROLL1_RAM_START + $8 + (\1 * $80)) + (\2 * 4), a6
	endm

	macro SEEK_LN
		lea	(SCROLL1_RAM_START + $8 + (\1 * 4)), a6
	endm

	macro SOUND_PLAY
		DSUB	sound_play
	endm

	macro SOUND_STOP
		move.b	#SOUND_NUM_STOP, REG_SOUND1
	endm
