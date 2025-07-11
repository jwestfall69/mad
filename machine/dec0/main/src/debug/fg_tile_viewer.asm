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
		bsr	tile8_viewer_handler
		rts

; Palette layout
;  GGGG RRRR (palette ram)
;  xxxx BBBB (palette ext ram)
fg_palette_setup:

		lea	PALETTE_RAM+(PALETTE_SIZE*PALETTE_NUM), a0
		lea	PALETTE_EXT_RAM+(PALETTE_SIZE*PALETTE_NUM), a1
		lea	d_palette_data, a2
		moveq	#(PALETTE_SIZE/2 - 1), d0

	.loop_next_color:
		move.w	(a2)+, d1
		move.b	d1, (a0)+
		lsr.w	#$8, d1
		move.b	d1, (a1)+
		dbra	d0, .loop_next_color
		rts

fg_seek_xy_cb:
		RSUB	screen_seek_xy
		rts

; params:
;  d0 = tile (word)
;  a6 = already at location in fg ram
; Tile Layout
;  PPPP TTTT TTTT TTTT
; where
;  P = palette number
;  T = tile number
fg_draw_tile_cb:
		or.w	#(PALETTE_NUM << 12), d0
		move.w	d0, (a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0817, $0ed0, $00bc, $0a35, $09d5, $009c, $0c66
	dc.w	$06c4, $0c64, $0b39, $02cb, $0e94, $036b, $04d8
	dc.w	$064c, $050d

d_str_title: 	STRING "FG TILE VIEWER"
