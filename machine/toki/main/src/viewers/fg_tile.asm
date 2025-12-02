	include "cpu/68000/include/common.inc"

	global fg_tile_viewer
	global fg_tile_viewer_palette_setup

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK	equ $fff

fg_tile_viewer:
		bsr	fg_tile_viewer_palette_setup

		; x/y scroll
		move.w	#$10, $0a002a
		move.w	#$fd, $0a002c
		move.w	#$0, $0a003a
		move.w	#$0a, $0a003c

		;lea	FG_RAM + $80, a0
		;move.l	#$700, d0
		;move.w	#$1002, d1
		;DSUB	memory_fill

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
		lea	(-$800, a6), a6
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
fg_draw_tile_cb:
		or.w	#(PALETTE_NUM << 12), d0
		move.w	d0, (a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0abb, $09aa, $0677, $0566, $0455, $0344, $0233, $0122
	dc.w	$0011, $0355, $0344, $0234, $0135, $0766, $0645, $0000
