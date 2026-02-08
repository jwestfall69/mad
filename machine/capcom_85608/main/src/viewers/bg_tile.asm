	include "cpu/z80/include/common.inc"

	global bg_tile_viewer

	section code

PALETTE_NUM		equ $2
TILE_OFFSET_MASK_UPPER	equ $7

bg_tile_viewer:

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

	ifd _SCREEN_TATE_
; b = x
; c = y
seek_xy_cb:
		ld	hl, $e9e0
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

	else
; b = x
; c = y
seek_xy_cb:
		ld	hl, $e800
		srl b
		srl c

		ld	a, b
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
		add	hl, bc
		ret
	endif
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
	RS_BG_TV_PALETTE_DATA

d_palette_ext_data:
	RS_BG_TV_PALETTE_EXT_DATA
