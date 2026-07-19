	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/input_test.inc"

	global input_test

	section code

input_test:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		ldd	#$0
		std	r_irq_count
		std	r_firq_count

		CPU_INTS_ENABLE

		ldx	#d_input_test_list
		ldy	#loop_cb
		jsr	input_test_handler

		CPU_INTS_DISABLE

		rts

loop_cb:
		SEEK_XY	(SCREEN_START_X + 19), (SCREEN_START_Y + 3)
		ldd	r_irq_count
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 19), (SCREEN_START_Y + 4)
		ldd	r_firq_count
		RSUB	print_hex_word
		rts

	section data

d_input_test_list:
	INPUT_TEST_ENTRY REG_INPUT_P1
	INPUT_TEST_ENTRY REG_INPUT_P2
	INPUT_TEST_ENTRY REG_INPUT_DSW1
	INPUT_TEST_ENTRY REG_INPUT_DSW2
	INPUT_TEST_ENTRY REG_INPUT_SYS
	INPUT_TEST_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 5), "DSW1"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 6), "DSW2"
	XY_STRING (SCREEN_START_X + 1), (SCREEN_START_Y + 7), "SYS"

	XY_STRING (SCREEN_START_X + 15), (SCREEN_START_Y + 3), "IRQ"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "FIRQ"
	XY_STRING_LIST_END

