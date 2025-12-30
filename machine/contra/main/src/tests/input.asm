	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/tests/input.inc"

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

	.loop_test:
		WATCHDOG

		SEEK_XY	(SCREEN_START_X + 18), (SCREEN_START_Y + 3)
		ldd	r_irq_count
		RSUB	print_hex_word

		ldy	#d_input_list
		jsr	print_input_list

		lda	REG_INPUT
		coma
		anda	#(INPUT_B2 | INPUT_RIGHT)
		cmpa	#(INPUT_B2 | INPUT_RIGHT)
		bne	.loop_test

		lda	#$0
		sta	$0007
		CPU_INTS_DISABLE
		rts

	section data

d_input_list:
	INPUT_ENTRY (SCREEN_START_Y + 3), REG_INPUT_P1
	INPUT_ENTRY (SCREEN_START_Y + 4), REG_INPUT_P2
	INPUT_ENTRY (SCREEN_START_Y + 5), REG_INPUT_DSW1
	INPUT_ENTRY (SCREEN_START_Y + 6), REG_INPUT_DSW2
	INPUT_ENTRY (SCREEN_START_Y + 7), REG_INPUT_DSW3
	INPUT_ENTRY (SCREEN_START_Y + 8), REG_INPUT_SYSTEM
	INPUT_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 5), (SCREEN_START_Y + 2), "76543210"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 3), "IRQ"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "DSW1"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "DSW2"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "DSW3"
	XY_STRING (SCREEN_START_X + 1), (SCREEN_START_Y + 8), "SYS"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 RIGHT - RETURN TO MENU"
	XY_STRING_LIST_END
