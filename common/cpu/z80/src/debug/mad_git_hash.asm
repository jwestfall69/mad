	include "cpu/z80/include/common.inc"

	global mad_git_hash

	section code

mad_git_hash:
		SEEK_XY	SCREEN_START_X, SCREEN_B2_Y
		ld	de, d_str_b2_return
		RSUB	print_string

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 2)
		ld	de, d_str_git_hash
		RSUB	print_string

		ld	b, INPUT_B2
		call	wait_button_press
		ret

	section data

d_str_b2_return:	STRING "B2 - RETURN TO MENU"
