	include "cpu/68000/include/common.inc"

	global fg_tile_viewer

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK	equ $fff

fg_tile_viewer:
		RSUB	screen_init
		bsr	fg_palette_setup

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		lea	d_str_title, a0
		RSUB	print_string

		moveq	#$0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	fg_seek_xy_cb, a0
		lea	fg_draw_tile_cb, a1
		bsr	tile_8x8_viewer_handler
		rts

; Palette Layout
;  xxxx BBBB GGGG RRRR
fg_palette_setup:

		lea	PALETTE_RAM+(PALETTE_SIZE*PALETTE_NUM), a0
		lea	d_palette_data, a1
		moveq	#(PALETTE_SIZE/2 - 1), d0

	.loop_next_color:
		move.w	(a1)+, d1
		move.w	d1, (a0)+
		dbra	d0, .loop_next_color
		rts

fg_seek_xy_cb:
		RSUB	screen_seek_xy
		rts

; params:
;  d0 = tile (word)
;  a6 = already at location in fg ram
; Tile Layout
;  xxxx xxxx xPPP TTTT xxxx xxxx TTTT TTTT
; where
;  P = palette number
;  T = tile number
fg_draw_tile_cb:
		move.w	d0, d1
		and.l	#$ff, d0
		and.l	#$f00, d1
		lsl.l	#$8, d1
		or.l	d1, d0
		or.l	#(PALETTE_NUM << 20), d0
		move.l	d0, (a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0000, $0000, $0fff, $0ffc, $0fd6, $0fb2, $0e70, $0e40
	dc.w	$0ff9, $0aff, $00ff, $00ce, $00ad, $008a, $0068, $0045

d_str_title:	STRING "FG TILE VIEWER"
