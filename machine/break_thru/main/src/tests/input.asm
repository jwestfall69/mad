	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/input_test.inc"

	global input_test

	section code

input_test:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		ldd	#$0
		std	r_irq_count
		std	r_nmi_count
		std	r_pulse_vblank_count
		clr	r_input_p2_edge
		clr	r_input_p2_raw

		CPU_INTS_ENABLE

		lda	#(CTRL2_NMI_ENABLE|CTRL2_IRQ_ENABLE)
		sta	REG_CONTROL2
		sta	r_reg_control2_saved

		ldx	#d_input_test_list
		ldy	#loop_cb
		jsr	input_test_handler

		CPU_INTS_DISABLE

		lda	#(CTRL2_NMI_DISABLE|CTRL2_IRQ_DISABLE)
		sta	REG_CONTROL2
		sta	r_reg_control2_saved
		rts

loop_cb:
		jsr	input_p2_update
		lda	r_input_p2_edge
		bita	#INPUT_P2_VBLANK
		beq	.no_vblank

		ldd	r_pulse_vblank_count
		addd	#$1
		std	r_pulse_vblank_count

	.no_vblank:

		SEEK_XY	(SCREEN_START_X + 18), (SCREEN_START_Y + 3)
		ldd	r_pulse_vblank_count
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 18), (SCREEN_START_Y + 4)
		ldd	r_irq_count
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 18), (SCREEN_START_Y + 5)
		ldd	r_nmi_count
		RSUB	print_hex_word
		rts

input_p2_update:
		ldb	r_input_p2_raw
		lda	REG_INPUT_P2
		coma
		sta	r_input_p2_raw

		eorb	r_input_p2_raw
		andb	r_input_p2_raw
		stb	r_input_p2_edge
		rts

	section data

d_input_test_list:
	INPUT_TEST_ENTRY REG_INPUT_P1
	INPUT_TEST_ENTRY REG_INPUT_P2
	INPUT_TEST_ENTRY REG_INPUT_DSW1
	INPUT_TEST_ENTRY REG_INPUT_DSW2
	INPUT_TEST_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 5), "DSW1"
	XY_STRING (SCREEN_START_X + 0), (SCREEN_START_Y + 6), "DSW2"

	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 3), "VBP"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "IRQ"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 5), "NMI"

	XY_STRING SCREEN_START_X, (SCREEN_B2_Y - 3), "VBP SHOULD EQUAL NMI"
	XY_STRING_LIST_END

	section bss
	align 1

r_input_p2_edge:		dcb.b 1
r_input_p2_raw:			dcb.b 1
r_pulse_vblank_count:		dcb.w 1
