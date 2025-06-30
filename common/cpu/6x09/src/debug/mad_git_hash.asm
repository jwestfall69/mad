	include "cpu/6x09/include/common.inc"

	global mad_git_hash

	section code

mad_git_hash:
		SEEK_XY	SCREEN_START_X, SCREEN_B2_Y
		ldy	#d_str_b2_return
		RSUB	print_string

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 2)
		ldy	#d_str_git_hash
		RSUB	print_string

		lda	#INPUT_B2
		jsr	wait_button_press
		rts

	section data

d_str_b2_return:	STRING "B2 - RETURN TO MENU"
