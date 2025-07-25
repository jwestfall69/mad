	include "cpu/6309/include/common.inc"

	global tvc_draw_tile_cb
	global tvc_init

	section code

; Palette Layout
;  xBBB BBGG GGGR RRRR
; params:
;  y = start palette address
tvc_init:
		ldx	#d_palette_data
		ldb	#PALETTE_SIZE

	.loop_next_color:
		lda	,x+
		sta	,y+
		decb
		bne	.loop_next_color
		rts

; params:
;  d = tile (word)
;  0BBB BTTT TTTT TTTT
;  x = already at location in tile ram
; PP?T TT?T TTTT TTTT
; P = palette num
; T = tile num
tvc_draw_tile_cb:
		exg	b, a
		RSUB	print_byte

		lslb
		bitb	#$2
		beq	.skip_bit_2
		orb	#$1

	.skip_bit_2:
		andb	#$1d
		orb	#TVC_PALETTE_NUM<<6
		stb	-$2000, x
		rts

	section data

d_palette_data:
	dc.w	$0000, $6d39, $3e34, $fe00, $5864, $8064, $e519, $d126
	dc.w	$ffff, $8271, $0e78, $aa39, $f725, $0e5e, $9532, $e277
