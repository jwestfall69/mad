	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/error_codes.inc"
	include "cpu/konami2/include/macros.inc"
	include "cpu/konami2/include/xy_string.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global error_address_test

	section code

error_address_test:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		SEEK_XY (SCREEN_START_X + 17), (SCREEN_START_Y + 5)
		lda	#EC_MASK
		RSUB	print_hex_byte

		lda	#$1
		sta	r_error_code

	.update_byte:
		SEEK_XY	(SCREEN_START_X + 17), (SCREEN_START_Y + 6)
		lda	r_error_code
		anda	#EC_MASK
		sta	r_error_code
		RSUB	print_hex_byte

		lda	r_error_code
		clrb
		rora
		rorb
		rora
		rorb
		rora
		rorb
		rora
		rorb
		addd	#$f000

		SEEK_XY	(SCREEN_START_X + 15), (SCREEN_START_Y + 7)
		RSUB	print_hex_word

	.loop_input:
		WATCHDOG
		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_UP
		beq	.up_not_pressed
		inc	r_error_code
		bra	.update_byte

	.up_not_pressed:
		bita	#INPUT_DOWN
		beq	.down_not_pressed
		dec	r_error_code
		bra	.update_byte

	.down_not_pressed:
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		lda	r_error_code
		suba	#$10
		sta	r_error_code
		bra	.update_byte

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		lda	r_error_code
		adda	#$10
		sta	r_error_code
		bra	.update_byte

	.right_not_pressed:
		bita	#INPUT_B1
		beq	.b1_not_pressed

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 12)
		ldy	#d_str_triggered
		RSUB	print_string

		lda	r_error_code
		jmp	error_address

	.b1_not_pressed:
		bita	#INPUT_B2
		beq	.loop_input
		rts

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), <"EC MASK", CHAR_COLON>
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), <"ERROR NUM", CHAR_COLON>
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), <"ERROR ADDRESS", CHAR_COLON>
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - TRIGGER ERROR ADDRESS"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

d_str_triggered:	STRING "TRIGGERED"

	section bss

r_error_code:		dcb.b 1
