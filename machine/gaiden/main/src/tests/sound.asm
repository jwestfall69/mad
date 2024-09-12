	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"

	include "mad_rom.inc"
	include "machine.inc"

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
	XY_STRING  3, 10, "SOUND NUM:"
	XY_STRING  3, 19, "B1 - PLAY SOUND"
	XY_STRING  3, 20, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END
