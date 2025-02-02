	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "global/include/screen.inc"

	include "machine.inc"

	global fg_tile_viewer

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK	equ $ffff

fg_tile_viewer:
		RSUB	screen_init
		bsr	fg_palette_setup

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		lea	d_str_title, a0
		RSUB	print_string

		moveq	#0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	fg_seek_xy_cb, a0
		lea	fg_draw_tile_cb, a1
		bsr	tile8_viewer_handler
		rts


; Palette Layout
;  bbbb RRRR GGGG BBBB
; where
;  b = brightness value (applies to all colors)
fg_palette_setup:

		lea	PALETTE_RAM_START+(PALETTE_SIZE*PALETTE_NUM), a0
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
;  TTTT TTTT TTTT TTTT ???? ???? ???? PPPP
; where
;  P = palette number
;  T = tile number
fg_draw_tile_cb:
		and.l	#$ffff, d0
		swap	d0
		or.l	#PALETTE_NUM, d0
		move.l	d0, (a6)
		rts

	section data
	align 2

d_palette_data:
	dc.w	$f817, $fed0, $f0bc, $fa35, $f9d5, $f09c, $fc66
	dc.w	$f6c4, $fc64, $fb39, $f2cb, $fe94, $f36b, $f4d8
	dc.w	$f64c, $f50d

d_str_title: 	STRING "FG TILE VIEWER"
