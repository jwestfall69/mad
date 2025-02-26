	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"
	include "global/include/screen.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global mad_git_hash

	section code

mad_git_hash:
		SEEK_XY	SCREEN_START_X, SCREEN_B2_Y
		ldy	#d_str_b2_return
		PSUB	print_string

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 2)
		ldy	#d_str_git_hash
		PSUB	print_string

		lda	#INPUT_B2
		jsr	wait_button_press
		rts

	section data

d_str_b2_return:	STRING "B2 - RETURN TO MENU"
