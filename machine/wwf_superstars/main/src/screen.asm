	include "cpu/68000/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		lea	d_memory_fill_list, a0
		DSUB	memory_fill_list

		; text color
		lea	FG_PALETTE + $18, a0
		move.w	#$0fff, (a0)

		; text shadow
		lea	FG_PALETTE + $2, a0
		move.w	#$0111, (a0)

		; background color ($200)

		SEEK_XY	3, 0
		lea	d_str_version, a0
		DSUB	print_string

		SEEK_XY	0, 1
		move.l	#'-', d0
		moveq	#SCREEN_NUM_COLUMNS, d1
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
		adda.l	d0, a6
		adda.l	d1, a6
		DSUB_RETURN

	section data
	align 1

d_memory_fill_list:
	MEMORY_FILL_ENTRY FG_RAM, FG_RAM_SIZE, $0
	MEMORY_FILL_ENTRY BG_RAM, BG_RAM_SIZE, $0
	MEMORY_FILL_ENTRY SPRITE_RAM, SPRITE_RAM_SIZE, $0
	MEMORY_FILL_ENTRY PALETTE_RAM, PALETTE_RAM_SIZE, $0
	MEMORY_FILL_LIST_END
