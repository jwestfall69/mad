	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/tests/input.inc"

	include "input.inc"
	include "mad_rom.inc"
	include "machine.inc"

	global input_test

	section code

input_test:
		lea	INPUT_XYS_LIST, a0
		RSUB	print_xy_string_list

		clr.l	INTERRUPT_IRQ1_COUNT
		clr.l	INTERRUPT_IRQ2_COUNT
		clr.l	INTERRUPT_IRQ3_COUNT

		INTS_ENABLE

	.loop_test:

		; triggers MCU to write DSW2 state to $040000
		tst.b	REG_MCU_DSW2

		lea	INPUT_LIST, a0
		jsr	print_input_list

		SEEK_XY	20, 7
		move.l	INTERRUPT_IRQ1_COUNT, d0
		RSUB	print_hex_3_bytes

		SEEK_XY	20, 8
		move.l	INTERRUPT_IRQ2_COUNT, d0
		RSUB	print_hex_3_bytes

		SEEK_XY	20, 9
		move.l	INTERRUPT_IRQ3_COUNT, d0
		RSUB	print_hex_3_bytes

		move.b	REG_INPUT, d0
		not.b	d0
		cmp.b	#(INPUT_B2|INPUT_RIGHT), d0
		bne	.loop_test

		INTS_DISABLE
		rts

	section	data
	align 2

INPUT_LIST:
	INPUT_ENTRY  7, REG_INPUT_P1
	INPUT_ENTRY  8, REG_INPUT_P2
	INPUT_ENTRY  9, REG_INPUT_DSW1
	INPUT_ENTRY 10, REG_INPUT_DSW2
	INPUT_LIST_END

INPUT_XYS_LIST:
	XY_STRING  6,  6, "76543210"
	XY_STRING  3,  7, "P1"
	XY_STRING 15,  7, "IRQ1"
	XY_STRING  3,  8, "P2"
	XY_STRING 15,  8, "IRQ2"
	XY_STRING  1,  9, "DSW1"
	XY_STRING 15,  9, "IRQ3"
	XY_STRING  1, 10, "DSW2"
	XY_STRING  3, 20, "P1 B2+R - RETURN TO MENU"
	XY_STRING_LIST_END
