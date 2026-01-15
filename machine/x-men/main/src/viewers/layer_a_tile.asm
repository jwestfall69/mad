	include "cpu/68000/include/common.inc"

	global layer_a_tile_viewer

	section code

TILE_OFFSET_MASK	equ $ffff

layer_a_tile_viewer:
		; makes layer a align with fixed layer
		move.b	#$6, REG_LAYER_A_SCROLL_X_LOW
		clr.b	REG_LAYER_A_SCROLL_X_HIGH
		clr.b	REG_LAYER_A_SCROLL_Y

		lea	LAYER_A_TILE_PALETTE + $60 + (PALETTE_SIZE * TVC_PALETTE_NUM), a0
		bsr	tvc_init

		moveq	#$0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	layer_a_seek_xy_cb, a0
		lea	tvc_draw_tile_cb, a1
		bsr	tile_8x8_viewer_handler
		rts

layer_a_seek_xy_cb:
		RSUB	screen_seek_xy

		add.l	#$1000, a6
		rts
