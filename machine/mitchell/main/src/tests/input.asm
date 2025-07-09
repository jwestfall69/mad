	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/tests/input.inc"

	global input_test

	section code

input_test:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	hl, 0
		ld	(r_irq_count), hl

		ei

	.loop_test:
		SEEK_XY (SCREEN_START_X + 18), (SCREEN_START_Y + 3)
		ld	bc, (r_irq_count)
		RSUB	print_hex_word

		ld	ix, d_input_list
		call	print_input_list

		in	a, (IO_INPUT)
		xor	$ff
		and	a, INPUT_B2 | INPUT_RIGHT
		cp	a, INPUT_B2 | INPUT_RIGHT
		jr	nz, .loop_test

		di
		ret

	section data

d_input_list:
	INPUT_ENTRY (SCREEN_START_Y + 3), IO_INPUT_P1
	INPUT_ENTRY (SCREEN_START_Y + 4), IO_INPUT_P2
	INPUT_ENTRY (SCREEN_START_Y + 5), IO_INPUT_SYS1
	INPUT_ENTRY (SCREEN_START_Y + 6), IO_INPUT_SYS2
	INPUT_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 5), (SCREEN_START_Y + 2), "76543210"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 3), "IRQ"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 5), "SYS1"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 6), "SYS2"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 RIGHT - RETURN TO MENU"
	XY_STRING_LIST_END
