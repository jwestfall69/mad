	include "cpu/68000/include/common.inc"

	global sound_test

	section code

sound_test:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list
		jsr	print_b2_return_to_menu

		moveq	#0, d0
		lea	sound_play_cb, a0
		lea	sound_stop_cb, a1
		jsr	sound_test_handler
		rts

sound_play_cb:
		SOUND_PLAY
		rts

sound_stop_cb:
		SOUND_STOP
		rts

	section data
	align 1

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), <"SOUND NUM", CHAR_COLON>
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PLAY SOUND"
	XY_STRING_LIST_END
