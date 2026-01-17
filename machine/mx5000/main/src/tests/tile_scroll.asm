	include "cpu/6309/include/common.inc"

	global tile_scroll_test

	section code

tile_scroll_test:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list
		jsr	print_b2_return_to_menu

		ldd	#$0
		sta	r_x
		std	r_y

		; 18e doesn't have any font tiles, so
		; we just going to use a short red/green
		; line
		SEEK_XY	16, 14
		lda	#$f1
		sta	, x
		sta	$20, x
		sta	$40, x
		sta	$60, x

		; setup block color for 10e/18e
		ldd	#$1f00		; red
		std	K007121_TILE_B_PALETTE + $2

	.loop_test:
		WATCHDOG

		lda	r_x
		sta	REG_K007121_SCROLL_X
		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 4)
		RSUB	print_hex_byte

		ldd	r_y
		anda	#$1
		std	r_y
		stb	REG_K007121_SCROLL_Y
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 4)
		RSUB	print_hex_word

		; high bit
		lda	r_y
		sta	REG_K007121_SCROLL_Y_HI

		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_B2
		beq	.b2_not_pressed

		clr	REG_K007121_SCROLL_Y_HI
		clr	REG_K007121_SCROLL_X
		clr	REG_K007121_SCROLL_Y
		rts

	.b2_not_pressed:
		ldx	#r_x
		ldy	#r_y

	.handle_joystick:
		lda	r_input_raw

		bita	#INPUT_UP
		beq	.up_not_pressed
		ldw	, y
		addw	#$1
		stw	, y
		bra	.down_not_pressed

	.up_not_pressed:
		bita	#INPUT_DOWN
		lbeq	.down_not_pressed
		ldw	, y
		subw	#$1
		stw	, y

	.down_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		inc	, x
		lbra	.loop_test

	.right_not_pressed:
		bita	#INPUT_LEFT
		lbeq	.loop_test
		dec	, x
		lbra	.loop_test

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "K007121"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "JOY - SCROLL ACTIVE K007121"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - SWITCH LAYER"
	XY_STRING_LIST_END

	section bss

r_x:		dcb.b 1
r_y:		dcb.w 1
