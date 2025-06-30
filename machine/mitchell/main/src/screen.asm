	include "cpu/z80/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		exx

		ld	a, CTRL_UNKNOWN_BIT3
		out	(IO_CONTROL), a
	.loop_wait_vblank:
		in	a, (IO_INPUT_SYS2)
		cpl
		and	$08
		jr	z, .loop_wait_vblank

		ld	hl, PALETTE_RAM
		ld	de, PALETTE_RAM_SIZE
		ld	c, $0
		NSUB	memory_fill

		ROMSET_PALETTE_SETUP

		ld	hl, COLOR_RAM
		ld	de, COLOR_RAM_SIZE
		ld	c, $0
		NSUB	memory_fill

		ld	a, VIDEO_BANK_OBJECT
		out	(IO_VIDEO_BANK), a
		ld	hl, TILE_RAM
		ld	de, TILE_RAM_SIZE
		ld	c, $00
		NSUB	memory_fill

		ld	a, VIDEO_BANK_TILE
		out	(IO_VIDEO_BANK), a
		ld	hl, TILE_RAM
		ld	de, TILE_RAM_SIZE
		ld	bc, $2000
		NSUB	memory_fill_word

		ld	a, CTRL_UNKNOWN_BIT6
		out	(IO_CONTROL), a

		SEEK_XY	11, 0
		ld	de, d_str_version
		NSUB	print_string

		SEEK_LN	1
		ld	c, '-'
		ld	b, 48
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
		add	hl, bc

		; x offset
		ld	b, $0
		sla	a
		ld	c, a
		add	hl, bc
		DSUB_RETURN
