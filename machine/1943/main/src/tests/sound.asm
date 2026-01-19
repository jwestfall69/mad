	include "cpu/z80/include/common.inc"

	global sound_test

	section code

sound_test:
		ld	de, d_screen_xys_list
		call	print_xy_string_list
		call	print_b2_return_to_menu

		ld	a, $1
		ld	b, $7f
		call	sound_test_handler
		ret

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), <"SOUND NUM", CHAR_COLON>
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PLAY SOUND"
	XY_STRING_LIST_END
