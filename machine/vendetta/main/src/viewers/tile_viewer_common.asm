	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"
	include "cpu/konami2/include/xy_string.inc"

	include "machine.inc"
	include "mad.inc"

	global tvc_draw_tile_cb
	global tvc_palette_setup

	section code

; Palette Layout
;  xBBB BBGG GGGR RRRR
; params:
;  y = start palette address
tvc_palette_setup:
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
;  x = already at location in tile ram
; PPTT ??TT TTTT TTTT
tvc_draw_tile_cb:
		exg	b, a
		RSUB	print_byte

		tfr	b, a
		bita	#$4
		beq	.skip_bit_4
		ora	#$10

	.skip_bit_4:
		bita	#$8
		beq	.skip_bit_5
		ora	#$20

	.skip_bit_5:
		anda	#$33
		ora	#(TVC_PALETTE_NUM<<6)
		sta	-$2000, x
		rts

	section data

d_palette_data:
	dc.w	$0000, $6d39, $3e34, $fe00, $5864, $8064, $e519, $d126
	dc.w	$ffff, $8271, $0e78, $aa39, $f725, $0e5e, $9532, $e277
