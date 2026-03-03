	include "cpu/z80/include/common.inc"

	global bg_tile_viewer

	section code

PALETTE_NUM		equ $2
TILE_OFFSET_MASK_UPPER	equ $7

bg_tile_viewer:

		ld	bc, $0b
		ld	(REG_BG_SCROLL_X), bc

		ld	bc, $0c
		ld	(REG_BG_SCROLL_Y), bc

		ld	hl, d_palette_data
		ld	(r_nmi_copy_src), hl
		ld	hl, BG_TILE_PALETTE
		ld	(r_nmi_copy_dst), hl
		ld	a, BG_TILE_PALETTE_SIZE / 2
		ld	(r_nmi_copy_size), a

		call	wait_nmi_copy

		ld	hl, d_palette_ext_data
		ld	(r_nmi_copy_src), hl
		ld	hl, BG_TILE_PALETTE_EXT
		ld	(r_nmi_copy_dst), hl
		ld	a, BG_TILE_PALETTE_SIZE / 2
		ld	(r_nmi_copy_size), a

		call	wait_nmi_copy

		ld	b, $0
		ld	c, TILE_OFFSET_MASK_UPPER
		ld	ix, seek_xy_cb
		ld	iy, draw_tile_cb
		call	tile_16x16_viewer_handler
		ret

; b = x
; c = y
seek_xy_cb:
		ld	hl, $ea01
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
; tile ram = 0000 0TTT TTTT TTTT
draw_tile_cb:
		ld	(hl), c

		ld	a, b
		sla	a
		sla	a
		sla	a
		sla	a
		sla	a

		ld	bc, $400
		add	hl, bc

		ld	(hl), a
		ret

	section data

d_palette_data:
	dc.b	$00, $da, $cb, $97, $65, $53, $32, $64
	dc.b	$97, $ca, $33, $44, $66, $88, $aa, $cc

d_palette_ext_data:
	dc.b	$00, $80, $60, $40, $20, $20, $00, $00
	dc.b	$00, $00, $20, $30, $50, $70, $90, $b0
