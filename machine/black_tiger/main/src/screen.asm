	include "cpu/z80/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		exx

		NSUB	palette_memory_fill

	.loop_palette_write_error:
		out	(IO_PAL_WRITE_ERROR_CLEAR), a

		ld	a, $ff
		ld	(FIX_TILE_PALETTE + 1), a
		ld	(FIX_TILE_PALETTE_EXT + 1), a

		in	a, (IO_INPUT_SYS)
		bit	SYS_PAL_WRITE_ERROR_BIT, a
		jr	z, .loop_palette_write_error

		ld	a, $ff
		ld	(FIX_TILE_PALETTE + 1), a
		ld	(FIX_TILE_PALETTE_EXT + 1), a

		ld	hl, FIX_TILE
		ld	de, FIX_TILE_SIZE
		ld	bc, $20
		NSUB	memory_fill

		ld	hl, FIX_TILE_ATTR
		ld	de, FIX_TILE_ATTR_SIZE
		ld	c, $0
		NSUB	memory_fill

		ld	a, $3
		out	(IO_BG_RAM_BANK), a
		ld	hl, BG_TILE_RAM
		ld	de, BG_TILE_RAM_SIZE
		ld	c, $0
		NSUB	memory_fill

		ld	a, $2
		out	(IO_BG_RAM_BANK), a
		ld	hl, BG_TILE_RAM
		ld	de, BG_TILE_RAM_SIZE
		ld	c, $0
		NSUB	memory_fill

		ld	a, $1
		out	(IO_BG_RAM_BANK), a
		ld	hl, BG_TILE_RAM
		ld	de, BG_TILE_RAM_SIZE
		ld	c, $0
		NSUB	memory_fill

		ld	a, $0
		out	(IO_BG_RAM_BANK), a
		ld	hl, BG_TILE_RAM
		ld	de, BG_TILE_RAM_SIZE
		ld	c, $0
		NSUB	memory_fill

		ld	hl, SPRITE_RAM
		ld	de, SPRITE_RAM_SIZE
		ld	c, $00
		NSUB	memory_fill

		SEEK_XY	3, 0
		ld	de, d_str_version
		NSUB	print_string

		SEEK_XY	0, 1
		ld	c, '-'
		ld	b, SCREEN_NUM_COLUMNS
		NSUB	print_char_repeat

		; this likely isn't doing anything, see irq_handler
		; for more info
		out	(IO_SPRITE_COPY_REQUEST), a
		DSUB_RETURN

; b = x
; c = y
screen_seek_xy_dsub:
		exx

		SEEK_XY	0, 0
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
		sla	c
		rl	b
		add	hl, bc

		; x offset
		ld	b, $0
		ld	c, a
		add	hl, bc
		DSUB_RETURN

; Writes to palette ram requires some specific timing. Palette writes outside this
; allowed time are ignored.  The board provide a way to see if a palette write
; failed via SYS_PAL_WRITE_ERROR_BIT of IO_INPUT_SYS (low = failed).  This
; error bit can be reset to high, with a write to IO_PAL_WRITE_ERROR_CLEAR.
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

		out	(IO_PAL_WRITE_ERROR_CLEAR), a
		ld	b, $80		; block size
	.loop_next_byte:
		ld	(hl), $0
		inc	hl
		djnz	.loop_next_byte

		in	a, (IO_INPUT_SYS)
		bit	SYS_PAL_WRITE_ERROR_BIT, a
		jr	z, .loop_pal_write_error

		ld	d, h
		ld	e, l
		dec	c
		jr	nz, .loop_next_palette_chunk
		DSUB_RETURN
