	include "cpu/68000/include/common.inc"

	global fix_tile_viewer
	global fix_tile_viewer_palette_setup

	section code

fix_tile_viewer:
		bsr	fix_tile_viewer_palette_setup

		moveq	#0, d0
		move.w	#$7ff, d1
		lea	seek_xy_cb, a0
		lea	draw_tile_cb, a1
		bsr	tile_8x8_viewer_handler
		rts

fix_tile_viewer_palette_setup:
		lea	d_palette_data, a0
		lea	FIX_TILE_PALETTE + FIX_TILE_PALETTE_SIZE, a1
		moveq	#FIX_TILE_PALETTE_SIZE / 2, d0
		bsr	memory_copy
		rts

seek_xy_cb:
		RSUB	screen_seek_xy
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
		or.w	#$1 << 12, d0		; palette num
		move.w	d0, (a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$a00f, $fb0f, $e80f, $000f
