	include "cpu/6x09/include/common.inc"

	ifd _MAME_BUILD_

	global mame_test_disabled

	section code

mame_test_disabled:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		lda	#INPUT_B2
		jsr	wait_button_press
		rts

	section data

d_screen_xys_list:
	ifd _SCREEN_TATE_
		XY_STRING SCREEN_START_X, (SCREEN_PASSES_Y + 2), "MAME BUILD"
		XY_STRING SCREEN_START_X, (SCREEN_PASSES_Y + 3), "TEST DISABLED"
	else
		XY_STRING SCREEN_START_X, (SCREEN_PASSES_Y + 2), "MAME BUILD - TEST DISABLED"
	endif
		XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
		XY_STRING_LIST_END

	endif
