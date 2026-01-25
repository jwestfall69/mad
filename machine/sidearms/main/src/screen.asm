	include "cpu/z80/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		exx

		NSUB	palette_memory_fill

	.loop_palette_write_error:
		ld	(REG_PAL_WRITE_ERROR_CLEAR), a

		ld	a, $ff
		ld	(FIX_TILE_PALETTE + 1), a
		ld	(FIX_TILE_PALETTE_EXT + 1), a

		ld	a, (REG_INPUT_SYS)
		bit	SYS_PAL_WRITE_ERROR_BIT, a
		jr	z, .loop_palette_write_error

		ld	hl, FIX_TILE
		ld	de, FIX_TILE_SIZE
		ld	c, $27
		NSUB	memory_fill

		ld	hl, FIX_TILE_ATTR
		ld	de, FIX_TILE_ATTR_SIZE
		ld	c, $0
		NSUB	memory_fill

		ld	hl, SPRITE_RAM
		ld	de, SPRITE_RAM_SIZE
		ld	c, $0
		NSUB	memory_fill

		SEEK_XY	11, 0
		ld	de, d_str_version
		NSUB	print_string

		SEEK_XY	0, 1
		ld	c, $37
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


; Writes to palette ram requires some specific timing that is somehow related
; go vblank.  Its not really clear what that timing is because vblank timings
; are fed into the address lines of the prom @ 16H and one of its data pins
; determines when palette writes can happen.  Palette write outside this
; allowed time are ignored.  The board provide a way to see if a palette write
; failed via SYS_PAL_WRITE_ERROR_BIT of REG_INPUT_SYS (low = failed).  This
; error bit can be reset to high, with a write to REG_PAL_WRITE_ERROR_CLEAR.
; Its not possible to write the entire palette ram space in one go without
; getting a write error.  We instead need to break it up and write in chucks,
; rewriting a chunk if it failed.
palette_memory_fill_dsub:
		exx

		ld	hl, PALETTE_RAM
		ld	d, h
		ld	e, l
		ld	c, $10		; number chunks
	.loop_next_palette_chunk:
	.loop_pal_write_error:
		ld	h, d
		ld	l, e

		ld	(REG_PAL_WRITE_ERROR_CLEAR), a
		ld	b, $80		; block size
	.loop_next_byte:
		ld	(hl), $0
		inc	hl
		djnz	.loop_next_byte

		ld	a, (REG_INPUT_SYS)
		bit	SYS_PAL_WRITE_ERROR_BIT, a
		jr	z, .loop_pal_write_error

		ld	d, h
		ld	e, l
		dec	c
		jr	nz, .loop_next_palette_chunk
		DSUB_RETURN
