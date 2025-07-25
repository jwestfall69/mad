	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/tests/input.inc"

	global input_test

	section code

input_test:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		clr.l	r_irq_vblank_count
		INTS_ENABLE

	.loop_test:

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 3)
		move.l	r_irq_vblank_count, d0
		RSUB	print_hex_3_bytes

		SEEK_XY (SCREEN_START_X + 20), (SCREEN_START_Y + 4)
		moveq	#0, d0
		move.w	REGB_SCANLINE, d0
		RSUB	print_hex_3_bytes

		lea	d_input_list, a0
		jsr	print_input_list

		move.b	REG_INPUT, d0
		not.b	d0
		cmp.b	#(INPUT_B2|INPUT_RIGHT), d0
		bne	.loop_test

		INTS_DISABLE
		rts

	section data
	align 1

d_input_list:
	INPUT_ENTRY (SCREEN_START_Y + 3), REG_INPUT_P1
	INPUT_ENTRY (SCREEN_START_Y + 4), REG_INPUT_P2
	INPUT_ENTRY (SCREEN_START_Y + 5), REG_INPUT_P3
	INPUT_ENTRY (SCREEN_START_Y + 6), REG_INPUT_P4
	INPUT_ENTRY (SCREEN_START_Y + 7), REG_INPUT_SYSTEM1
	INPUT_ENTRY (SCREEN_START_Y + 8), REG_INPUT_SYSTEM2
	INPUT_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 5), (SCREEN_START_Y + 2), "76543210"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 16), (SCREEN_START_Y + 3), "VBI"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 17), (SCREEN_START_Y + 4), "SL"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 5), "P3"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 6), "P4"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "SYS1"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 8), "SYS2"
	ifd _SCREEN_TATE_
		XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2+R - RETURN TO MENU"
	else
		XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2+RIGHT - RETURN TO MENU"
	endif
	XY_STRING_LIST_END
