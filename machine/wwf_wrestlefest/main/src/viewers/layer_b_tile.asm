	include "cpu/68000/include/common.inc"

	global layer_b_tile_viewer

	section code

TILE_OFFSET_MASK	equ $fff

layer_b_tile_viewer:
		lea	LAYER_B_TILE_PALETTE, a0
		bsr	tvc_palette_setup

		move.w	#$1fc, REG_LAYER_B_SCROLL_X
		move.w	#$1fc, REG_LAYER_B_SCROLL_Y

		moveq	#$0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	layer_b_tile_seek_xy_cb, a0
		lea	layer_b_tile_draw_tile_cb, a1
		bsr	tile16_viewer_handler

		move.w	#$0, REG_LAYER_B_SCROLL_X
		move.w	#$0, REG_LAYER_B_SCROLL_Y
		rts

; params:
;  d0 = x
;  d1 = y
layer_b_tile_seek_xy_cb:
		lea	LAYER_B_TILE, a6
		and.l	#$ff, d0
		and.l	#$ff, d1

		;lsl.w	#1, d0
		;lsr.w	#1, d1
		mulu.w	#$20, d1
		adda.l	d0, a6
		adda.l	d1, a6
		rts

layer_b_tile_draw_tile_cb:
		move.w	d0, (a6)
		rts
