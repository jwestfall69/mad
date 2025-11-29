	include "cpu/68000/include/common.inc"

	global bg_tile_viewer
	global bg_tile_viewer_palette_setup

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK	equ $7ff

bg_tile_viewer:
		bsr	bg_tile_viewer_palette_setup

		move.w	#$3fc, REG_BG_SCROLL_X
		move.w	#$4, REG_BG_SCROLL_Y

		moveq	#$0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	bg_seek_xy_cb, a0
		lea	bg_draw_tile_cb, a1
		bsr	tile16_viewer_handler
		rts

; Palette Layout
;  xxxx BBBB GGGG RRRR
bg_tile_viewer_palette_setup:

		lea	BG_PALETTE + (PALETTE_SIZE * PALETTE_NUM), a0
		lea	d_palette_data, a1
		moveq	#(PALETTE_SIZE/2 - 1), d0

	.loop_next_color:
		move.w	(a1)+, d1
		move.w	d1, (a0)+
		dbra	d0, .loop_next_color
		rts

bg_seek_xy_cb:
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
bg_draw_tile_cb:
		lea	($4800, a6), a6
		move.w	d0, (a6)
		lea	(-$1000, a6), a6
		move.w	#(PALETTE_NUM << 4), (a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0c00, $0336, $0000, $0443, $0665, $0887, $0998, $0bba
	dc.w	$0135, $0246, $0468, $0579, $079b, $09bd, $0448, $055a
