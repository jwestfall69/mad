	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/memory_fill.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		lea	MEMORY_FILL_LIST, a0
		DSUB	memory_fill_list

		ROMSET_PALETTE_SETUP
		; background color ($ffe)

		SEEK_XY	3, 0
		lea	STR_HEADER, a0
		DSUB	print_string

		SEEK_XY	0, 1
		move.l	#'-', d0
		moveq	#32, d1
		DSUB	print_char_repeat
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
	align 2

MEMORY_FILL_LIST:
	MEMORY_FILL_ENTRY TILE_RAM_START, TILE_RAM_SIZE, $0020
	MEMORY_FILL_ENTRY SPRITE_RAM_START, SPRITE_RAM_SIZE, $0
	MEMORY_FILL_ENTRY PALETTE_RAM_START, PALETTE_RAM_SIZE, $0
	MEMORY_FILL_LIST_END

STR_HEADER:	STRING "ALPHA68K II - MAD 0.01"