	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/input_test.inc"

	global input_test

	section code

input_test:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		clrd
		std	r_irq_count

		; tell K007121#1 to allow interrupts to flow
		lda	#$2
		sta	$0007
		CPU_INTS_ENABLE

		ldx	#d_input_test_list
		ldy	#loop_cb
		jsr	input_test_handler

		lda	#$0
		sta	$0007
		CPU_INTS_DISABLE
		rts


loop_cb:
		SEEK_XY	(SCREEN_START_X + 18), (SCREEN_START_Y + 3)
		ldd	r_irq_count
		RSUB	print_hex_word
		rts

	section data

d_input_test_list:
	INPUT_TEST_ENTRY REG_INPUT_P1
	INPUT_TEST_ENTRY REG_INPUT_P2
	INPUT_TEST_ENTRY REG_INPUT_DSW1
	INPUT_TEST_ENTRY REG_INPUT_DSW2
	INPUT_TEST_ENTRY REG_INPUT_DSW3
	INPUT_TEST_ENTRY REG_INPUT_SYSTEM
	INPUT_TEST_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 5), "DSW1"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 6), "DSW2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 7), "DSW3"
	XY_STRING (SCREEN_START_X + 1), (SCREEN_START_Y + 8), "SYS"

	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 3), "IRQ"
	XY_STRING_LIST_END
