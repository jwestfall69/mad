	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"

	include "machine.inc"

	global	fg_tile_viewer

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK	equ $1fff

fg_tile_viewer:
		RSUB	screen_clear
		bsr	fg_palette_setup

		SEEK_XY	7, 3
		lea	STR_TITLE, a0
		RSUB	print_string

		moveq	#$0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	fg_seek_xy_cb, a0
		lea	fg_draw_tile_cb, a1
		bsr	tile8_viewer_handler
		rts

; Palette Layout (8 bit only ram)
;  xxxx xxxx xBBB BBGG xxxx xxxx GGGR RRRR
fg_palette_setup:

		lea	PALETTE_RAM_START+(PALETTE_SIZE*PALETTE_NUM), a0
		lea	PALETTE_DATA, a1
		moveq	#(PALETTE_SIZE/4 - 1), d0

	.loop_next_color:
		moveq	#$0, d1
		move.w	(a1)+, d1
		move.w	d1, d2
		swap	d2
		lsr.l	#8, d2
		and.l	#$ff0000, d2
		or.l	d2, d1
		and.l	#$ff00ff, d1
		move.l	d1, (a0)+
		dbra	d0, .loop_next_color
		rts

fg_seek_xy_cb:
		RSUB	screen_seek_xy
		rts

; params:
;  d0 = tile (word)
;  a6 = already at location in fg ram
; Tile Layout
;  PPP? ???? TTTT TTTT
; where
;  P = palette number
;  T = tile number
; need to mess with this some more for the ?? stuff
fg_draw_tile_cb:
		or.w	#(PALETTE_NUM << 13), d0
		move.w	d0, d1
		lsr.w	#$8, d1
		move.b	d1, (a6)+
		move.b	d0, (a6)
		rts

	section data

PALETTE_DATA:
	dc.w	$3276, $6d39, $3e34, $fe00, $5864, $8064, $e519
	dc.w	$d126, $e277, $8271, $0e78, $aa39, $f725, $0e5e
	dc.w	$9532, $f043

STR_TITLE: 	STRING "FG TILE VIEWER"
