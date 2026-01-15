	include "cpu/68000/include/common.inc"

	global bg_tile_viewer

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK	equ $fff

bg_tile_viewer:
		RSUB	screen_init
		bsr	bg_palette_setup

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		lea	d_str_title, a0
		RSUB	print_string

		moveq	#$0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	bg_seek_xy_cb, a0
		lea	bg_draw_tile_cb, a1
		bsr	tile_16x16_viewer_handler
		rts

; Palette Layout
;  xxxx BBBB GGGG RRRR
bg_palette_setup:

		; bg tile's palettes start at PALETTE_SIZE * 16.
		; going to the next one because the first one is used
		; for the main bg color
		lea	BG_PALETTE + PALETTE_SIZE, a0
		lea	d_palette_data, a1
		moveq	#(PALETTE_SIZE/2 - 1), d0

	.loop_next_color:
		move.w	(a1)+, d1
		move.w	d1, (a0)+
		dbra	d0, .loop_next_color
		rts

; in cases where we need to goto x, y location at runtime
; params:
;  d0 = x
;  d1 = y
bg_seek_xy_cb:
		lea	BG_RAM, a6
		and.l	#$ff, d0
		and.l	#$ff, d1

		lsl.w	#1, d0
		lsr.w	#1, d1
		mulu.w	#$40, d1
		adda.l	d0, a6
		adda.l	d1, a6
		rts

; params:
;  d0 = tile (word)
;  a6 = already at location in bg ram
; Tile Layout
;  xxxx xxxx xPPP TTTT xxxx xxxx TTTT TTTT
; where
;  P = palette number
;  T = tile number
bg_draw_tile_cb:
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
	dc.w	$0000, $0460, $0b0b, $0000, $0ccc, $07af, $0f50, $037d
	dc.w	$0248, $0777, $019d, $0830, $0025, $0333, $0495, $07de

d_str_title:	STRING "BG TILE VIEWER"
