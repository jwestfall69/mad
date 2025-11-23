	include "cpu/konami2/include/common.inc"

	global tvc_draw_tile_cb
	global tvc_init

	section code

; Palette Layout
;  xBBB BBGG GGGR RRRR
; params:
;  y = start palette address
tvc_init:

		clr	r_tvc_bank_num
		clr	REG_TILE_BANK_SLOTS_A

		lda	#CTRL_PALETTE_BANK
		sta	REG_CONTROL

		ldx	#d_palette_data
		ldb	#PALETTE_SIZE

	.loop_next_color:
		lda	,x+
		sta	,y+
		decb
		bne	.loop_next_color

		clr	REG_CONTROL
		rts

; params:
;  d = tile (word)
;  BBBB TTTT TTTT TTTT
;  x = already at location in tile ram
; PPTT SSTT TTTT TTTT
; P = palette num
; S = bank slot?
; T = tile num
tvc_draw_tile_cb:
		exg	b, a
		RSUB	print_byte

		; top 4 bits will select the bank number for bank slot 1
		tfr	b, a
		andb	#$f0
		cmpb	r_tvc_bank_num
		beq	.skip_set_bank_num

		stb	REG_TILE_BANK_SLOTS_A
		stb	r_tvc_bank_num

	.skip_set_bank_num:
		anda	#$f
		bita	#$4
		beq	.skip_bit_4
		ora	#$10

	.skip_bit_4:
		bita	#$8
		beq	.skip_bit_5
		ora	#$20

	.skip_bit_5:
		anda	#$33
		ora	#(TVC_PALETTE_NUM<<6 | TVC_BANK_SLOT_NUM<<2)
		sta	-$2000, x
		rts

	section data

d_palette_data:
	dc.w	$0000, $7ffe, $2d6b, $03e0, $3def, $7c1f, $7fff, $6739
	dc.w	$7c1f, $01b9, $5d44, $2c1d, $1cfb, $03ff, $0b7f, $0000

	section bss

r_tvc_bank_num:		dcb.b 1
