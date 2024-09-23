	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "global/include/screen.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global sound_test

	section code

sound_test:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		moveq	#$22, d0
		jsr	sound_test_handler
		rts

	section data
	align 2

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), <"SOUND NUM", CHAR_COLON>
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PLAY SOUND"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
