	include "cpu/konami2/include/common.inc"

	global prog_bank_test

	section code

prog_bank_test:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

	.loop_input:
		WATCHDOG
		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_B1
		beq	.b1_not_pressed
		jsr	run_test
		bra	.loop_input

	.b1_not_pressed:
		bita	#INPUT_B2
		beq	.loop_input

		setln	#$0
		rts



; The prog bank size is only $4000, so we can just use mad's normal
; mirror numbers at $7fef
PROG_BANK_MAX		equ $6
run_test:

		; re-init the screen in the even the user runs the
		; test multiple times
		RSUB	screen_init
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		clra
		sta	r_bank
		lda	#$7
		sta	r_mirror

	.loop_next_mirror:
		lda	r_mirror
		setln	r_bank
		ldb	$7fef
		cmpa	$7fef
		bne	.test_failed

		inc	r_bank
		dec	r_mirror

		lda	#PROG_BANK_MAX
		cmpa	r_bank
		bgt	.loop_next_mirror

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 3)
		ldy	#d_str_test_passed
		RSUB	print_string
		rts

	.test_failed:
		pshs	b
		ldy	#d_screen_xys_test_failed_list
		jsr	print_xy_string_list

		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 5)
		lda	r_bank
		RSUB	print_hex_byte

		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 6)
		lda	r_mirror
		RSUB	print_hex_byte

		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 7)
		puls	a
		RSUB	print_hex_byte
		rts


	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "PROG BANK TEST"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 RUN TEST"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 RETURN TO MENU"
	XY_STRING_LIST_END

d_screen_xys_test_failed_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "TEST FAILED"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "BANK"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "EXPECTED"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "ACTUAL"
	XY_STRING_LIST_END

d_str_test_passed:	STRING "TEST PASSED"

	section bss

r_bank:		dcb.b 1
r_mirror:	dcb.b 1

