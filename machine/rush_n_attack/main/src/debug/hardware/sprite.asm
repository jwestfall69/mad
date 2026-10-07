	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	hl, TILE_ATTR_RAM
		ld	(r_old_highlight), hl

		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), $3f
		ld	(ix + 1), $0
		ld	(ix + 2), $b0
		ld	(ix + 3), $50
		ld	(ix + 4), $42	; $e043

		ld	ix, d_mw_settings
		call	memory_write_handler

		ld	a, $42
		ld	($e043), a
		ret

; hl = location in video ram
highlight_cb:
		ld	iy, (r_old_highlight)
		ld	a, $0a
		ld	(iy), a

		ld	bc, $800
		or	a	; clear carry
		sbc	hl, bc
		ld	a, $04
		ld	(hl), a
		ld	(r_old_highlight), hl
		ret

write_memory_cb:
		ld	a, (r_mw_buffer)
		ld	(SPRITE_RAM), a

		inc	a
		ld	(SPRITE_RAM + $100), a
		dec	a

		ld	c, a
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		ld	a, (r_mw_buffer + 1)
		ld	(SPRITE_RAM + 1), a
		ld	(SPRITE_RAM + $100 + 1), a

		ld	c, a
		SEEK_XY	(SCREEN_START_X + 3), (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		ld	a, (r_mw_buffer + 2)
		ld	(SPRITE_RAM + 2), a

		add	a, $10
		ld	(SPRITE_RAM + $100 + 2), a
		sub	$10

		ld	c, a
		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		ld	a, (r_mw_buffer + 3)
		ld	(SPRITE_RAM + 3), a
		ld	(SPRITE_RAM + $100 + 3), a

		ld	c, a
		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		ld	a, (r_mw_buffer + 4)
		ld	($e043), a
		ld	c, a
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 17)
		RSUB	print_hex_byte
loop_cb:
		ret

	section data

d_mw_settings:		MW_SETTINGS 5, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 13), (SCREEN_START_Y + 8), "REG E043"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 13), "LAST WRITTEN"
	XY_STRING_LIST_END

	section bss

r_mw_buffer:		dcb.b 5
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
