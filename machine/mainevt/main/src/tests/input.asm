	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"
	include "cpu/6309/include/tests/input.inc"

	include "input.inc"
	include "machine.inc"

	global input_test

	section code

input_test:
		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list

	.loop_test:
		WATCHDOG

		ldy	#d_input_list
		jsr	print_input_list

		lda	REG_INPUT
		coma
		anda	#(INPUT_B2 | INPUT_RIGHT)
		cmpa	#(INPUT_B2 | INPUT_RIGHT)
		bne	.loop_test

		rts

	section data

d_input_list:
	INPUT_ENTRY  7, REG_INPUT_P1
	INPUT_ENTRY  8, REG_INPUT_P2
	INPUT_ENTRY  9, REG_INPUT_P3
	INPUT_ENTRY 10, REG_INPUT_P4
	INPUT_ENTRY 11, REG_INPUT_DSW1
	INPUT_ENTRY 12, REG_INPUT_DSW2
	INPUT_ENTRY 13, REG_INPUT_DSW3
	INPUT_ENTRY 14, REG_INPUT_SYSTEM
	INPUT_LIST_END

d_screen_xys_list:
	XY_STRING 6,  6, "76543210"
	XY_STRING 3,  7, "P1"
	XY_STRING 3,  8, "P2"
	XY_STRING 3,  9, "P3"
	XY_STRING 3, 10, "P4"
	XY_STRING 1, 11, "DSW1"
	XY_STRING 1, 12, "DSW2"
	XY_STRING 1, 13, "DSW3"
	XY_STRING 2, 14, "SYS"
	XY_STRING 3, 20, "P1 B2+RIGHT - RETURN TO MENU"
	XY_STRING_LIST_END
