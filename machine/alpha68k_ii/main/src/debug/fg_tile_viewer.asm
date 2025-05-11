	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"

	include "machine.inc"

	global fg_tile_viewer

	section code

PALETTE_NUM		equ $1
; There is some bank switching stuff that I need to look into.
TILE_OFFSET_MASK	equ ROMSET_TILE_OFFSET_MASK

fg_tile_viewer:
		RSUB	screen_init
		bsr	fg_palette_setup

		clr.b	r_fg_current_bank

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		lea	d_str_title, a0
		RSUB	print_string

		moveq	#$0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	fg_seek_xy_cb, a0
		lea	fg_draw_tile_cb, a1
		bsr	tile8_viewer_handler

		moveq	#0, d0
		bsr	fg_set_bank
		rts

; Palette Layout
;  xxxx RRRR GGGG BBBB
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
; TTTT TTTT TTTT TTTT xxxx xxxx PPPP PPPP ??
; and we need to write backwards
; where
;  P = palette number
;  T = tile number
fg_draw_tile_cb:

		move.w	d0, -(a7)

		lsr.w	#$8, d0
		bsr	fg_set_bank

		move.w	(a7)+, d0
		and.w	#$ff, d0

		move.w	#PALETTE_NUM, -(a6)
		move.w	d0, -(a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0000, $0ed0, $00bc, $0a35, $09d5, $009c, $0c66
	dc.w	$06c4, $0c64, $0b39, $02cb, $0e94, $036b, $04d8
	dc.w	$064c, $050d

d_str_title: 	STRING "FG TILE VIEWER"
