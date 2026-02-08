	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/input_test.inc"

	global input_test

	section code

input_test:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	hl, 0
		ld	(r_irq_count), hl
		ld	(r_nmi_count), hl

		ld	a, CTRL_RS_BASE|CTRL_NMI_ENABLE|CTRL_SND_RESET_OFF
		ld	(REG_CONTROL), a
		ei

		ld	ix, d_input_test_list
		ld	iy, loop_cb
		call	input_test_handler

		ld	a, CTRL_RS_BASE|CTRL_NMI_DISABLE|CTRL_SND_RESET_OFF
		ld	(REG_CONTROL), a
		di
		ret

loop_cb:
		SEEK_XY (SCREEN_START_X + 18), (SCREEN_START_Y + 3)
		ld	bc, (r_nmi_count)
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 18), (SCREEN_START_Y + 4)
		ld	bc, (r_irq_count)
		RSUB	print_hex_word
		ret

	section data

d_input_test_list:
	INPUT_TEST_ENTRY REG_INPUT_P1
	INPUT_TEST_ENTRY REG_INPUT_P2
	INPUT_TEST_ENTRY REG_INPUT_DSW1
	INPUT_TEST_ENTRY REG_INPUT_DSW2
	INPUT_TEST_ENTRY REG_INPUT_SYS
	INPUT_TEST_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 5), "DSW1"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 6), "DSW2"
	XY_STRING (SCREEN_START_X + 1), (SCREEN_START_Y + 7), "SYS"

	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 3), "NMI"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "IRQ"
	XY_STRING_LIST_END
