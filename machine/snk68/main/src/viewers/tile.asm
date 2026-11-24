	include "cpu/68000/include/common.inc"

	global tile_viewer
	global tile_viewer_palette_setup

	section code

PALETTE_NUM		equ $1

tile_viewer:
		bsr	tile_viewer_palette_setup

		moveq	#$0, d0
		move.w	#RS_TV_TILE_OFFSET_MASK, d1
		lea	tile_seek_xy_cb, a0
		lea	tile_draw_tile_cb, a1
		bsr	tile_8x8_viewer_handler
		rts

; Palette Layout
;  xxxx RRRR GGGG BBBB
tile_viewer_palette_setup:

		lea	TILE_PALETTE_BASE + (PALETTE_ENTRY_SIZE * PALETTE_NUM), a0
		lea	d_palette_data, a1
		moveq	#(PALETTE_ENTRY_SIZE/2 - 1), d0

	.loop_next_color:
		move.w	(a1)+, d1
		move.w	d1, (a0)+
		dbra	d0, .loop_next_color
		rts

tile_seek_xy_cb:
		RSUB	screen_seek_xy
		rts

; params:
;  d0 = tile (word)
;  a6 = already at location in tile ram
; Tile Layout
; xPPP xTTT 
; TTTT TTTT TTTT TTTT xxxx xxxx PPPP PPPP ??
; and we need to write backwards
; where
;  P = palette number
;  T = tile number
tile_draw_tile_cb:

		or.w	#PALETTE_NUM << 12, d0
		move.w	d0, (a6)
		rts

	section data
	align 1

d_palette_data:
	RS_TV_PALETTE_DATA
