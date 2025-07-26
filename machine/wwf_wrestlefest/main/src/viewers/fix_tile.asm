	include "cpu/68000/include/common.inc"

	global fix_tile_viewer

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK	equ $fff

fix_tile_viewer:
		lea	PALETTE_RAM+(PALETTE_SIZE*PALETTE_NUM), a0
		bsr	tvc_palette_setup

		moveq	#$0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	fix_seek_xy_cb, a0
		lea	fix_draw_tile_cb, a1
		bsr	tile8_viewer_handler
		rts

fix_seek_xy_cb:
		RSUB	screen_seek_xy
		rts

; params:
;  d0 = tile (word)
;  a6 = already at location in fix ram
; Tile Layout
; xxxx xxxx TTTT TTTT xxxx xxxx PPPP tttt
; where
;  P = palette number
;  T = lower 8 bits of tile number
;  t = upper 4 bits of tile number
fix_draw_tile_cb:
		move.w	d0, d1
		and.l	#$ff, d0
		swap	d0
		and.l	#$f00, d1
		lsr.l	#$8, d1
		or.l	d1, d0
		or.l	#(PALETTE_NUM << 4), d0
		move.l	d0, (a6)
		rts
