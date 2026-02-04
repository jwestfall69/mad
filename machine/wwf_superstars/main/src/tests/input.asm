	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/input_test.inc"

	global input_test

	section code

input_test:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		moveq	#0, d4		; vblank pulse counter
		clr.w	r_irq5_count
		clr.w	r_irq6_count
		clr.b	r_intput_system_edge
		clr.b	r_input_system_raw

		CPU_INTS_ENABLE

		lea	d_input_test_list, a0
		lea	loop_cb, a1
		jsr	input_test_handler

		CPU_INTS_DISABLE
		rts

loop_cb:
		jsr	input_system_update

		btst	#SYS_VBLANK_BIT, r_intput_system_edge
		beq	.no_vblank
		addq.w	#1, d4

	.no_vblank:
		; timer
		SEEK_XY	(SCREEN_START_X + 19), (SCREEN_START_Y + 3)
		move.w	r_irq5_count, d0
		RSUB	print_hex_word

		; vblank
		SEEK_XY	(SCREEN_START_X + 19), (SCREEN_START_Y + 4)
		move.w	r_irq6_count, d0
		RSUB	print_hex_word

		; vbp
		SEEK_XY (SCREEN_START_X + 19), (SCREEN_START_Y + 5)
		move.w	d4, d0
		RSUB	print_hex_word
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

d_input_test_list:
	INPUT_TEST_ENTRY REG_INPUT_P1
	INPUT_TEST_ENTRY REG_INPUT_P2
	INPUT_TEST_ENTRY REG_INPUT_DSW1
	INPUT_TEST_ENTRY REG_INPUT_DSW2
	INPUT_TEST_ENTRY REG_INPUT_SYSTEM
	INPUT_TEST_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 5), "DSW1"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 6), "DSW2"
	XY_STRING (SCREEN_START_X + 1), (SCREEN_START_Y + 7), "SYS"

	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 3), "IRQ5"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "IRQ6"
	XY_STRING (SCREEN_START_X + 15), (SCREEN_START_Y + 5), "VBP"

	XY_STRING SCREEN_START_X, (SCREEN_B2_Y - 2), "IRQ5 SHOULD BE ABOUT 17X VBP"
	XY_STRING SCREEN_START_X, (SCREEN_B2_Y - 3), "IRQ6 SHOULD EQUAL VBP"
	XY_STRING_LIST_END

	section bss
	align 1

r_intput_system_edge:		dcb.b 1
r_input_system_raw:		dcb.b 1
