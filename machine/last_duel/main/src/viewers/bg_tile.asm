	include "cpu/68000/include/common.inc"

	global bg_tile_viewer
	global bg_tile_viewer_palette_setup

	section code

bg_tile_viewer:
		bsr	bg_tile_viewer_palette_setup

		move.w	#$8, REG_BG_SCROLL_Y
		move.w	#$c, REG_BG_SCROLL_X

		moveq	#0, d0
		move.w	#$7ff, d1
		lea	seek_xy_cb, a0
		lea	draw_tile_cb, a1
		bsr	tile_16x16_viewer_handler

		move.w	#$0, REG_BG_SCROLL_Y
		move.w	#$0, REG_BG_SCROLL_X

		rts

bg_tile_viewer_palette_setup:
		lea	d_palette_data, a0
		lea	BG_TILE_PALETTE , a1
		moveq	#BG_TILE_PALETTE_SIZE / 2, d0
		bsr	memory_copy
		rts

seek_xy_cb:
		lsl.l	#7, d0
		lsl.l	#1, d1
		lea	$fd4170, a6
		adda.l	d0, a6
		suba.l	d1, a6
		rts

; params:
;  d0 = tile (word)
;  a6 = already at location in bg ram
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
	dc.w	$000f, $eeef, $3bef, $37df, $358f, $345f, $300f, $602f
	dc.w	$a05f, $7dcf, $5cbf, $4baf, $398f, $276f, $054f, $030f
