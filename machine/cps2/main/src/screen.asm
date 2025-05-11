	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/memory_fill.inc"

	include "machine.inc"
	include "mad.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub
	global screen_update_palette_dsub

	section code

screen_init_dsub:

		lea	d_memory_fill_list, a0
		DSUB	memory_fill_list

		move.w	#SCROLL1_RAM / 256, REGA_SCROLL1_RAM_BASE
		move.w	#SCROLL2_RAM / 256, REGA_SCROLL2_RAM_BASE
		move.w	#SCROLL3_RAM / 256, REGA_SCROLL3_RAM_BASE
		move.w	#ROW_SCROLL_RAM / 256, REGA_ROW_SCROLL_RAM_BASE
		move.w	#ROMSET_LAYER_CTRL, REGB_LAYER_CTRL
		move.w	#ROMSET_PALETTE_CTRL, REGB_PALETTE_CTRL
		move.w	#ROMSET_VIDEO_CTRL, REGA_VIDEO_CONTROL

		ROMSET_PALLETE_SETUP

		SEEK_XY	13, 0
		lea	d_str_version, a0
		DSUB	print_string

		SEEK_LN	1
		move.l	#'-', d0
		moveq	#48, d1
		DSUB	print_char_repeat

; this function doesn't appear to be safe to run on
; hardware when interrupts are enabled.  Presumably
; the vblank interrupt is firing while the scanline is
; 262.
screen_update_palette_dsub:
		move.w	REGB_SCANLINE, D0
		cmp.w	#262, D0
		bne	screen_update_palette_dsub
		move.w	#PALETTE_RAM / 256, REGA_PALETTE_RAM_BASE
		DSUB_RETURN

; in cases where we need to goto x, y location at runtime
; params:
;  d0 = x
;  d1 = y
screen_seek_xy_dsub:
		SEEK_XY	0, 0
		and.l	#$ff, d0
		and.l	#$ff, d1
		lsl.l	#7, d0
		lsl.l	#2, d1
		adda.l	d0, a6
		adda.l	d1, a6
		DSUB_RETURN

	section data
	align 1

d_memory_fill_list
	; this first one being $20 is a bit of a hack for now, its
	; because mercs uses tile_group $0 so filling with $0 results
	; in the screen being filled with "0" tiles.
	MEMORY_FILL_ENTRY SCROLL1_RAM, SCROLL1_RAM_SIZE, $20
	MEMORY_FILL_ENTRY SCROLL2_RAM, SCROLL2_RAM_SIZE, $0
	MEMORY_FILL_ENTRY SCROLL3_RAM, SCROLL3_RAM_SIZE, $0
	MEMORY_FILL_ENTRY OBJECT_RAM, OBJECT_RAM_SIZE, $0
	MEMORY_FILL_ENTRY ROW_SCROLL_RAM, ROW_SCROLL_RAM_SIZE, $0
	MEMORY_FILL_ENTRY PALETTE_RAM, PALETTE_RAM_SIZE, $0
	MEMORY_FILL_LIST_END
