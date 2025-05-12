	include "global/include/screen.inc"
	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"
	include "cpu/konami2/include/xy_string.inc"

	include "machine.inc"
	include "mad.inc"

	global sound_test

	section code

sound_test:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		lda	#$1
		jsr	sound_test_handler
		rts

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), <"SOUND NUM", CHAR_COLON>
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PLAY SOUND"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
