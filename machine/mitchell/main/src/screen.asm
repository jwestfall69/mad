	include "cpu/z80/include/common.inc"

	global screen_init_dsub
	global screen_seek_xy_dsub

	section code

screen_init_dsub:
		exx

		ld	a, CTRL_ENABLE_SPRITE_ROMS|CTRL_ENABLE_TILE_ROMS|CTRL_PALETTE_WRITE_REQUEST
		out	(IO_CONTROL), a

		; After requesting CTRL_PALETTE_WRITE_REQUEST on IO_CONTROL you
		; need to wait for bit SYS2_PALETTE_WRITE_READY to be 1 on
		; IO_INPUT_SYS2 before you start writing to palette ram.  If
		; you attempt write to palette ram before this the writes will
		; be ignored.  The bit however should get set to 1 at the next
		; vblank.  To avoid getting stuck polling IO_INPUT_SYS2 if
		; there is a fault we are just doing a manual delay to get us
		; to that vblank
		ld	bc, $7ff
		NSUB	delay

		ld	hl, PALETTE_RAM
		ld	de, PALETTE_RAM_SIZE
		ld	c, $0
		NSUB	memory_fill

		ROMSET_PALETTE_SETUP

		ld	a, CTRL_ENABLE_SPRITE_ROMS|CTRL_ENABLE_TILE_ROMS
		out	(IO_CONTROL), a

		ld	hl, TILE_RAM
		ld	de, TILE_RAM_SIZE
		ld	bc, $2000
		NSUB	memory_fill_word

		ld	hl, TILE_ATTR_RAM
		ld	de, TILE_ATTR_RAM_SIZE
		ld	c, $0
		NSUB	memory_fill

		ld	a, VIDEO_BANK_SPRITE
		out	(IO_VIDEO_BANK), a

		ld	hl, SPRITE_RAM
		ld	de, SPRITE_RAM_SIZE
		ld	c, $00
		NSUB	memory_fill

		ld	a, VIDEO_BANK_TILE
		out	(IO_VIDEO_BANK), a

		SEEK_XY	11, 0
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
