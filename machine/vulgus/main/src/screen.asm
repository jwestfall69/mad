	include "cpu/z80/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		exx

		ld	hl, FIX_TILE
		ld	de, FIX_TILE_SIZE
		ld	c, $20
		NSUB	memory_fill

		ld	hl, FIX_TILE_ATTR
		ld	de, FIX_TILE_ATTR_SIZE
		ld	c, $01
		NSUB	memory_fill

		ld	hl, BG_TILE
		ld	de, BG_TILE_SIZE
		ld	c, $ff
		NSUB	memory_fill

		ld	hl, BG_TILE_ATTR
		ld	de, BG_TILE_ATTR_SIZE
		ld	c, $80
		NSUB	memory_fill

		SEEK_XY	2, 0
		ld	de, d_str_version
		NSUB	print_string

		SEEK_XY	0, 1
		ld	c, $2d
		ld	b, SCREEN_NUM_COLUMNS
		NSUB	print_char_repeat
		DSUB_RETURN

; b = x
; c = y
screen_seek_xy_dsub:
		exx

		SEEK_XY	0, 0
		ld	a, b

		; y offset
		ld	b, $0
		or	a	; clear carry
		sbc	hl, bc

		; x offset
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
		add	hl, bc
		DSUB_RETURN
