	include "cpu/68000/include/common.inc"

	global tile_scroll_test

	section code

ACTIVE_LAYER_A		equ $0
ACTIVE_LAYER_B		equ $1

tile_scroll_test:
		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list
		jsr	print_b2_return_to_menu

		moveq	#$0, d0
		move.b	d0, r_active_layer
		move.w	d0, r_layer_a_x
		move.b	d0, r_layer_a_y
		move.w	d0, r_layer_b_x
		move.b	d0, r_layer_b_y

		SEEK_XY	10, 14
		add.l	#$1000, a6		; adjust a6 to be in layer a
		lea	d_str_layer_a, a0
		RSUB	print_string

		SEEK_XY	10, 15
		add.l	#$2000, a6		; adjust a6 to be in layer b
		lea	d_str_layer_b, a0
		RSUB	print_string

		; setup text color on layer a/b
		move.w	#$1f, LAYER_A_TILE_PALETTE + $10	; red
		move.w	#$1f, LAYER_A_TILE_PALETTE + $12
		move.w	#$3e0, LAYER_B_TILE_PALETTE + $10	; green
		move.w	#$3e0, LAYER_B_TILE_PALETTE + $12

	.loop_test:
		WATCHDOG
		moveq	#$0, d0
		cmp.b	r_active_layer, d0
		beq	.active_a
		move.b	#'B', d0
		bra	.print_active
	.active_a:
		move.b	#'A', d0

	.print_active:
		SEEK_XY	(SCREEN_START_X + 13), (SCREEN_START_Y + 3)
		RSUB	print_char


		move.w	r_layer_a_x, d0
		and.w	#$1ff, d0
		move.w	d0, r_layer_a_x
		move.w	d0, d1
		move.b	d0, REG_LAYER_A_SCROLL_X_LOW
		lsr.w	#$8, d0
		move.b	d0, REG_LAYER_A_SCROLL_X_HIGH
		move.w	d1, d0

		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 4)
		RSUB	print_hex_word

		move.b	r_layer_a_y, d0
		move.b	d0, REG_LAYER_A_SCROLL_Y
		SEEK_XY	(SCREEN_START_X + 13), (SCREEN_START_Y + 4)
		RSUB	print_hex_byte

		move.w	r_layer_b_x, d0
		and.w	#$1ff, d0
		move.w	d0, r_layer_b_x
		move.w	d0, d1
		move.b	d0, REG_LAYER_B_SCROLL_X_LOW
		lsr.w	#$8, d0
		move.b	d0, REG_LAYER_B_SCROLL_X_HIGH
		move.w	d1, d0
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 5)
		RSUB	print_hex_word

		move.b	r_layer_b_y, d0
		move.b	d0, REG_LAYER_B_SCROLL_Y
		SEEK_XY	(SCREEN_START_X + 13), (SCREEN_START_Y + 5)
		RSUB	print_hex_byte

		jsr	input_update
		move.b	r_input_edge, d0

		btst	#INPUT_B1_BIT, d0
		beq	.b1_not_pressed
		move.b	r_active_layer, d0
		addq.b	#$1, d0
		and.b	#$1, d0
		move.b	d0, r_active_layer
		bra	.loop_test

	.b1_not_pressed:
		btst	#INPUT_B2_BIT, d0
		beq	.b2_not_pressed
		rts

	.b2_not_pressed:

		move.b	r_active_layer, d0
		cmp.b	#ACTIVE_LAYER_A, d0
		beq	.layer_a_active
		lea	r_layer_b_x, a0
		lea	r_layer_b_y, a1
		bra	.handle_joystick

	.layer_a_active:
		lea	r_layer_a_x, a0
		lea	r_layer_a_y, a1

	.handle_joystick:
		move.b	r_input_raw, d0
		btst	#INPUT_UP_BIT, d0
		beq	.up_not_pressed
		addq.b	#$1, (a1)
		bra	.down_not_pressed

	.up_not_pressed:
		btst	#INPUT_DOWN_BIT, d0
		beq	.down_not_pressed
		subq.b	#$1, (a1)

	.down_not_pressed:
		btst	#INPUT_LEFT_BIT, d0
		beq	.left_not_pressed
		addq.w	#$1, (a0)
		bra	.loop_test

	.left_not_pressed:
		btst	#INPUT_RIGHT_BIT, d0
		beq	.loop_test
		subq.w	#$1, (a0)
		bra	.loop_test


	section data
	align 1

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "ACTIVE LAYER"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "LAYER A"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "LAYER B"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "JOY - SCROLL ACTIVE LAYER"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - SWITCH LAYER"
	XY_STRING_LIST_END

d_str_layer_a:		STRING "LAYER A"
d_str_layer_b:		STRING "LAYER B"

	section bss
	align 1

r_layer_a_x:		dcb.w 1
r_layer_b_x:		dcb.w 1

r_layer_a_y:		dcb.b 1
r_layer_b_y:		dcb.b 1

r_active_layer:		dcb.b 1
