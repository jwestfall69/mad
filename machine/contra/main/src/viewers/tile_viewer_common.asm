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
	dc.w	$0000, $6d39, $3e34, $fe00, $5864, $8064, $e277, $d126
	dc.w	$e519, $8271, $0e78, $aa39, $f725, $0e5e, $9532, $ffff
