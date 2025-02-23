	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/tests/input.inc"
	include "global/include/screen.inc"

	include "input.inc"
	include "mad.inc"
	include "machine.inc"

	global input_test

	section code

input_test:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		clr.l	r_irq_vblank_count
		INTS_ENABLE

	.loop_test:

		lea	d_input_list, a0
		jsr	print_input_list

		SEEK_XY	(SCREEN_START_X + 18), (SCREEN_START_Y + 3)
		move.l	r_irq_vblank_count, d0
		RSUB	print_hex_3_bytes

		move.b	REG_INPUT, d0
		not.b	d0
		cmp.b	#(INPUT_B2|INPUT_RIGHT), d0
		bne	.loop_test

		INTS_DISABLE
		rts

	section data
	align 2

d_input_list:
	INPUT_ENTRY (SCREEN_START_Y + 3), REG_INPUT_P1
	INPUT_ENTRY (SCREEN_START_Y + 4), REG_INPUT_P2
	INPUT_ENTRY (SCREEN_START_Y + 5), REG_INPUT_DSW1
	INPUT_ENTRY (SCREEN_START_Y + 6), REG_INPUT_DSW2
	INPUT_ENTRY (SCREEN_START_Y + 7), REG_INPUT_SYSTEM
	INPUT_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_Y + 5), (SCREEN_START_Y + 2), "76543210"
	XY_STRING (SCREEN_START_Y + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_Y + 14), (SCREEN_START_Y + 3), "VBI"
	XY_STRING (SCREEN_START_Y + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING SCREEN_START_Y, (SCREEN_START_Y + 5), "DSW1"
	XY_STRING SCREEN_START_Y, (SCREEN_START_Y + 6), "DSW2"
	XY_STRING (SCREEN_START_Y + 1), (SCREEN_START_Y + 7), "SYS"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2+RIGHT - RETURN TO MENU"
	XY_STRING_LIST_END
