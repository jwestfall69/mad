	include "cpu/68000/include/common.inc"

	global mad_git_hash

	section code

mad_git_hash:
		jsr	print_b2_return_to_menu

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		lea	d_str_git_hash, a0
		RSUB	print_string

		moveq	#INPUT_B2_BIT, d0
		RSUB	wait_button_press
		rts
