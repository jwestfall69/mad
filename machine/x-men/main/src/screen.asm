	include "cpu/68000/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		lea	TILE_RAM, a0
		move.l	#TILE_RAM_SIZE, d0
		move.w	#$0, d1
		DSUB	memory_fill

		lea	TILE_ATTR_RAM, a0
		move.l	#TILE_ATTR_RAM_SIZE, d0
		move.w	#$0, d1
		DSUB	memory_fill

		lea	TILE_EXT_RAM, a0
		move.l	#TILE_EXT_RAM_SIZE, d0
		move.w	#$0, d1
		DSUB	memory_fill

		lea	SPRITE_RAM, a0
		move.l	#SPRITE_RAM_SIZE, d0
		moveq	#$0, d1
		DSUB	memory_fill

		lea	PALETTE_RAM, a0
		move.l	#PALETTE_RAM_SIZE, d0
		moveq	#$0, d1
		DSUB	memory_fill

		; text color
		move.w	#$ffff, FIX_TILE_PALETTE + $10
		move.w	#$ffff, FIX_TILE_PALETTE + $12

		SEEK_XY 10, 0
		lea	d_str_version, a0
		DSUB	print_string

		SEEK_XY	0, 1
		move.l	#$6c, d0
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
		lsl.w	#1, d0
		lsl.w	#7, d1
		adda.l	d0, a6
		adda.l	d1, a6
		DSUB_RETURN
