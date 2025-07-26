	include "cpu/68000/include/common.inc"

	global tvc_palette_setup

	section code

; params:
;  a0 = palette ram start address
tvc_palette_setup:
		lea	d_palette_data, a1
		moveq	#(PALETTE_SIZE/8 - 1), d0

	.loop_next_color:
		move.w	(a1)+, (a0)+
		dbra	d0, .loop_next_color
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0000, $0ed0, $00bc, $0a35, $09d5, $009c, $0c66, $06c4
	dc.w	$0c64, $0b39, $02cb, $0e94, $036b, $04d8, $064c, $050d
