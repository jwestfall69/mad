	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/xy_string.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global sound_test

	section code

sound_test:
		lea	SOUND_XYS_LIST, a0
		RSUB	print_xy_string_list

		lea	menu_input_generic, a0
		moveq	#$22, d0
		jsr	sound_test_handler
		rts

	section	data

SOUND_XYS_LIST:
	XY_STRING  3, 10, "SOUND NUM:"
;	XY_STRING  3, 19, "B1 - PLAY SOUND"
	XY_STRING  3, 19, "SOUND NOT SETUP"
	XY_STRING  3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
