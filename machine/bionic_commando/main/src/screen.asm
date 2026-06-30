	include "cpu/68000/include/common.inc"

	global palette_init_irq
	global palette_init_no_irq_dsub
	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:

		lea	d_memory_fill_list, a0
		DSUB	memory_fill_list

		;move.w	#$0, $e8018

		;move.l	#$1ff, d0
		;DSUB	delay

		SEEK_XY	4, 0
		lea	d_str_version, a0
		DSUB	print_string

		SEEK_XY	0, 1
		move.l	#$3d, d0
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
		lsl.l	#1, d0
		lsl.l	#6, d1
		adda.l	d0, a6
		adda.l	d1, a6
		DSUB_RETURN


palette_init_no_irq_dsub:
		lea	PALETTE_RAM, a0
		move.l	#PALETTE_RAM_SIZE, d0
		moveq	#$0, d1
		DSUB	memory_fill

		move.w	#$ffff, FIX_TILE_PALETTE + 2
		DSUB_RETURN

palette_init_irq:
		CPU_INTS_ENABLE

		move.l	#PALETTE_RAM, r_vblank_fill_addr
		move.w	#(PALETTE_RAM_SIZE / 2), r_vblank_fill_size
		move.w	#$0, r_vblank_fill_data
		jsr	wait_vblank_fill

		move.l	#d_palette_data, r_vblank_copy_src
		move.l	#FIX_TILE_PALETTE + 2, r_vblank_copy_dst
		move.w	#$1, r_vblank_copy_size
		jsr	wait_vblank_copy

		CPU_INTS_DISABLE
		rts

	section data
	align 1

d_memory_fill_list
	MEMORY_FILL_ENTRY FIX_TILE, FIX_TILE_SIZE, $20
	MEMORY_FILL_ENTRY FIX_TILE_ATTR, FIX_TILE_ATTR_SIZE, $0
	MEMORY_FILL_ENTRY BG_TILE_RAM, BG_TILE_RAM_SIZE, $0
	MEMORY_FILL_ENTRY FG_TILE_RAM, FG_TILE_RAM_SIZE, $0
	MEMORY_FILL_ENTRY SPRITE_RAM, SPRITE_RAM_SIZE, $0
	MEMORY_FILL_LIST_END

d_palette_data:
	dc.w	$ffff
