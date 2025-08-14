	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/tests/input.inc"

	global input_test

	section code

input_test:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

	.loop_test:
		ld	ix, d_input_list
		call	print_input_list

		GET_INPUT

		xor	$ff
		and	a, INPUT_B2 | INPUT_RIGHT
		cp	a, INPUT_B2 | INPUT_RIGHT
		jr	nz, .loop_test

		di
		ret

	section data

d_input_list:
	INPUT_ENTRY (SCREEN_START_Y + 3), REG_INPUT_P1
	INPUT_ENTRY (SCREEN_START_Y + 4), REG_INPUT_P2
	INPUT_ENTRY (SCREEN_START_Y + 5), REG_INPUT_DSW1
	INPUT_ENTRY (SCREEN_START_Y + 6), REG_INPUT_DSW2
	INPUT_ENTRY (SCREEN_START_Y + 7), REG_INPUT_DSW3
	INPUT_ENTRY (SCREEN_START_Y + 8), REG_INPUT_SYS
	INPUT_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 5), (SCREEN_START_Y + 2), "76543210"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 5), "DSW1"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 6), "DSW2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 7), "DSW2"
	XY_STRING (SCREEN_START_X + 1), (SCREEN_START_Y + 8), "SYS"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 RIGHT - RETURN TO MENU"
	XY_STRING_LIST_END
