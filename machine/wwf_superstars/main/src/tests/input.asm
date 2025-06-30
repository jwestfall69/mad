	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/tests/input.inc"

	global input_test

	section code

input_test:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		moveq	#0, d4		; vblank pulse counter
		clr.l	r_irq_timer_count
		clr.l	r_irq_vblank_count
		clr.b	r_intput_system_edge
		clr.b	r_input_system_raw

		INTS_ENABLE

	.loop_test:

		lea	d_input_list, a0
		jsr	print_input_list

		jsr	input_system_update

		btst	#SYS_VBLANK_BIT, r_intput_system_edge
		beq	.no_vblank
		addq.l	#1, d4

	.no_vblank:
		; vbp
		SEEK_XY (SCREEN_START_X + 20), (SCREEN_START_Y + 5)
		move.l	d4, d0
		RSUB	print_hex_3_bytes

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 4)
		move.l	r_irq_vblank_count, d0
		RSUB	print_hex_3_bytes

		SEEK_XY	(SCREEN_START_X + 20), (SCREEN_START_Y + 3)
		move.l	r_irq_timer_count, d0
		RSUB	print_hex_3_bytes

		move.b	REG_INPUT, d0
		not.b	d0
		cmp.b	#(INPUT_B2|INPUT_RIGHT), d0
		bne	.loop_test

		INTS_DISABLE
		rts

input_system_update:
		move.b	REG_INPUT_SYSTEM, d0
		not.b	d0
		move.b	r_input_system_raw, d1
		eor.b	d0, d1
		and.b	d0, d1
		move.b	d1, r_intput_system_edge
		move.b	d0, r_input_system_raw
		rts

	section data
	align 1

d_input_list:
	INPUT_ENTRY (SCREEN_START_Y + 3), REG_INPUT_P1
	INPUT_ENTRY (SCREEN_START_Y + 4), REG_INPUT_P2
	INPUT_ENTRY (SCREEN_START_Y + 5), REG_INPUT_DSW1
	INPUT_ENTRY (SCREEN_START_Y + 6), REG_INPUT_DSW2
	INPUT_ENTRY (SCREEN_START_Y + 7), REG_INPUT_SYSTEM
	INPUT_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 5), (SCREEN_START_Y + 2), "76543210"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 3), "TIMER"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 16), (SCREEN_START_Y + 4), "VBI"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "DSW1"
	XY_STRING (SCREEN_START_X + 16), (SCREEN_START_Y + 5), "VBP"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "DSW2"
	XY_STRING (SCREEN_START_X + 1), (SCREEN_START_Y + 7), "SYS"
	XY_STRING SCREEN_START_X, (SCREEN_B2_Y - 3), "VBI SHOULD EQUAL VBP"
	XY_STRING SCREEN_START_X, (SCREEN_B2_Y - 2), "TIMER SHOULD BE 17X VBI/P"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2+RIGHT - RETURN TO MENU"
	XY_STRING_LIST_END

	section bss
	align 1

r_intput_system_edge:		dcb.b 1
r_input_system_raw:		dcb.b 1
