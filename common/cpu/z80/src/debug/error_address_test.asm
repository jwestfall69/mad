	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/z80/include/dsub.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/xy_string.inc"

	include "error_codes.inc"
	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global error_address_test

	section code

error_address_test:
		ld	de, d_screen_xys_list
		call	print_xy_string_list

		SEEK_XY (SCREEN_START_X + 17), (SCREEN_START_Y + 5)
		ld	c, EC_MASK
		RSUB	print_hex_byte

		ld	a, 1
		ld	(r_error_code), a

	.update_byte:
		ld	b, EC_MASK
		and	b
		ld	(r_error_code), a

		SEEK_XY	(SCREEN_START_X + 17), (SCREEN_START_Y + 6)
		ld	c, a
		RSUB	print_hex_byte

		; jump address is $2000 | (a << 7)
		ld	a, (r_error_code)
		ld	bc, $2000
		ld	hl, $0		; make the error code be bits 7 to 12 of hl
		ld	h, a
		srl	h
		rr	l

		add	hl, bc		; add on base address

		SEEK_XY	(SCREEN_START_X + 15), (SCREEN_START_Y + 7)
		ld	b, h
		ld	c, l
		RSUB	print_hex_word

	.loop_input:
		WATCHDOG

		call	input_update
		ld	a, (r_input_edge)
		ld	b, a
		ld	a, (r_error_code)

		bit	INPUT_UP_BIT, b
		jr	z, .up_not_pressed
		inc	a
		jr	.update_byte

	.up_not_pressed:
		bit	INPUT_DOWN_BIT, b
		jr	z, .down_not_pressed
		dec	a
		jr	.update_byte

	.down_not_pressed:
		bit	INPUT_LEFT_BIT, b
		jr	z, .left_not_pressed
		sub	$10
		jr	.update_byte

	.left_not_pressed:
		bit	INPUT_RIGHT_BIT, b
		jr	z, .right_not_pressed
		add	a, $10
		jr	.update_byte

	.right_not_pressed:
		bit	INPUT_B1_BIT, b
		jr	z, .b1_not_pressed

		push	af

		SEEK_XY SCREEN_START_X, (SCREEN_START_Y + 12)
		ld	de, d_str_triggered
		RSUB	print_string

		pop	af
		jp	error_address

	.b1_not_pressed:
		bit	INPUT_B2_BIT, b
		jr	z, .loop_input
		ret

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), <"EC MASK", CHAR_COLON>
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), <"ERROR CODE", CHAR_COLON>
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), <"ERROR ADDRESS", CHAR_COLON>
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - TRIGGER ERROR ADDRESS"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

d_str_triggered:	STRING "TRIGGERED"

	section bss

r_error_code:		dcb.b 1
