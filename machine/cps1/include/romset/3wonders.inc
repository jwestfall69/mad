ROMSET_LAYER_CTRL		equ $12e2
ROMSET_VIDEO_CTRL		equ $003e
ROMSET_PALETTE_CTRL		equ $003e

ROMSET_TEXT_TILE_GROUP		equ $68

CURSOR_CHAR			equ '*'
CURSOR_CLEAR_CHAR		equ ' '

	macro ROMSET_PALETTE_SETUP
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM_START + $0
		move.w	#PALETTE_TEXT_SHADOW_COLOR, PALETTE_RAM_START + $a
		move.w	#PALETTE_BACKGROUND_COLOR, PALETTE_RAM_START + $13fe
	endm

SOUND_NUM_BIT_ZERO		equ $03	; gun fire?
SOUND_NUM_BIT_ONE		equ $11	; water drop?

; These are tiles which are filled with a single
; color from the palette that we will use for the
; solid color blocks
TILE_B0_NUM			equ $6810
TILE_B0_PAL_OFFSET		equ $0
TILE_B1_NUM			equ $6811
TILE_B1_PAL_OFFSET		equ $2
TILE_B2_NUM			equ $6812
TILE_B2_PAL_OFFSET		equ $4
TILE_B3_NUM			equ $6813
TILE_B3_PAL_OFFSET		equ $6
TILE_BA_NUM			equ $6814
TILE_BA_PAL_OFFSET		equ $8
