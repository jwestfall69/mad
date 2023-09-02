	include "cpu/68000/dsub.inc"
	include "cpu/68000/input.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/xy_string.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global input_test

	section code

input_test:
		lea	INPUT_XYS_LIST, a0
		RSUB	print_xy_string_list

		moveq	#0, d4		; vblank pulse counter
		clr.l	INTERRUPT_VBLANK_COUNT

		move.w	#$2400, sr

	.loop_test:

		lea	INPUT_LIST, a0
		jsr	print_input_list

		jsr	input_system_update

		btst	#SYS_VBLANK_BIT, INPUT_SYSTEM_EDGE
		beq	.no_vblank
		addq.l	#1, d4

	.no_vblank:
		SEEK_XY 21, 8
		move.l	d4, d0
		RSUB	print_hex_3_bytes

		SEEK_XY	21, 7
		move.l	INTERRUPT_VBLANK_COUNT, d0
		RSUB	print_hex_3_bytes

		move.b	REG_INPUT_P1, d0
		not.b	d0
		and.b	#(P1_B2), d0
		move.b	REG_INPUT_SYSTEM, d1
		not.b	d1
		and.b	#(SYS_START1), d1
		or.b	d1, d0
		cmp.b	#(P1_B2|SYS_START1), d0
		bne	.loop_test

		move.w	#$2700, sr
		rts

	section	data

INPUT_LIST:
	INPUT_ENTRY  7, REG_INPUT_P1
	INPUT_ENTRY  8, REG_INPUT_P2
	INPUT_ENTRY  9, REG_INPUT_DSW1
	INPUT_ENTRY 10, REG_INPUT_DSW2
	INPUT_ENTRY 11, REG_INPUT_SYSTEM
	INPUT_ENTRY_LIST_END

INPUT_XYS_LIST:
	XY_STRING  6,  6, "76543210"
	XY_STRING  3,  7, "P1"
	XY_STRING 17,  7, "VBI"
	XY_STRING  3,  8, "P2"
	XY_STRING 17,  8, "VBP"
	XY_STRING  1,  9, "DSW1"
	XY_STRING  1, 10, "DSW2"
	XY_STRING  2, 11, "SYS"
	XY_STRING  3, 20, "P1 B2+START - RETURN TO MENU"
	XY_STRING_LIST_END
