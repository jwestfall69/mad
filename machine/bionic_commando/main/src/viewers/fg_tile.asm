	include "cpu/68000/include/common.inc"

	global fg_tile_viewer
	global fg_tile_viewer_palette_setup

	section code

fg_tile_viewer:
		bsr	fg_tile_viewer_palette_setup

		move.w	#$8, REG_FG_SCROLL_Y
		move.w	#$0, REG_FG_SCROLL_X

		moveq	#0, d0
		move.w	#$7ff, d1
		lea	seek_xy_cb, a0
		lea	draw_tile_cb, a1
		bsr	tile_16x16_viewer_handler

		move.w	#$0, REG_FG_SCROLL_Y
		move.w	#$0, REG_FG_SCROLL_X

		rts

fg_tile_viewer_palette_setup:

		CPU_INTS_ENABLE

		move.l	#d_palette_data, r_vblank_copy_src
		move.l	#FG_TILE_PALETTE, r_vblank_copy_dst
		move.w	#(FG_TILE_PALETTE_SIZE / 2), r_vblank_copy_size
		jsr	wait_vblank_copy

		CPU_INTS_DISABLE
		rts

seek_xy_cb:
		lsl.l	#$1, d0
		lsl.l	#$7, d1
		lea	$f0100, a6
		adda.l	d0, a6
		adda.l	d1, a6
		rts

; params:
;  d0 = tile (word)
;  a6 = already at location in fg ram
; Tile Layout
;  fg tile ram = xxxx xxxx TTTT TTTT
;  fg tile ram + 2 = xxxx xxxx XYLP PTTT 
;   X = flip x
;   Y = flip y
;   L = layer
;   P = palette number
;   T = tile number
draw_tile_cb:
		move.b	d0, (1, a6)
		lsr.w	#$8, d0
		move.b	d0, (3, a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$530f, $964f, $a74f, $c85f, $d96f, $ea6f, $850f, $a60f
	dc.w	$b73f, $c84f, $e95f, $fa6f, $fb7f, $988f, $766f, $000f
