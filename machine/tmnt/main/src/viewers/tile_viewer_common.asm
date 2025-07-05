	include "cpu/68000/include/common.inc"

	global tvc_draw_tile_cb
	global tvc_init

	section code

; params:
;  a0 = start palette address
; Palette Layout (8 bit only ram)
;  xxxx xxxx xBBB BBGG xxxx xxxx GGGR RRRR
tvc_init:
		clr.b	r_tvc_bank_num

		lea	d_palette_data, a1
		moveq	#PALETTE_SIZE / 2, d0
	.loop_next_byte:
		addq.l	#$1, a0
		move.b	(a1)+, (a0)+
		dbra	d0, .loop_next_byte

		rts

; params:
;  d0.w = tile
;  0BBB BTTT TTTT TTTT
;  B = bank num
;  T = tile num
;  a6 = already at location in tile ram
;  PPPT SSTT TTTT TTTT
;  P = palette num
;  S = bank slot
;  T = tile num
tvc_draw_tile_cb:
		move.w	d0, d1
		lsr.w	#$7, d1
		and.w	#$f0, d1

		cmp.b	r_tvc_bank_num, d1
		beq	.skip_set_bank_num
		move.b	d1, REG_TILE_BANK_SLOTS_A
		move.b	d1, r_tvc_bank_num

	.skip_set_bank_num:
		and.w	#$7ff, d0
		btst	#10, d0
		beq	.skip_bit_10
		or.w	#$1000, d0
		and.w	#$13ff, d0

	.skip_bit_10:
		or.w	#(TVC_PALETTE_NUM << 13 | TVC_BANK_SLOT_NUM << 10), d0
		move.w	d0, d1
		lsr.w	#$8, d1
		move.b	d1, (a6)+
		move.b	d0, (a6)
		rts

	section data
	align 1

d_palette_data:
	dc.w	$3276, $6d39, $3e34, $fe00, $5864, $8064, $e519, $d126
	dc.w	$e277, $8271, $0e78, $aa39, $f725, $0e5e, $9532, $f043

	section bss

r_tvc_bank_num:		dcb.b 1
