	include "cpu/6309/include/common.inc"

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

	section data

d_palette_data:
	dc.w	$0000, $ffff, $1e00, $ba3e, $1b53, $773e, $363a, $4e3a
	dc.w	$cb31, $661d, $404e, $8056, $205a, $d22d, $ae31, $c618
