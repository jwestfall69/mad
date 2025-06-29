	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"
	include "cpu/6x09/include/xy_string.inc"
	include "cpu/6x09/include/tests/input.inc"

	include "cpu/6309/include/dsub.inc"

	include "input.inc"
	include "machine.inc"

	global input_test

	section code

input_test:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		clrd
		std	r_irq_vblank_count
		std	r_pulse_vblank_count
		clr	r_input_dsw1_edge
		clr	r_input_dsw1_raw

	; enable NMIs
	ifd _MAME_BUILD_
		lda	#CTRL_NMI
	else
		lda	#(CTRL_NMI|CTRL_SCREEN_FLIP)
	endif
		sta	REG_CONTROL

	.loop_test:
		ldy	#d_input_list
		jsr	print_input_list

		jsr	input_dsw1_update
		lda	r_input_dsw1_edge
		bita	#DSW1_VBLANK
		beq	.no_vblank

		ldd	r_pulse_vblank_count
		incd
		std	r_pulse_vblank_count

	.no_vblank:

		SEEK_XY	(SCREEN_START_X + 18), (SCREEN_START_Y + 3)
		ldd	r_irq_vblank_count
		RSUB	print_hex_word

		SEEK_XY	(SCREEN_START_X + 18), (SCREEN_START_Y + 4)
		ldd	r_pulse_vblank_count
		RSUB	print_hex_word


		lda	REG_INPUT
		coma
		anda	#(INPUT_B2 | INPUT_RIGHT)
		cmpa	#(INPUT_B2 | INPUT_RIGHT)
		bne	.loop_test

		; disable NMI's
	ifd _MAME_BUILD_
		clr	REG_CONTROL
	else
		lda	#CTRL_SCREEN_FLIP
		sta	REG_CONTROL
	endif

		rts

input_dsw1_update:
		lda	REG_INPUT_DSW1
		coma
		ldb	r_input_dsw1_raw

		eorr	a, b
		andr	a, b
		stb	r_input_dsw1_edge
		sta	r_input_dsw1_raw
		rts

	section data

d_input_list:
	INPUT_ENTRY (SCREEN_START_Y + 3), REG_INPUT_P1
	INPUT_ENTRY (SCREEN_START_Y + 4), REG_INPUT_P2
	INPUT_ENTRY (SCREEN_START_Y + 5), REG_INPUT_P3
	INPUT_ENTRY (SCREEN_START_Y + 6), REG_INPUT_DSW1
	INPUT_ENTRY (SCREEN_START_Y + 7), REG_INPUT_DSW2
	INPUT_LIST_END

d_screen_xys_list:
	XY_STRING (SCREEN_START_X + 5), (SCREEN_START_Y + 2), "76543210"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 3), "P1"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 3), "VBI"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 4), "P2"
	XY_STRING (SCREEN_START_X + 14), (SCREEN_START_Y + 4), "VBP"
	XY_STRING (SCREEN_START_X + 2), (SCREEN_START_Y + 5), "P3"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "DSW1"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "DSW2"
	XY_STRING SCREEN_START_X, (SCREEN_B2_Y - 3), "VBI SHOULD EQUAL VBP"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2+RIGHT - RETURN TO MENU"
	XY_STRING_LIST_END

	section bss
	align 1

r_input_dsw1_edge:		dcb.b 1
r_input_dsw1_raw:		dcb.b 1
r_pulse_vblank_count:		dcb.w 1
