	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"

	include "mad_rom.inc"
	include "machine.inc"

	global sound_test

	section code

sound_test:
		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		lea	menu_input_generic, a0
		moveq	#0, d0
		jsr	sound_test_handler
		rts

	section	data

SCREEN_XYS_LIST:
	XY_STRING  3, 10, "SOUND NUM:"
	XY_STRING  3, 19, "B1 - PLAY SOUND"
	XY_STRING  3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
