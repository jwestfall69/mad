	include "cpu/z80/include/common.inc"

	global fix_tile_viewer

	section code

PALETTE_NUM		equ $2
TILE_OFFSET_MASK_UPPER	equ $7

fix_tile_viewer:
		ld	b, $0
		ld	c, TILE_OFFSET_MASK_UPPER
		ld	ix, seek_xy_cb
		ld	iy, draw_tile_cb
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

		ld	bc, $400
		add	hl, bc

		ld	(hl), a
		ret
