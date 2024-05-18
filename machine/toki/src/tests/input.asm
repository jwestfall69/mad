	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/xy_string.inc"
	include "cpu/68000/tests/input.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global input_test

	section code

input_test:
		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

	.loop_test:

		; Input/dsw registers are a bit weird on hardware.
		; You can do a byte read on odd address registers
		; and get valid data, but if you do the same on even
		; address registers you get garbage.  In order to get
		; valid data from the even ones the read must be a word.
		; So we can't use the common input display.


		; p2 inputs will be in high byte, p1 in low
		move.w	REG_INPUT_P2, d0
		not.w	d0

		SEEK_XY	6, 7
		movem.w	d0, -(a7)
		RSUB	print_bits_byte
		movem.w	(a7)+, d0

		SEEK_XY	6, 8
		lsr.w	#$8, d0
		RSUB	print_bits_byte

		; dsw2 will be in high byte, dsw1 in low
		move.w	REG_INPUT_DSW2, d0
		not.w	d0

		SEEK_XY	6, 9
		movem.w	d0, -(a7)
		RSUB	print_bits_byte
		movem.w	(a7)+, d0

		SEEK_XY	6, 10
		lsr.w	#$8, d0
		RSUB	print_bits_byte

		; odd address, byte read is ok
		move.b	REG_INPUT_SYSTEM, d0
		not.b	d0
		SEEK_XY	6, 11
		RSUB	print_bits_byte

		; p1/system are both odd addresses, byte read is ok
		move.b	REG_INPUT_P1, d0
		not.b	d0
		and.b	#P1_B2, d0
		move.b	REG_INPUT_SYSTEM, d1
		not.b	d1
		and.b	#SYS_START1, d1
		or.b	d1, d0
		cmp.b	#(P1_B2|SYS_START1), d0
		bne	.loop_test

		rts

	section	data

	align 2

SCREEN_XYS_LIST:
	XY_STRING  6,  6, "76543210"
	XY_STRING  3,  7, "P1"
	XY_STRING  3,  8, "P2"
	XY_STRING  1,  9, "DSW1"
	XY_STRING  1, 10, "DSW2"
	XY_STRING  2, 11, "SYS"
	XY_STRING  3, 20, "P1 B2+START - RETURN TO MENU"
	XY_STRING_LIST_END
