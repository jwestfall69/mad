	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/input_test.inc"

	global input_test

	section code

input_test:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		clr.w	r_irq1_count
		clr.w	r_irq2_count
		clr.w	r_irq3_count

		CPU_INTS_ENABLE

		lea	d_input_test_list, a0
		lea	loop_cb, a1
		jsr	input_test_handler

		CPU_INTS_DISABLE
		rts

loop_cb:
		; triggers MCU to write DSW2 state to $040000
		tst.b	REG_MCU_DSW2

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 8)
		move.w	r_irq1_count, d0
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 9)
		move.w	r_irq2_count, d0
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 10)
		move.w	r_irq3_count, d0
		RSUB	print_hex_word
		rts

	section data
	align 1

d_input_test_list:
	INPUT_TEST_ENTRY REG_INPUT_P1
	INPUT_TEST_ENTRY REG_INPUT_P2
	INPUT_TEST_ENTRY REG_INPUT_DSW1
	INPUT_TEST_ENTRY REG_INPUT_DSW2
	INPUT_TEST_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_Y + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 5), "DSW1"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 6), "DSW2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 8), "IRQ1"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 9), "IRQ2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 10), "IRQ3"
	XY_STRING_LIST_END
