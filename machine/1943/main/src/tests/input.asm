	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/tests/input.inc"

	global input_test

	section code

input_test:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	hl, 0
		ld	(r_irq_count), hl
		ld	(r_pulse_vblank_count), hl
		ld	a, 0
		ld	(r_input_sys_edge), a
		ld	(r_input_sys_raw), a

		ei

	.loop_test:
		ld	ix, d_input_list
		call	print_input_list

		call	input_sys_update
		ld	a, (r_input_sys_edge)
		bit	SYS_VBLANK_BIT, a
		jr	z, .no_vblank

		ld	hl, (r_pulse_vblank_count)
		inc	hl
		ld	(r_pulse_vblank_count), hl

	.no_vblank:
		SEEK_XY (SCREEN_START_X + 18), (SCREEN_START_Y + 3)
		ld	bc, (r_irq_count)
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 18), (SCREEN_START_Y + 4)
		ld	bc, (r_pulse_vblank_count)
		RSUB	print_hex_word

		GET_INPUT
		xor	$ff
		and	a, INPUT_B2 | INPUT_RIGHT
		cp	a, INPUT_B2 | INPUT_RIGHT
		jr	nz, .loop_test

		di
		ret

input_sys_update:
		ld	a, (REG_INPUT_SYS)
		xor	$ff
		ld	b, a
		ld	a, (r_input_sys_raw)
		xor	b
		and	b
		ld	(r_input_sys_edge), a
		ld	a, b
		ld	(r_input_sys_raw), a
		ret

	section data

d_input_list:
	INPUT_ENTRY (SCREEN_START_Y + 3), REG_INPUT_P1
	INPUT_ENTRY (SCREEN_START_Y + 4), REG_INPUT_P2
	INPUT_ENTRY (SCREEN_START_Y + 5), REG_INPUT_DSW1
	INPUT_ENTRY (SCREEN_START_Y + 6), REG_INPUT_DSW2
	INPUT_ENTRY (SCREEN_START_Y + 7), REG_INPUT_SYS
	INPUT_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 5), (SCREEN_START_Y + 2), "76543210"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 3), "IRQ"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "VBP"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 5), "DSW1"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 6), "DSW2"
	XY_STRING (SCREEN_START_X + 1), (SCREEN_START_Y + 7), "SYS"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 RIGHT - RETURN TO MENU"
	XY_STRING_LIST_END

	section bss

r_input_sys_edge:		dcb.b 1
r_input_sys_raw:		dcb.b 1
r_pulse_vblank_count:		dcb.w 1
