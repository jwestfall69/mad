	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/input_test.inc"

	global input_test

	section code

input_test:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		lea	d_input_test_list, a0
		lea	loop_cb, a1
		jsr	input_test_handler
		rts

loop_cb:
		rts

	section data
	align 1

d_input_test_list:
	INPUT_TEST_ENTRY REG_INPUT_P1
	INPUT_TEST_ENTRY REG_INPUT_P2
	INPUT_TEST_ENTRY REG_INPUT_P3
	INPUT_TEST_ENTRY REG_INPUT_P4
	INPUT_TEST_ENTRY REG_INPUT_DSW1
	INPUT_TEST_ENTRY REG_INPUT_DSW2
	INPUT_TEST_ENTRY REG_INPUT_DSW3
	INPUT_TEST_ENTRY REG_INPUT_SYSTEM
	INPUT_TEST_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 5), "P3"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 6), "P4"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 7), "DSW1"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 8), "DSW2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 9), "DSW3"
	XY_STRING (SCREEN_START_X + 1), (SCREEN_START_Y + 10), "SYS"
	XY_STRING_LIST_END
