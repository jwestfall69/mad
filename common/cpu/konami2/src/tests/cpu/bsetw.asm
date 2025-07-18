	include "cpu/konami2/include/common.inc"

	global	bsetw_test

	section code

bsetw_test:
		ldy	#d_xys_screen_list
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
		rts

run_test:

		ldd	#$0
		std	r_dst_data
		std	r_dst_data + 2
		std	r_dst_data + 4

		ldd	#$eaed
		std	r_dst_data + 6


		ldd	#$3e4f
		ldu	#$3
		ldx	#r_dst_data

		bsetw

		SEEK_XY (SCREEN_START_X + 1), (SCREEN_START_Y + 12)
		ldd	r_dst_data
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 6), (SCREEN_START_Y + 12)
		ldd	r_dst_data + 2
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 11), (SCREEN_START_Y + 12)
		ldd	r_dst_data + 4
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 11), (SCREEN_START_Y + 14)
		ldd	r_dst_data + 6
		RSUB	print_hex_word

		rts

	section data

d_xys_screen_list:
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "DATA SHOULD ALL BE 3E4F"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 11), "DATA"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 14), "WORD AFTER"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 15), "SHOULD BE EAED"
		XY_STRING SCREEN_START_X, SCREEN_B1_Y, " B1 - RUN TEST"
		XY_STRING SCREEN_START_X, SCREEN_B2_Y, " B2 - RETURN TO MENU"
		XY_STRING_LIST_END

	section bss

r_dst_data:	dcb.w	4

