	include "cpu/68000/include/common.inc"

	global tvc_draw_tile_cb
	global tvc_init

	section code

; params:
;  a0 = start palette address
; Palette Layout
;  xBBB BBGG GGGR RRRR
tvc_init:
		clr.b	r_tvc_bank_num

		lea	d_palette_data, a1
		moveq	#PALETTE_SIZE / 2, d0
	.loop_next_byte:
		move.w	(a1)+, (a0)+
		dbra	d0, .loop_next_byte

		rts

; params:
;  d0.w = tile
;  TTTT TTTT TTTT TTTT
;  T = tile num
;  a6 = already at location in tile ram
;  PPPT SSTT TTTT TTTT
;  P = palette num
;  S = bank slot
;  T = tile num
tvc_draw_tile_cb:
		move.w	d0, (a6)
		lsr.w	#$8, d0
		move.w	d0, ($4000, a6)
		move.w	#(TVC_PALETTE_NUM << 4), d0
		move.w	d0, (-$4000, a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0000, $7fff, $7739, $5a52, $2d08, $0000, $7e9b, $119b
	dc.w	$03bf, $43ea, $7ffb, $4b00, $63e0, $03ff, $01ff, $031f

	section bss

r_tvc_bank_num:		dcb.b 1
