	include "cpu/68000/include/common.inc"

	global fix_tile_viewer

	section code

TILE_OFFSET_MASK	equ $1ff

fix_tile_viewer:
		lea	FIX_TILE_PALETTE + $100, a0
		bsr	tvc_init

		moveq	#$0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	fix_seek_xy_cb, a0
		lea	fix_draw_tile_cb, a1
		bsr	tile_8x8_viewer_handler
		rts

fix_seek_xy_cb:
		RSUB	screen_seek_xy
		rts

; params:
;  d0.w = tile
;  0BBB BTTT TTTT TTTT
;  B = bank num
;  T = tile num
;  a6 = already at location in tile ram
;  P??P ?X?T TTTT TTTT
;  P = palette num
;  T = tile num
;  X = flip x?
fix_draw_tile_cb:
		or.w	#$1 << 15, d0
		move.w	d0, d1
		lsr.w	#$8, d1
		move.b	d1, (a6)+
		move.b	d0, (a6)
		rts

