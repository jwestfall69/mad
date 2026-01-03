	include "cpu/68000/include/common.inc"

	global tvc_draw_tile_cb
	global tvc_init

	section code

; params:
;  a0 = start palette address
; Palette Layout
;  bbbb RRRR GGGG BBBB
; where
;  b = brightness value (applies to all colors)
tvc_init:
		lea	d_palette_data, a1
		moveq	#(PALETTE_SIZE/2 - 1), d0

	.loop_next_color:
		move.w	(a1)+, d1
		move.w	d1, (a0)+
		dbra	d0, .loop_next_color
		RSUB	screen_update_palette
		rts

; params:
;  d0 = tile (word)
;  a6 = already at location in fg ram
; Tile Layout
;  TTTT TTTT TTTT TTTT ???? ???? ???? PPPP
; where
;  P = palette number
;  T = tile number
tvc_draw_tile_cb:
		and.l	#$ffff, d0
		swap	d0
		or.l	#TVC_PALETTE_NUM, d0
		move.l	d0, (a6)
		rts

	section data
	align 1

d_palette_data:
	RS_TV_PALETTE_DATA
