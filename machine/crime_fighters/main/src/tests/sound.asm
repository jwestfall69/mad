	include "cpu/konami2/include/common.inc"

	global sound_test

	section code

sound_test:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list
		jsr	print_b2_return_to_menu

		lda	#$50
		jsr	sound_test_handler
		rts

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), <"SOUND NUM", CHAR_COLON>
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 14), "FM SOUNDS STARTS AT 80"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PLAY SOUND"
	XY_STRING_LIST_END
