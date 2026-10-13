	include "cpu/z80/include/common.inc"

	global bg_tile_viewer
	global bg_tile_viewer_palette_setup

	section code

TILE_OFFSET_MASK_UPPER	equ $7

bg_tile_viewer:
		call	bg_tile_viewer_palette_setup

		ld	a, $4
		out	(IO_SCROLL_X_LOW), a
		out	(IO_SCROLL_Y_LOW), a

		ld	b, $0
		ld	c, TILE_OFFSET_MASK_UPPER
		ld	ix, seek_xy_cb
		ld	iy, draw_tile_cb
		call	tile_16x16_viewer_handler


		ld	a, $0
		out	(IO_SCROLL_X_LOW), a
		out	(IO_SCROLL_Y_LOW), a
		ret

seek_xy_cb:
		ld	hl, BG_TILE_RAM + $20
		ld	a, b

		; y offset
		ld	b, $0
		sla	c
		rl	b
		sla	c
		rl	b
		sla	c
		rl	b
		sla	c
		rl	b
		add	hl, bc

		; x offset
		ld	b, $0
		ld	c, a
		add	hl, bc
		ret

; params:
;  bc = tile (word)
;  hl = already at location in tile ram
; tile ram = TTTT TTTT XPPP PTTT
draw_tile_cb:
		ld	(hl), c
		inc	hl
		ld	a, b
		or	$08
		ld	(hl), a
		ret

bg_tile_viewer_palette_setup:
		ld	hl, BG_TILE_PALETTE + (BG_TILE_PALETTE_SIZE / 2)
		ld	de, d_palette_data
		ld	c, BG_TILE_PALETTE_SIZE
		call	palette_copy
		ret

	section data

d_palette_data:
	dc.w	$0406, $890c, $7809, $6708, $5607, $4506, $3405, $5400
	dc.w	$7503, $8604, $a705, $c806, $ea07, $fc08, $ff0a, $0000
