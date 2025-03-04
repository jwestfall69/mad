	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"
	include "global/include/screen.inc"

	include "input.inc"
	include "machine.inc"

	global error_address_test

	section code

error_address_test:
		moveq	#$0, d4		; error num

	.update_byte:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		and.l	#$7f, d4	; error codes are limited to 7 bits
		move.b	d4, d0
		SEEK_XY	(SCREEN_START_X + 19), (SCREEN_START_Y + 6)
		RSUB	print_hex_byte

		move.b	d4, d0
		and.l	#$ff, d0
		lsl.l	#5, d0
		or.l	#$6000, d0
		SEEK_XY	(SCREEN_START_X + 15), (SCREEN_START_Y + 7)
		RSUB	print_hex_3_bytes

	.loop_input:
		WATCHDOG

		bsr	input_update
		move.b	r_input_edge, d0

		btst	#INPUT_UP_BIT, d0
		beq	.up_not_pressed
		add.w	#1, d4
		bra	.update_byte
	.up_not_pressed:

		btst	#INPUT_DOWN_BIT, d0
		beq	.down_not_pressed
		sub.w	#1, d4
		bra	.update_byte

	.down_not_pressed:
		btst	#INPUT_LEFT_BIT, d0
		beq	.left_not_pressed
		sub.w	#$10, d4
		bra	.update_byte

	.left_not_pressed:
		btst	#INPUT_RIGHT_BIT, d0
		beq	.right_not_pressed
		add.w	#$10, d4
		bra	.update_byte

	.right_not_pressed:
		btst	#INPUT_B1_BIT, d0
		beq	.b1_not_pressed

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 12)
		lea	d_str_triggered, a0
		RSUB	print_string

		move.w	d4, d0
		jmp	error_address

	.b1_not_pressed:
		btst	#INPUT_B2_BIT, d0
		beq	.loop_input
		rts


	section data
	align 2

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), <"ERROR NUM", CHAR_COLON>
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), <"ERROR ADDRESS", CHAR_COLON>

	ifd _SCREEN_TATE_
		XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - TRIGGER ERROR ADDR"
	else
		XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - TRIGGER ERROR ADDRESS"
	endif

	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

d_str_triggered:	STRING "TRIGGERED"
