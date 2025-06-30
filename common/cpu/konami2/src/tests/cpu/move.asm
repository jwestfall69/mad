	include "cpu/konami2/include/common.inc"

	global	move_test

	section code

move_test:
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

		lda	#$0
		sta	r_dst_data

		ldd	#$eaed
		std	r_dst_data + 1


		ldu	#$3
		ldy	#d_src_data
		ldx	#r_dst_data

		; should only copy 1 byte
		move

		pshs	u

		SEEK_XY (SCREEN_START_X + 1), (SCREEN_START_Y + 12)
		lda	r_dst_data
		RSUB	print_hex_byte

		SEEK_XY (SCREEN_START_X + 11), (SCREEN_START_Y + 14)
		ldd	r_dst_data + 1
		RSUB	print_hex_word

		SEEK_XY (SCREEN_START_X + 8), (SCREEN_START_Y + 17)
		puls	d
		RSUB	print_hex_word
		rts

	section data

d_src_data:	dc.b $12, $af, $fa

d_xys_screen_list:
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SRC DATA"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), " 12"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 11), "DST DATA"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 14), "WORD AFTER"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 15), "SHOULD BE EAED"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 17), "U AFTER"
		XY_STRING SCREEN_START_X, (SCREEN_START_Y + 18), "SHOULD BE 0002"
		XY_STRING SCREEN_START_X, SCREEN_B1_Y, " B1 - RUN TEST"
		XY_STRING SCREEN_START_X, SCREEN_B2_Y, " B2 - RETURN TO MENU"
		XY_STRING_LIST_END

	section bss

r_dst_data:	dcb.b	3

