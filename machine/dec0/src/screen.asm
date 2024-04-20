	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/memory_fill.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global screen_clear_dsub
	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_clear_dsub:

		lea	TILE1_DATA_START, a0
		move.w	#(TILE1_DATA_SIZE / 2), d0
		moveq	#0, d1
		DSUB	memory_fill

		SEEK_XY   0, 1
		move.l	#'-', d0
		moveq	#32, d1
		DSUB	print_char_repeat

		SEEK_XY	6, 0
		lea	STR_HEADER, a0
		DSUB	print_string
		DSUB_RETURN

screen_init_dsub:
		lea	REG_TILE1_CTRL1, a0
		move.w	#$3, (a0)+
		move.w	#$3, (a0)+
		move.w	#$0, (a0)+
		move.w	#$1, (a0)+

		lea	MEMORY_FILL_LIST, a0
		DSUB	memory_fill_list

		; poison palette by making everything green
		lea	PALETTE_RAM_START, a0
		move.w	#(PALETTE_RAM_SIZE / 2), d0
		move.w	#$ff00, d1
		DSUB	memory_fill

		lea	PALETTE_EXT_RAM_START, a0
		move.w	#PALETTE_EXT_RAM_SIZE / 2, d0
		moveq	#0, d1
		DSUB	memory_fill

		; text color
		move.w	#$ffff, PALETTE_RAM_START + ROMSET_PAL_TEXT_OFFSET
		move.w	#$ff, PALETTE_EXT_RAM_START + ROMSET_PAL_TEXT_OFFSET

		; text shadow color
		move.w	#$0, PALETTE_RAM_START + ROMSET_PAL_TEXT_SHADOW_OFFSET
		move.w	#$0, PALETTE_EXT_RAM_START + ROMSET_PAL_TEXT_SHADOW_OFFSET

	ifd _ROMSET_ROBOCOP_
		; text corner color
		; - showing a color will make the corners square
		; - not showing a color will make them round
		move.w	#$ffff, PALETTE_RAM_START + ROMSET_PAL_TEXT_CORNER1_OFFSET
		move.w	#$ff, PALETTE_EXT_RAM_START + ROMSET_PAL_TEXT_CORNER1_OFFSET
		move.w	#$ffff, PALETTE_RAM_START + ROMSET_PAL_TEXT_CORNER2_OFFSET
		move.w	#$ff, PALETTE_EXT_RAM_START + ROMSET_PAL_TEXT_CORNER2_OFFSET
	endif

		; background color
		move.w	#$0, PALETTE_RAM_START + ROMSET_PAL_BACKGROUND_OFFSET
		move.w	#$0, PALETTE_EXT_RAM_START + ROMSET_PAL_BACKGROUND_OFFSET

		bra	screen_clear_dsub

screen_seek_xy_dsub:
		SEEK_XY	0, 0

	ifd _PRINT_COLUMN_
		lsl.w	#6, d0
		lsl.w	#1, d1
		add.l	d0, a6
		sub.l	d1, a6
	else
		lsl.w	#1, d0
		lsl.w	#6, d1
		add.l	d0, a6
		add.l	d1, a6
	endif
		DSUB_RETURN

	section data

MEMORY_FILL_LIST:
		MEMORY_FILL_ENTRY REG_TILE1_CTRL2, $4, $0
		MEMORY_FILL_ENTRY REG_TILE2_CTRL1, $4, $0
		MEMORY_FILL_ENTRY REG_TILE2_CTRL2, $4, $0
		MEMORY_FILL_ENTRY REG_TILE3_CTRL1, $4, $0
		MEMORY_FILL_ENTRY REG_TILE3_CTRL2, $4, $0
		MEMORY_FILL_ENTRY TILE1_DATA_START, (TILE1_DATA_SIZE / 2), $0
		MEMORY_FILL_ENTRY TILE2_DATA_START, (TILE2_DATA_SIZE / 2), $0
		MEMORY_FILL_ENTRY TILE3_DATA_START, (TILE3_DATA_SIZE / 2), $0
		MEMORY_FILL_ENTRY SPRITE_RAM_START, (SPRITE_RAM_SIZE / 2), $0
		MEMORY_FILL_LIST_END

STR_HEADER:	STRING "DEC0 DIAG 0.01 - ACK"
