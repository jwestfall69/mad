ROMSET_LAYER_CTRL		equ $12e2
ROMSET_VIDEO_CTRL		equ $003e
ROMSET_PALETTE_CTRL		equ $003e

CURSOR_CHAR			equ '*'
CURSOR_CLEAR_CHAR		equ ' '

SOUND_NUM_BIT_ZERO		equ $f4
SOUND_NUM_BIT_ONE		equ $ef
SOUND_NUM_SUCCESS		equ $25

; video dac
VD_TILE_B0_NUM			equ $10
VD_TILE_B0_PAL_OFFSET		equ $0
VD_TILE_B1_NUM			equ $11
VD_TILE_B1_PAL_OFFSET		equ $2
VD_TILE_B2_NUM			equ $12
VD_TILE_B2_PAL_OFFSET		equ $4
VD_TILE_B3_NUM			equ $13
VD_TILE_B3_PAL_OFFSET		equ $6
VD_TILE_BA_NUM			equ $14
VD_TILE_BA_PAL_OFFSET		equ $8

	macro ROMSET_INIT
		move.w	#$0, $8040a0
		move.w	#$7000, $400000
		move.w	#$807d, $400002
		move.w	#$0, $400004
		move.w	#$0, $400006
		move.w	#$0, $400008
		move.w	#$0, $40000a
	endm

	macro ROMSET_PALLETE_SETUP
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM + $2
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM + $4
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM + $6
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM + $8
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM + $a
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM + $c
		move.w	#PALETTE_TEXT_SHADOW_COLOR, PALETTE_RAM + $10
		move.w	#PALETTE_BACKGROUND_COLOR, PALETTE_RAM + $13fe
	endm

	macro WATCHDOG
		cmpi.w	#$1019, $4000
	endm

