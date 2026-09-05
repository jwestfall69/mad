	include "cpu/6309/include/common.inc"

	global tile_scroll_test

	section code

tile_scroll_test:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list
		jsr	print_b2_return_to_menu

		ldd	#$0
		sta	r_x
		sta	r_y

	.loop_test:
		WATCHDOG

		lda	r_x
		sta	REG_K005885_SCROLL_X
		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 4)
		RSUB	print_hex_byte

		lda	r_y
		sta	REG_K005885_SCROLL_Y
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 4)
		RSUB	print_hex_byte

		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_B2
		beq	.b2_not_pressed

		clr	REG_K005885_SCROLL_X
		clr	REG_K005885_SCROLL_Y
		rts

	.b2_not_pressed:
		ldx	#r_x
		ldy	#r_y

	.handle_joystick:
		lda	r_input_raw

		bita	#INPUT_UP
		beq	.up_not_pressed
		inc	, x
		bra	.down_not_pressed

	.up_not_pressed:
		bita	#INPUT_DOWN
		lbeq	.down_not_pressed
		dec	, x

	.down_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		inc	, y
		lbra	.loop_test

	.right_not_pressed:
		bita	#INPUT_LEFT
		lbeq	.loop_test
		dec	, y
		lbra	.loop_test

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "K005885"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "JOY - SCROLL"
	XY_STRING_LIST_END

	section bss

r_x:		dcb.b 1
r_y:		dcb.w 1
