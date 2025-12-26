	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/tests/input.inc"

	global input_test

	section code

input_test:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		CPU_INTS_ENABLE

		; irq 3
		move.b	#$4, $18fa01

		; irq 5
		move.b	#$20, $108001
		move.b	#$10, $108025

		move.w #$0, r_irq3_count
		move.w #$0, r_irq5_count

	.loop_test:

		lea	d_input_list, a0
		jsr	print_input_list

		SEEK_XY	(SCREEN_START_X + 21), (SCREEN_START_Y + 3)
		move.w	r_irq3_count, d0
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 21), (SCREEN_START_Y + 4)
		move.w	r_irq5_count, d0
		RSUB	print_hex_word

		move.b	REG_INPUT, d0
		not.b	d0
		cmp.b	#(INPUT_B2|INPUT_RIGHT), d0
		bne	.loop_test

		move.b	#$0, $18fa01
		move.b	#$0, $108001
		move.b	#$0, $108025

		CPU_INTS_DISABLE

		rts

	section data
	align 1

d_input_list:
	INPUT_ENTRY (SCREEN_START_Y + 3), REG_INPUT_P1
	INPUT_ENTRY (SCREEN_START_Y + 4), REG_INPUT_P2
	INPUT_ENTRY (SCREEN_START_Y + 5), REG_INPUT_P3
	INPUT_ENTRY (SCREEN_START_Y + 6), REG_INPUT_P4
	INPUT_ENTRY (SCREEN_START_Y + 7), REG_INPUT_SYS1
	INPUT_ENTRY (SCREEN_START_Y + 8), REG_INPUT_SYS2
	INPUT_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_Y + 5), (SCREEN_START_Y + 2), "76543210"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 16), (SCREEN_START_Y + 3), "IRQ3"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 16), (SCREEN_START_Y + 4), "IRQ5"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 5), "P3"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 6), "P4"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "SYS1"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 8), "SYS2"
	XY_STRING SCREEN_START_Y, SCREEN_B2_Y, "B2+RIGHT - RETURN TO MENU"
	XY_STRING_LIST_END
