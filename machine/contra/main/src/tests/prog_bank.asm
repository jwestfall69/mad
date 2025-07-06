	include "cpu/6309/include/common.inc"

	global prog_bank_test

	section code

prog_bank_test:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list
		jsr	print_b2_return_to_menu

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

		clr	REG_CONTROL
		rts



; The prog bank size is only $2000, but the diag rom mirror sizes
; are $4000.  The diag rom is setup so the mirror # exists at the
; $6000 and the $1fef byte of each mirror.  So for even prog banks
; we need to look at $6000 and odd banks $7fed
PROG_BANK_MAX		equ $b
run_test:

		; re-init the screen in the even the user runs the
		; test multiple times
		RSUB	screen_init
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		lda	#$8
		sta	r_bank
		lda	#$3
		sta	r_mirror

	.loop_next_mirror:

		; even bank
		lda	r_bank
		sta	REG_CONTROL
		ldb	$6000
		lda	r_mirror
		cmpa	$6000
		bne	.test_failed

		; odd bank
		inc	r_bank
		ldb	r_bank
		stb	REG_CONTROL
		ldb	$7fed
		cmpa	$7fed
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
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - RUN TEST"
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

