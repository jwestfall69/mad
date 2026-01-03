	include "cpu/68000/include/common.inc"

	global scroll1_tile_viewer

	section code

scroll1_tile_viewer:

		lea	SCROLL1_PALETTE + (PALETTE_SIZE * TVC_PALETTE_NUM), a0
		bsr	tvc_init

		moveq	#0, d0
		move.w	#RS_TV_TILE_OFFSET_MASK, d1
		lea	scroll1_seek_xy_cb, a0
		lea	tvc_draw_tile_cb, a1
		bsr	tile8_viewer_handler
		rts


scroll1_seek_xy_cb:
		RSUB	screen_seek_xy
		rts
