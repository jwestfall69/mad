	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_write.inc"

	global sprite_debug

	section code

HIGHLIGHT_PALETTE_NUM	equ $8

sprite_debug:

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 13)
		ld	de, d_str_last_written
		RSUB	print_string

		ld	bc, $3ff
		RSUB	delay

		ld	hl, FIX_TILE_ATTR
		ld	(r_old_highlight), hl

		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), $2c
		ld	(ix + 1), $03
		ld	(ix + 2), $b0
		ld	(ix + 3), $b0

		ld	a, LAYER_SPRITE_ENABLE
		ld	(REG_LAYER), a

		ei

		ld	ix, d_mw_settings
		call	memory_write_handler

		di

		ld	a, $0
		ld	(REG_LAYER), a

		ret

; hl = location in video ram
highlight_cb:
		ld	iy, (r_old_highlight)
		ld	(iy), $0

		ld	bc, $400
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

		ld	iy, r_mw_buffer
		ld	ix, SPRITE_RAM + $200

		ld	b, $4
	.loop_next_byte_sprite:
		ld	a, (iy)
		ld	(ix), a
		inc	ix
		inc	iy
		djnz	.loop_next_byte_sprite
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
