	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_write.inc"

	global k005849_reg_debug

	section code

k005849_reg_debug:
		ld	de, d_screen_xys_list
		call	print_xy_string_list


		ld	hl, $0
		ld	(r_irq_count), hl
		ld	(r_nmi_count), hl

		ld	a, $0
		ld	(r_reg_control_saved), a

		ei

		ld	hl, TILE_ATTR_RAM
		ld	(r_old_highlight), hl

		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), $0
		ld	(ix + 1), $0
		ld	(ix + 2), $0
		ld	(ix + 3), $42
		ld	(ix + 4), $0
		ld	(ix + 5), $0
		ld	(ix + 6), $0
		ld	(ix + 7), $0

		ld	ix, d_mw_settings
		call	memory_write_handler

		ld	a, CTRL_FIRQ_DISABLE|CTRL_IRQ_DISABLE|CTRL_NMI_DISABLE
		ld	(r_reg_control_saved), a
		ld	(REG_CONTROL), a

		di

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
		ld	iy, r_mw_buffer
		ld	ix, $e040

		ld	a, SCREEN_START_X
		ld	(r_x_offset), a
		ld	b, $8

	.loop_next_byte:
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
		ld	a, (iy)
		ld	(ix), a
		inc	ix
		inc	iy
		pop	bc
		djnz	.loop_next_byte

		ld	a, (r_mw_buffer + 4)
		ld	(r_reg_control_saved), a
		ret

loop_cb:
		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 17)
		ld	bc, (r_irq_count)
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 6), (SCREEN_START_Y + 18)
		ld	bc, (r_nmi_count)
		RSUB	print_hex_word
		ret

	section data

d_mw_settings:		MW_SETTINGS 8, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 15), (SCREEN_START_Y + 2), "ADDR"
	XY_STRING (SCREEN_START_X + 15), (SCREEN_START_Y + 4), "E040"
	XY_STRING (SCREEN_START_X + 15), (SCREEN_START_Y + 5), "E041"
	XY_STRING (SCREEN_START_X + 15), (SCREEN_START_Y + 6), "E042"
	XY_STRING (SCREEN_START_X + 15), (SCREEN_START_Y + 7), "E043"
	XY_STRING (SCREEN_START_X + 15), (SCREEN_START_Y + 8), "E044"
	XY_STRING (SCREEN_START_X + 15), (SCREEN_START_Y + 9), "E045"
	XY_STRING (SCREEN_START_X + 15), (SCREEN_START_Y + 10), "E046"
	XY_STRING (SCREEN_START_X + 15), (SCREEN_START_Y + 11), "E047"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 13), "LAST WRITTEN"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 17), "IRQ"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 18), "NMI"
	XY_STRING_LIST_END

	section bss

r_mw_buffer:		dcb.b 8
r_old_highlight:	dcb.w 1
r_x_offset:		dcb.b 1
