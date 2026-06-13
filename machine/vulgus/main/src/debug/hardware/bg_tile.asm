	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_write.inc"

	global bg_tile_debug

	section code

HIGHLIGHT_PALETTE_NUM	equ $8

bg_tile_debug:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	hl, FIX_TILE_ATTR
		ld	(r_old_highlight), hl

		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), $f8
		ld	(ix + 1), $80

		ld	ix, d_mw_settings
		call	memory_write_handler
		ret

; hl = location in video ram
highlight_cb:
		ld	iy, (r_old_highlight)
		ld	(iy), $01

		ld	bc, $400
		add	hl, bc
		ld	(hl), HIGHLIGHT_PALETTE_NUM
		ld	(r_old_highlight), hl
		ret

write_memory_cb:
		ld	iy, r_mw_buffer

		ld	a, (iy + 0)
		ld	(BG_TILE + $127), a
		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 15)
		ld	c, a
		RSUB	print_hex_byte

		ld	a, (iy + 1)
		ld	(BG_TILE + $527), a
		SEEK_XY	(SCREEN_START_X + 3), (SCREEN_START_Y + 15)
		ld	c, a
		RSUB	print_hex_byte
		ret

loop_cb:
		ret

	section data

d_mw_settings:		MW_SETTINGS 2, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "TILE NUM"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 5), "TILE ATTR"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 13), "LAST WRITTEN"
	XY_STRING_LIST_END

	section bss

r_mw_buffer:		dcb.b 2
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
