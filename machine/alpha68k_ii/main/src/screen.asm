	include "cpu/68000/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		lea	d_memory_fill_list, a0
		DSUB	memory_fill_list

		ROMSET_PALETTE_SETUP
		; background color ($ffe)

		SEEK_XY	0, 0
		lea	d_str_version, a0
		DSUB	print_string

		SEEK_XY	0, 1
		move.l	#'-', d0
		moveq	#SCREEN_NUM_COLUMNS, d1
		DSUB	print_char_repeat

		SEEK_XY	((SCREEN_NUM_COLUMNS - _ROMSET_STR_LENGTH_) - 1), 1
		lea	d_str_romset, a0
		DSUB	print_string
		DSUB_RETURN


; in cases where we need to goto x, y location at runtime
; params:
;  d0 = x
;  d1 = y
screen_seek_xy_dsub:
		SEEK_XY	0, 0
		and.l	#$ff, d0
		and.l	#$ff, d1

		lsl.w	#2, d0
		lsl.w	#7, d1
		suba.l	d0, a6
		adda.l	d1, a6
		DSUB_RETURN

	section data
	align 1

d_memory_fill_list:
	MEMORY_FILL_ENTRY TILE_RAM, TILE_RAM_SIZE, $0020
	MEMORY_FILL_ENTRY SPRITE_RAM, SPRITE_RAM_SIZE, $0
	MEMORY_FILL_ENTRY PALETTE_RAM, PALETTE_RAM_SIZE, $0
	MEMORY_FILL_LIST_END
