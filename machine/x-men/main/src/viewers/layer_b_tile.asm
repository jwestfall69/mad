	include "cpu/68000/include/common.inc"

	global layer_b_tile_viewer

	section code

TILE_OFFSET_MASK	equ $ffff

layer_b_tile_viewer:
		; makes layer b align with fixed layer
		move.b	#$6, REG_LAYER_B_SCROLL_X_LOW
		clr.b	REG_LAYER_B_SCROLL_X_HIGH
		clr.b	REG_LAYER_B_SCROLL_Y

		lea	LAYER_B_TILE_PALETTE + $60 + (PALETTE_SIZE * TVC_PALETTE_NUM), a0
		bsr	tvc_init

		moveq	#$0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	layer_b_seek_xy_cb, a0
		lea	tvc_draw_tile_cb, a1
		bsr	tile8_viewer_handler
		rts

layer_b_seek_xy_cb:
		RSUB	screen_seek_xy

		add.l	#$2000, a6
		rts
