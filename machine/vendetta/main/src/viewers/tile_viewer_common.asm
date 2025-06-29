	include "global/include/macros.inc"
	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"

	include "cpu/konami2/include/dsub.inc"

	include "machine.inc"
	include "mad.inc"

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

		lda	#$1
		sta	REG_CONTROL

		ldx	#d_palette_data
		ldb	#PALETTE_SIZE

	.loop_next_color:
		lda	,x+
		sta	,y+
		decb
		bne	.loop_next_color

		lda	#$0
		sta	REG_CONTROL
		rts

; params:
;  d = tile (word)
;  0BBB TTTT TTTT TTTT
;  B = bank num
;  T = tile num
;  x = already at location in tile ram
;  PPTT SSTT TTTT TTTT
;  P = palette num
;  S = bank slot
;  T = tile num
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
		anda	#$0f
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
	dc.w	$0000, $6d39, $3e34, $fe00, $5864, $8064, $e519, $d126
	dc.w	$ffff, $8271, $0e78, $aa39, $f725, $0e5e, $9532, $e277

	section bss

r_tvc_bank_num:		dcb.b 1
