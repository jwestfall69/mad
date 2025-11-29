	include "cpu/68000/include/common.inc"

	global fg_tile_viewer
	global fg_tile_viewer_palette_setup

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK	equ $7ff

fg_tile_viewer:
		bsr	fg_tile_viewer_palette_setup

		move.w	#$3fc, REG_FG_SCROLL_X
		move.w	#$4, REG_FG_SCROLL_Y

		moveq	#$0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	fg_seek_xy_cb, a0
		lea	fg_draw_tile_cb, a1
		bsr	tile16_viewer_handler
		rts

; Palette Layout
;  xxxx BBBB GGGG RRRR
fg_tile_viewer_palette_setup:

		lea	FG_PALETTE + (PALETTE_SIZE * PALETTE_NUM), a0
		lea	d_palette_data, a1
		moveq	#(PALETTE_SIZE/2 - 1), d0

	.loop_next_color:
		move.w	(a1)+, d1
		move.w	d1, (a0)+
		dbra	d0, .loop_next_color
		rts

fg_seek_xy_cb:
		SEEK_XY	0, 0
		and.l	#$ff, d0
		and.l	#$ff, d1

		;lsl.w	#1, d0
		lsl.w	#6, d1
		adda.l	d0, a6
		adda.l	d1, a6
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
		lea	($2800, a6), a6
		move.w	d0, (a6)
		lea	(-$1000, a6), a6
		move.w	#(PALETTE_NUM << 4), (a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0c00, $0333, $0666, $0888, $0aaa, $0ccc, $0fff, $0100
	dc.w	$0006, $000a, $000d, $008f, $0500, $0900, $0b00, $0f65
