	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_write.inc"

	global tile_debug

	section code

tile_debug:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	hl, TILE_ATTR_RAM
		ld	(r_old_highlight), hl

		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), $0a
		ld	(ix + 1), $0e
		ld	(ix + 2), $42	; $e043

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
		ld	($cbcd), a
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 15)
		ld	c, a
		RSUB	print_hex_byte

		ld	a, (r_mw_buffer + 1)
		ld	($c3cd), a
		ld	c, a
		SEEK_XY	(SCREEN_START_X + 3), (SCREEN_START_Y + 15)
		RSUB	print_hex_byte

		ld	a, (r_mw_buffer + 2)
		ld	($e043), a
		ld	c, a
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 17)
		RSUB	print_hex_byte
		ret

loop_cb:
		ret

	section data

d_mw_settings:		MW_SETTINGS 3, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 13), (SCREEN_START_Y + 4), "VIDEO RAM"
	XY_STRING (SCREEN_START_X + 13), (SCREEN_START_Y + 5), "COLOR RAM"
	XY_STRING (SCREEN_START_X + 13), (SCREEN_START_Y + 6), "REG E043"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 13), "LAST WRITTEN"
	XY_STRING_LIST_END

	section bss

r_mw_buffer:		dcb.b 3
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
