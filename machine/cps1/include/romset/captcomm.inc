;ROMSET_LAYER_CTRL			equ $12c2
ROMSET_LAYER_CTRL			equ $12e0
ROMSET_VIDEO_CTRL			equ $003e
ROMSET_PALETTE_CTRL			equ $003f

ROMSET_TEXT_TILE_GROUP			equ $c0


	macro ROMSET_PALETTE_SETUP
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM_START + $400
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM_START + $402
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM_START + $404
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM_START + $406
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM_START + $408
		move.w	#PALETTE_TEXT_SHADOW_COLOR, PALETTE_RAM_START + $40a
		move.w	#PALETTE_BACKGROUND_COLOR, PALETTE_RAM_START + $17fe
	endm

	macro ROMSET_PALETTE_SETUP_RED
		move.w	#$ff00, PALETTE_RAM_START + $400
		move.w	#$ff00, PALETTE_RAM_START + $402
		move.w	#$ff00, PALETTE_RAM_START + $404
		move.w	#$ff00, PALETTE_RAM_START + $406
		move.w	#$ff00, PALETTE_RAM_START + $408
		move.w	#$2200, PALETTE_RAM_START + $40a
		move.w	#PALETTE_BACKGROUND_COLOR, PALETTE_RAM_START + $17fe
	endm