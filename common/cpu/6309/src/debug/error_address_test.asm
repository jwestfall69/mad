	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global error_address_test

	section code

error_address_test:
		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list

		SEEK_XY (SCREEN_START_X + 17), (SCREEN_START_Y + 5)
		lda	#EC_MASK
		PSUB	print_hex_byte

		ldf	#$1

	.update_byte:
		SEEK_XY	(SCREEN_START_X + 17), (SCREEN_START_Y + 6)
		tfr	f, a
		anda	#EC_MASK
		tfr	a, f
		PSUB	print_hex_byte

		tfr	f, a
		clrb
		rord
		rord
		rord
		rord
		ord	#$f000

		SEEK_XY	(SCREEN_START_X + 15), (SCREEN_START_Y + 7)
		pshsw
		PSUB	print_hex_word
		pulsw

	.loop_input:
		WATCHDOG
		pshs	b
		jsr	input_update
		puls	b
		lda	r_input_edge

		bita	#INPUT_UP
		beq	.up_not_pressed
		addf	#$1
		bra	.update_byte

	.up_not_pressed:
		bita	#INPUT_DOWN
		beq	.down_not_pressed
		subf	#$1
		bra	.update_byte

	.down_not_pressed:
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		subf	#$10
		bra	.update_byte

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		addf	#$10
		bra	.update_byte

	.right_not_pressed:
		bita	#INPUT_B1
		beq	.b1_not_pressed

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 12)
		ldy	#d_str_triggered
		PSUB	print_string

		tfr	f, a
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
