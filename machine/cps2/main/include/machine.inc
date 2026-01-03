	include "cps_a.inc"
	include "cps_b.inc"
	include "romset.inc"

ROM_START			equ $0
ROM_SIZE			equ $20000

OBJECT_RAM			equ $708000
OBJECT_RAM_SIZE			equ $2000
OBJECT_RAM_ADDRESS_LINES	equ 12
OBJECT_RAM_MASK			equ $ffff
OBJECT_PALETTE			equ PALETTE_RAM

GFX_RAM				equ $900000
GFX_RAM_SIZE			equ $30000
GFX_RAM_ADDRESS_LINES		equ 17
GFX_RAM_MASK			equ $ffff

; the next 5 rams are what we are configuring
; the cps A chip with
SCROLL1_RAM			equ $90c000
SCROLL1_RAM_SIZE		equ $4000
SCROLL1_PALETTE			equ PALETTE_RAM + $400

SCROLL2_RAM			equ $904000
SCROLL2_RAM_SIZE		equ $4000
SCROLL2_PALETTE			equ PALETTE_RAM + $800

SCROLL3_RAM			equ $908000
SCROLL3_RAM_SIZE		equ $4000
SCROLL3_PALETTE			equ PALETTE_RAM + $c00

ROW_SCROLL_RAM			equ $920000
ROW_SCROLL_RAM_SIZE		equ $4000

PALETTE_RAM			equ $900000
PALETTE_RAM_SIZE		equ $4000
PALETTE_SIZE			equ $20

QSOUND_RAM			equ $618000
; Avoid conflict with sound cpu
; QSOUND_RAM_SIZE		equ $2000
QSOUND_RAM_SIZE			equ $1e80
QSOUND_RAM_ADDRESS_LINES	equ 9
QSOUND_RAM_MASK			equ $ff

WORK_RAM			equ $ff0000
; limiting size here because suicided boards
; have stuff mapped to 0xfffff0 to 0xfffffb
WORK_RAM_SIZE			equ $fff0
WORK_RAM_ADDRESS_LINES		equ 16
WORK_RAM_MASK			equ $ffff

REG_SOUND1			equ $800181
REG_SOUND2			equ $800189
REG_COIN_CTRL			equ $800030
REG_EEPROM_PORT			equ $804040
REG_OBJECT_RAM_BANK		equ $8040e1

REG_INPUT_P1			equ $804001
REG_INPUT_P2			equ $804000
REG_INPUT_P3			equ $804011
REG_INPUT_P4			equ $804010
REG_INPUT_SYSTEM1		equ $804021
REG_INPUT_SYSTEM2		equ $804020

CHAR_COLON			equ ':'

	macro SOUND_INIT
		move.b	#$88, $619ffb
		move.b	#$ff, $619ffd
		move.b	#$ff, $619fff
		SOUND_STOP
	endm

	macro SOUND_PLAY
		move.b	d0, $618003
		lsr.w	#$8, d0
		move.b	d0, $618001
		move.b	#$0, $61801f
	endm

	macro SOUND_STOP
		move.b	#$ff, $618001
		move.b	#$0, $618003
		move.b	#$0, $61801f
	endm
