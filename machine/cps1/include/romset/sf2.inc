ROMSET_LAYER_CTRL			equ $12c8
ROMSET_VIDEO_CTRL			equ $003e
ROMSET_PALETTE_CTRL			equ $003f

ROMSET_TEXT_TILE_GROUP			equ $40

	macro ROMSET_PALETTE_SETUP
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM_START + $412
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM_START + $414
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM_START + $416
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM_START + $418
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM_START + $41a
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM_START + $41c
		move.w	#PALETTE_TEXT_SHADOW_COLOR, PALETTE_RAM_START + $410
		move.w	#PALETTE_BACKGROUND_COLOR, PALETTE_RAM_START + $17fe
	endm