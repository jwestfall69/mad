	include "cpu/z80/include/common.inc"

	global bg_tile_viewer

	section code

TILE_OFFSET_MASK_UPPER	equ $1

bg_tile_viewer:
		ld	b, $0
		ld	c, TILE_OFFSET_MASK_UPPER
		ld	ix, seek_xy_cb
		ld	iy, draw_tile_cb
		call	tile_16x16_viewer_handler
		ret

; b = x
; c = y
seek_xy_cb:
		ld	hl, $d9e1
		srl b
		srl c

		ld	a, c
		ld	c, b
		ld	b, $0
		add	hl, bc

		ld	c, a
		sla	c
		rl	b
		sla	c
		rl	b
		sla	c
		rl	b
		sla	c
		rl	b
		sla	c
		rl	b

		or	a	; clear carry
		sbc	hl, bc
		ret

; params:
;  bc = tile (word)
;  hl = already at location in tile ram
; tile ram = 0000 000T TTTT TTTT
draw_tile_cb:
		ld	(hl), c

		ld	a, $0
		bit	0, b
		jr	z, .not_bit_0
		ld	a, $80

	.not_bit_0:
		ld	bc, $10
		add	hl, bc

		ld	(hl), a
		ret
