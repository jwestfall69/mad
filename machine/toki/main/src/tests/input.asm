	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "cpu/68000/include/tests/input.inc"
	include "global/include/screen.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global input_test

	section code

input_test:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

	.loop_test:

		; Input/dsw registers are a bit weird on hardware.
		; You can do a byte read on odd address registers
		; and get valid data, but if you do the same on even
		; address registers you get garbage.  In order to get
		; valid data from the even ones the read must be a word.
		; So we can't use the common input display.


		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 3)
		; p2 inputs will be in high byte, p1 in low
		move.w	REG_INPUT_P2, d0
		not.w	d0
		movem.w	d0, -(a7)
		RSUB	print_bits_byte
		movem.w	(a7)+, d0

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 4)
		lsr.w	#$8, d0
		RSUB	print_bits_byte

		; dsw2 will be in high byte, dsw1 in low
		move.w	REG_INPUT_DSW2, d0
		not.w	d0

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 5)
		movem.w	d0, -(a7)
		RSUB	print_bits_byte
		movem.w	(a7)+, d0

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 6)
		lsr.w	#$8, d0
		RSUB	print_bits_byte

		SEEK_XY	(SCREEN_START_X + 5), (SCREEN_START_Y + 7)
		; odd address, byte read is ok
		move.b	REG_INPUT_SYSTEM, d0
		not.b	d0
		RSUB	print_bits_byte

		; p1/system are both odd addresses, byte read is ok
		move.b	REG_INPUT, d0
		not.b	d0
		cmp.b	#(INPUT_B2|INPUT_RIGHT), d0
		bne	.loop_test

		rts

	section data
	align 1

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 5), (SCREEN_START_Y + 2), "76543210"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "DSW1"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "DSW2"
	XY_STRING (SCREEN_START_X + 1), (SCREEN_START_Y + 7), "SYS"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2+RIGHT - RETURN TO MENU"
	XY_STRING_LIST_END
