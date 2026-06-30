	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/input_test.inc"

	global input_test

	section code

input_test:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		clr.w	r_irq2_count
		clr.w	r_irq4_count

		lea	d_input_test_list, a0
		lea	loop_cb, a1

		CPU_INTS_ENABLE

		jsr	input_test_handler

		CPU_INTS_DISABLE

		rts

loop_cb:
		SEEK_XY	(SCREEN_START_X + 19), (SCREEN_START_Y + 3)
		move.w	r_irq2_count, d0
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 19), (SCREEN_START_Y + 4)
		move.w	r_irq4_count, d0
		RSUB	print_hex_word
		rts

	section data
	align 1

d_input_test_list:
	INPUT_TEST_ENTRY REG_INPUT_P12
	INPUT_TEST_ENTRY (REG_INPUT_P12 + 1)
	INPUT_TEST_ENTRY REG_INPUT_DSW1
	INPUT_TEST_ENTRY REG_INPUT_DSW2
	INPUT_TEST_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "P12A"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "P12B"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "DSW1"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "DSW2"

	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 3), "IRQ2"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "IRQ4"
	XY_STRING_LIST_END
