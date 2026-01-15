	include "cpu/z80/include/common.inc"

	global tile_viewer

	section code

TILE_OFFSET_MASK_UPPER	equ $1

tile_viewer:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_title
		RSUB	print_string

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
;  0000 000T TTTT TTTT
;  hl = already at location in tile ram
; tile ram = TTTT TTTT
; tile attr ram = xTFF  PPPP
draw_tile_cb:

		ld	(hl), c
		ld	a, b
		cp	$1
		jr	nz, .skip_bit_0
		ld	a, $40

	.skip_bit_0:
		ld	bc, $800
		or	a	; clear carry
		sbc	hl, bc
		ld	(hl), a
		ret

	section data

d_str_title:	STRING "TILE VIEWER"
