	include "cpu/68000/include/common.inc"

	global fg_tile_viewer

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK	equ $7ff

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
		bsr	tile8_viewer_handler
		rts

; Palette Layout
;  xxxx BBBB GGGG RRRR
fg_palette_setup:

		lea	PALETTE_RAM+$200+(PALETTE_SIZE*PALETTE_NUM), a0
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
fg_draw_tile_cb:
		move.w	d0, (a6)
		lea	(-$800, a6), a6
		move.w	#(PALETTE_NUM << 4), (a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0817, $0ed0, $00bc, $0a35, $09d5, $009c, $0c66
	dc.w	$06c4, $0c64, $0b39, $02cb, $0e94, $036b, $04d8
	dc.w	$064c, $050d

d_str_title: 	STRING "FG TILE VIEWER"
