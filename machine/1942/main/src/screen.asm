	include "cpu/z80/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		exx

		ld	hl, FIX_TILE
		ld	de, FIX_TILE_SIZE
		ld	c, $30
		NSUB	memory_fill

		ld	hl, FIX_TILE_ATTR
		ld	de, FIX_TILE_ATTR_SIZE
		ld	c, $19
		NSUB	memory_fill

		ld	hl, BG_TILE_RAM
		ld	c, $f8
		NSUB	bg_tile_fill

		ld	hl, BG_TILE_RAM + $10
		ld	c, $80
		NSUB	bg_tile_fill

		SEEK_XY	3, 0
		ld	de, d_str_version
		NSUB	print_string

		SEEK_XY	0, 1
		ld	c, $25
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

; bg tile ram has a weird layout. For every 32 bytes it has
; 16 bytes of tile numbers, then 16 bytes of tile attributes.
; This fill function will fill every other 16 bytes.
; params:
;  hl = start address
;  c = byte
bg_tile_fill_dsub:
		exx

		ld	e, c
		ld	d, $20
	.loop_next_row:


		ld	b, $10
	.loop_next_byte:
		ld	(hl), e
		inc	hl
		djnz	.loop_next_byte

		ld	bc, $10
		add	hl, bc

		dec	d
		jr	nz, .loop_next_row
		DSUB_RETURN
