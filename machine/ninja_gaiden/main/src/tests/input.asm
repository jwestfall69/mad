	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/tests/input.inc"

	global input_test

	section code

input_test:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		clr.w	r_irq5_count
		CPU_INTS_ENABLE

	.loop_test:

		lea	d_input_list, a0
		jsr	print_input_list

		SEEK_XY	(SCREEN_START_X + 19), (SCREEN_START_Y + 3)
		move.w	r_irq5_count, d0
		RSUB	print_hex_word

		move.b	REG_INPUT, d0
		not.b	d0
		cmp.b	#(INPUT_B2|INPUT_RIGHT), d0
		bne	.loop_test

		CPU_INTS_DISABLE
		rts

	section data
	align 1

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
	XY_STRING (SCREEN_START_Y + 14), (SCREEN_START_Y + 3), "IRQ5"
	XY_STRING (SCREEN_START_Y + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING SCREEN_START_Y, (SCREEN_START_Y + 5), "DSW1"
	XY_STRING SCREEN_START_Y, (SCREEN_START_Y + 6), "DSW2"
	XY_STRING (SCREEN_START_Y + 1), (SCREEN_START_Y + 7), "SYS"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2+RIGHT - RETURN TO MENU"
	XY_STRING_LIST_END
