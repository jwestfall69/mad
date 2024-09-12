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
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		clr.l	r_irq_vblank_count
		move.w	#$2400, sr

	.loop_test:

		lea	d_input_list, a0
		jsr	print_input_list

		SEEK_XY	21, 7
		move.l	r_irq_vblank_count, d0
		RSUB	print_hex_3_bytes

		move.b	REG_INPUT, d0
		not.b	d0
		cmp.b	#(INPUT_B2|INPUT_RIGHT), d0
		bne	.loop_test

		move.w	#$2700, sr
		rts

	section data
	align 2

d_input_list:
	INPUT_ENTRY  7, REG_INPUT_P1
	INPUT_ENTRY  8, REG_INPUT_P2
	INPUT_ENTRY  9, REG_INPUT_DSW1
	INPUT_ENTRY 10, REG_INPUT_DSW2
	INPUT_ENTRY 11, REG_INPUT_SYSTEM
	INPUT_LIST_END

d_screen_xys_list:
	XY_STRING  6,  6, "76543210"
	XY_STRING  3,  7, "P1"
	XY_STRING 17,  7, "VBI"
	XY_STRING  3,  8, "P2"
	XY_STRING  1,  9, "DSW1"
	XY_STRING  1, 10, "DSW2"
	XY_STRING  2, 11, "SYS"
	XY_STRING  3, 20, "P1 B2+RIGHT - RETURN TO MENU"
	XY_STRING_LIST_END
