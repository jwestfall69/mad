	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/input_test.inc"

	global input_test

	section code

input_test:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		ld	ix, d_input_test_list
		ld	iy, loop_cb
		call	input_test_handler
		ret

loop_cb:
		ret

	section data

d_input_test_list:
	INPUT_TEST_ENTRY REG_INPUT_P1
	INPUT_TEST_ENTRY REG_INPUT_P2
	INPUT_TEST_ENTRY REG_INPUT_DSW1
	INPUT_TEST_ENTRY REG_INPUT_DSW2
	INPUT_TEST_ENTRY REG_INPUT_DSW3
	INPUT_TEST_ENTRY REG_INPUT_SYS
	INPUT_TEST_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 5), "DSW1"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 6), "DSW2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 7), "DSW2"
	XY_STRING (SCREEN_START_X + 1), (SCREEN_START_Y + 8), "SYS"
	XY_STRING_LIST_END
