	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "mad_rom.inc"
	include "machine.inc"

	global sound_test

	section code

sound_test:
		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list

		lda	#$1
		jsr	sound_test_handler
		rts

	section data

d_screen_xys_list:
	XY_STRING 3, 10, "SOUND NUM:"
	XY_STRING 3, 19, "B1 - PLAY SOUND"
	XY_STRING 3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
