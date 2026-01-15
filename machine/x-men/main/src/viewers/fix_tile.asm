	include "cpu/68000/include/common.inc"

	global fix_tile_viewer

	section code

TILE_OFFSET_MASK	equ $ffff

fix_tile_viewer:
		lea	FIX_TILE_PALETTE + (PALETTE_SIZE * TVC_PALETTE_NUM), a0
		bsr	tvc_init

		moveq	#$0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	fix_seek_xy_cb, a0
		lea	tvc_draw_tile_cb, a1
		bsr	tile_8x8_viewer_handler
		rts

fix_seek_xy_cb:
		RSUB	screen_seek_xy
		rts
