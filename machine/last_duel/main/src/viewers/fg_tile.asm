	include "cpu/68000/include/common.inc"

	global fg_tile_viewer
	global fg_tile_viewer_palette_setup

	section code

fg_tile_viewer:
		bsr	fg_tile_viewer_palette_setup

		move.w	#$8, REG_FG_SCROLL_Y
		move.w	#$c, REG_FG_SCROLL_X

		moveq	#0, d0
		move.w	#$fff, d1
		lea	seek_xy_cb, a0
		lea	draw_tile_cb, a1
		bsr	tile_16x16_viewer_handler

		move.w	#$0, REG_FG_SCROLL_Y
		move.w	#$0, REG_FG_SCROLL_X

		rts

fg_tile_viewer_palette_setup:
		lea	d_palette_data, a0
		lea	FG_TILE_PALETTE , a1
		moveq	#FG_TILE_PALETTE_SIZE / 2, d0
		bsr	memory_copy
		rts

seek_xy_cb:
		lsl.l	#7, d0
		lsl.l	#1, d1
		lea	$fd0170, a6
		adda.l	d0, a6
		suba.l	d1, a6
		rts

; params:
;  d0 = tile (word)
;  a6 = already at location in fg ram
; Tile Layout
; PPPP XTTT TTTT TTTT
;   X = flip x
;   P = palette number
;   T = tile number
draw_tile_cb:
		move.w	d0, (a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$000f, $a00f, $e608, $030f, $042f, $063f, $084f, $0c6f
	dc.w	$0f8f, $dfff, $cdff, $8aef, $67df, $45bf, $237f, $111f
