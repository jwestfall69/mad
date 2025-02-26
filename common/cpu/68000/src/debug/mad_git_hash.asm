	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "global/include/screen.inc"

	include "input.inc"
	include "machine.inc"

	global mad_git_hash

	section code

mad_git_hash:

		SEEK_XY	SCREEN_START_X, SCREEN_B2_Y
		lea	d_str_b2_return, a0
		RSUB	print_string

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		lea	d_str_git_hash, a0
		RSUB	print_string

		moveq	#INPUT_B2_BIT, d0
		RSUB	wait_button_press
		rts

	section data
	align 2

d_str_b2_return:	STRING "B2 - RETURN TO MENU"
