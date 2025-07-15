	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_write.inc"

	global sprite_debug

	section code

HIGHLIGHT_PALETTE_NUM	equ $1

sprite_debug:
		call	sprite_viewer_palette_setup

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 13)
		ld	de, d_str_last_written
		RSUB	print_string


		ld	a, CTRL_ENABLE_SPRITE_ROMS|CTRL_ENABLE_TILE_ROMS|CTRL_PALETTE_WRITE_REQUEST
		out	(IO_CONTROL), a

		ld	bc, $3ff
		RSUB	delay

		ROMSET_HIGHLIGHT_PALETTE_SETUP

		ld	a, CTRL_ENABLE_SPRITE_ROMS|CTRL_ENABLE_TILE_ROMS
		out	(IO_CONTROL), a

		ld	hl, TILE_ATTR_RAM
		ld	(r_old_highlight), hl

		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), SV_SPRITE_NUM
		ld	(ix + 1), $03
		ld	(ix + 2), $48
		ld	(ix + 3), $f0

		ei
		ld	ix, d_mw_settings
		call	memory_write_handler
		di

		ret

; hl = location in video ram
highlight_cb:
		ld	iy, (r_old_highlight)
		ld	(iy), $0

		; location in color ram is /2 the offset of
		; the location in tile ram
		ld	bc, $d000
		or	a	; clear carry
		sbc	hl, bc
		srl	h
		rr	l
		ld	bc, $c800
		add	hl, bc
		ld	(hl), HIGHLIGHT_PALETTE_NUM
		ld	(r_old_highlight), hl
		ret

write_memory_cb:
		ld	iy, r_mw_buffer
		ld	a, SCREEN_START_X
		ld	(r_x_offset), a
		ld	b, $4
	.loop_next_byte_print:
		push	bc
		ld	a, (r_x_offset)
		ld	b, a
		add	a, $3
		ld	(r_x_offset), a
		ld	c, SCREEN_START_Y + 15
		RSUB	screen_seek_xy

		ld	a, (iy)
		ld	c, a
		RSUB	print_hex_byte
		inc	ix
		inc	iy
		pop	bc
		djnz	.loop_next_byte_print

		ld	a, VIDEO_BANK_SPRITE
		out	(IO_VIDEO_BANK), a

		ld	iy, r_mw_buffer
		ld	ix, SPRITE_RAM

		ld	b, $4
	.loop_next_byte_sprite:
		ld	a, (iy)
		ld	(ix), a
		inc	ix
		inc	iy
		djnz	.loop_next_byte_sprite

		ld	a, VIDEO_BANK_TILE
		out	(IO_VIDEO_BANK), a
		ret

loop_cb:
		ret

	section data

d_mw_settings:		MW_SETTINGS 4, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_str_last_written:	STRING "LAST WRITTEN"

	section bss

r_mw_buffer:		dcb.b 4
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
