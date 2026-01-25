	include "cpu/z80/include/common.inc"

	global fix_tile_viewer

	section code

PALETTE_NUM		equ $1
TILE_OFFSET_MASK_UPPER	equ $3

fix_tile_viewer:
		ld	hl, FIX_TILE_PALETTE + ((FIX_TILE_PALETTE_SIZE / 2) * PALETTE_NUM)
		ld	de, d_palette_data
		ld	c, FIX_TILE_PALETTE_SIZE
		call	palette_copy

		ld	b, $0
		ld	c, TILE_OFFSET_MASK_UPPER
		ld	de, seek_xy_cb
		ld	hl, draw_tile_cb
		call	tile_8x8_viewer_handler
		ret

seek_xy_cb:
		RSUB	screen_seek_xy
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

		ld	bc, $800
		add	hl, bc

		or	PALETTE_NUM
		ld	(hl), a
		ret

	section data

d_palette_data:
	dc.w	$f000, $0f0f, $ff0f, $ffff
