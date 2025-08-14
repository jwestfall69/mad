	include "cpu/z80/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		exx

		ld	hl, TILE_ATTR_RAM
		ld	de, TILE_ATTR_RAM_SIZE
		ld	c, $a
		NSUB	memory_fill

		ld	hl, TILE_RAM
		ld	de, TILE_RAM_SIZE
		ld	c, $10
		NSUB	memory_fill

		ld	hl, SPRITE_RAM
		ld	de, SPRITE_RAM_SIZE
		ld	c, $0
		NSUB	memory_fill

		SEEK_XY	2, 0
		ld	de, d_str_version
		NSUB	print_string

		SEEK_XY	0, 1
		ld	c, $3b
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
		ld	b, c
		ld	c, $0
		sra	b
		rr	c
		sra	b
		rr	c
		add	hl, bc

		; x offset
		ld	b, $0
		ld	c, a
		add	hl, bc
		DSUB_RETURN
