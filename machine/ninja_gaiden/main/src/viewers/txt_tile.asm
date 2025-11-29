	include "cpu/68000/include/common.inc"

	global txt_tile_viewer
	global txt_tile_viewer_palette_setup

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK	equ $7ff

txt_tile_viewer:
		bsr	txt_tile_viewer_palette_setup

		moveq	#$0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	txt_seek_xy_cb, a0
		lea	txt_draw_tile_cb, a1
		bsr	tile8_viewer_handler
		rts

; Palette Layout
;  xxxx BBBB GGGG RRRR
txt_tile_viewer_palette_setup:

		lea	TXT_PALETTE + (PALETTE_SIZE * PALETTE_NUM), a0
		lea	d_palette_data, a1
		moveq	#(PALETTE_SIZE/2 - 1), d0

	.loop_next_color:
		move.w	(a1)+, d1
		move.w	d1, (a0)+
		dbra	d0, .loop_next_color
		rts

txt_seek_xy_cb:
		RSUB	screen_seek_xy
		rts

; Palette Number Layout
;  xxxx xxxx PPPP xxxx
; Tile Layout
;  xxxx xTTT TTTT TTTT
; where
;  T = tile number
;  P = palette number
; The tile and the palette number it uses are stored in
; different memory locations.  Where
;  palette address + $800 = tile address
txt_draw_tile_cb:
		move.w	d0, (a6)
		lea	(-$800, a6), a6
		move.w	#(PALETTE_NUM << 4), (a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0000, $0fff, $0040, $0633, $08ff, $0a77, $0c99, $0ebb
	dc.w	$0008, $000b, $007f, $0358, $098d, $057a, $0bdf, $079c
