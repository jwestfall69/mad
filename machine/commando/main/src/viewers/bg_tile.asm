	include "cpu/z80/include/common.inc"

	global bg_tile_viewer

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK_UPPER	equ $3

bg_tile_viewer:
		ld	bc, $0
		ld	(REG_BG_SCROLL_X), bc
		ld	(REG_BG_SCROLL_Y), bc

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
; bg tile ram = TTTT TTTT
; bg tile ram + $400 = TTxx PPPP
draw_tile_cb:
		ld	(hl), c

		ld	a, b
		rrca
		rrca
		or	PALETTE_NUM

		ld	bc, $400
		adc	hl, bc
		ld	(hl), a
		ret
