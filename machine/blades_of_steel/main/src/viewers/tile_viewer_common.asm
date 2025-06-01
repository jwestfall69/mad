	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

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
;  000T TTTT TTTT TTTT
;  T = tile num
;  x = already at location in tile ram
;  0T00 TTTT TTTT TTTT
;  T = tile num
tvc_draw_tile_cb:
		exg	b, a
		PSUB	print_byte

		bitb	#$10
		beq	.skip_bit_4
		andb	#$f
		orb	#$40
	.skip_bit_4:
		stb	-$800, x
		rts

	section data

d_palette_data:
	dc.w	$0000, $6d39, $3e34, $fe00, $5864, $8064, $ffff, $d126
	dc.w	$e519, $8271, $0e78, $aa39, $f725, $0e5e, $9532, $e277
