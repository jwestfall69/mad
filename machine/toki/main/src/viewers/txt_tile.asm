	include "cpu/68000/include/common.inc"

	global txt_tile_viewer

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK	equ $fff

txt_tile_viewer:
		bsr	txt_palette_setup

		moveq	#$0, d0
		move.w	#TILE_OFFSET_MASK, d1
		lea	txt_seek_xy_cb, a0
		lea	txt_draw_tile_cb, a1
		bsr	tile8_viewer_handler
		rts

; Palette Layout
;  xxxx BBBB GGGG RRRR
txt_palette_setup:

		lea	TXT_PALETTE + (PALETTE_SIZE * PALETTE_NUM), a0
		lea	d_palette_data, a1
		moveq	#(PALETTE_SIZE/2 - 1), d0

	.loop_next_color:
		move.w	(a1)+, d1
		move.w	d1, (a0)+
		dbra	d0, .loop_next_color
		rts

txt_seek_xy_cb:
		RSUB	screen_seek_xy
		rts

; params:
;  d0 = tile (word)
;  a6 = already at location in txt ram
; Tile Layout
;  PPPP TTTT TTTT TTTT
; where
;  P = palette number
;  T = tile number; where
txt_draw_tile_cb:
		or.w	#(PALETTE_NUM << 12), d0
		move.w	d0, (a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0817, $0ed0, $00bc, $0a35, $09d5, $009c, $0c66, $06c4
	dc.w	$0c64, $0b39, $02cb, $0e94, $036b, $04d8, $064c, $050d
