	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/tests/input.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global input_test

	section code

input_test:
		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

	.loop_test:

		lea	INPUT_LIST, a0
		jsr	print_input_list

		move.b	REG_INPUT_P1, d0
		not.b	d0
		cmp.b	#(P1_B2|P1_RIGHT), d0
		bne	.loop_test

		rts

	section	data
	align 2

INPUT_LIST:
	INPUT_ENTRY  7, REG_INPUT_P1
	INPUT_ENTRY  8, REG_INPUT_P2
	INPUT_ENTRY  9, REG_INPUT_P3
	INPUT_ENTRY 10, REG_INPUT_P4
	INPUT_ENTRY 11, REG_INPUT_DSW1
	INPUT_ENTRY 12, REG_INPUT_DSW2
	INPUT_ENTRY 13, REG_INPUT_DSW3
	INPUT_ENTRY 14, REG_INPUT_SYSTEM
	INPUT_LIST_END

SCREEN_XYS_LIST:
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
