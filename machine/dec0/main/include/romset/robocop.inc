	macro ROMSET_PALETTE_SETUP
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM + $2
		move.w	#PALETTE_TEXT_COLOR, PALETTE_EXT_RAM + $2

		move.w	#PALETTE_TEXT_SHADOW_COLOR, PALETTE_RAM + $4
		move.w	#PALETTE_TEXT_SHADOW_COLOR, PALETTE_EXT_RAM + $4

		move.w	#PALETTE_BACKGROUND_COLOR, PALETTE_RAM + $600
		move.w	#PALETTE_BACKGROUND_COLOR, PALETTE_EXT_RAM + $600

		; text corner color
		; - showing a color will make the corners square
		; - not showing a color will make them round
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM + $a
		move.w	#PALETTE_TEXT_COLOR, PALETTE_EXT_RAM + $a
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM + $c
		move.w	#PALETTE_TEXT_COLOR, PALETTE_EXT_RAM + $c
	endm

SOUND_NUM_BIT_ZERO		equ $2d	; chime
SOUND_NUM_BIT_ONE		equ $2b	; coin

; video dac test
VD_TILE_B036_NUM		equ $8a
VD_TILE_B036_PAL_OFFSET		equ $4
VD_TILE_B147_NUM		equ $1d
VD_TILE_B147_PAL_OFFSET		equ $e
VD_TILE_B25A_NUM		equ $630
VD_TILE_B25A_PAL_OFFSET		equ $1e
