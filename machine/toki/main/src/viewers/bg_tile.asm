	include "cpu/68000/include/common.inc"

	global bg_tile_viewer
	global bg_tile_viewer_palette_setup

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK	equ $fff

bg_tile_viewer:
		bsr	bg_tile_viewer_palette_setup

		;lea	BG_RAM + $80, a0
		;move.l	#$700, d0
		;move.w	#$1010, d1
		;DSUB	memory_fill

		; x/y scroll
		move.w	#$10, $0a000a
		move.w	#$fd, $0a000c
		move.w	#$0, $0a001a
		move.w	#$0a, $0a001c

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
		lea	(-$1000, a6), a6
		and.l	#$ff, d0
		and.l	#$ff, d1
		;lsl.w	#1, d0
		lsl.w	#5, d1
		adda.l	d0, a6
		adda.l	d1, a6
		rts

; params:
;  d0 = tile (word)
;  a6 = already at location in txt ram
; Tile Layout
;  PPPP TTTT TTTT TTTT
; where
;  P = palette number
;  T = tile number; where
bg_draw_tile_cb:
		or.w	#(PALETTE_NUM << 12), d0
		move.w	d0, (a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$019d, $018e, $016d, $015a, $0138, $0000, $00fc, $00da
	dc.w	$04b7, $0096, $0084, $0360, $018c, $016c, $011c, $0000
