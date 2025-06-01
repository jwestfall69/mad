	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "input.inc"
	include "machine.inc"

	global tile_scroll_test

	section code

ACTIVE_LAYER_A		equ $0
ACTIVE_LAYER_B		equ $1

tile_scroll_test:
		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list

		ldd	#$0
		sta	r_active_layer
		sta	r_layer_a_x
		std	r_layer_a_y
		sta	r_layer_b_x
		std	r_layer_b_y

		SEEK_XY	10, 14
		ldy	#d_str_layer_a
		PSUB	print_string

		SEEK_XY	10, 15
		leax	$1000, x	; adjust x to be in layer b
		ldy	#d_str_layer_b
		PSUB	print_string

		; setup text color on layer a/b
		ldd	#$3e0	; green
		std	LAYER_B_TILE_PALETTE + $c

	.loop_test:
		WATCHDOG
		clra
		cmpa	r_active_layer
		beq	.active_a
		lda	#'B'
		bra	.print_active
	.active_a:
		lda	#'A'
	.print_active:
		SEEK_XY	(SCREEN_START_X + 13), (SCREEN_START_Y + 3)
		PSUB	print_char

		lda	r_layer_a_x
		sta	REG_LAYER_A_SCROLL_X
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 4)
		PSUB	print_hex_byte

		ldd	r_layer_a_y
		anda	#$1
		std	r_layer_a_y
		stb	REG_LAYER_A_SCROLL_Y
		SEEK_XY	(SCREEN_START_X + 11), (SCREEN_START_Y + 4)
		PSUB	print_hex_word

		lda	r_layer_b_x
		sta	REG_LAYER_B_SCROLL_X
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 5)
		PSUB	print_hex_byte

		ldd	r_layer_b_y
		anda	#$1
		std	r_layer_b_y
		stb	REG_LAYER_B_SCROLL_Y
		SEEK_XY	(SCREEN_START_X + 11), (SCREEN_START_Y + 5)
		PSUB	print_hex_word

		; high bit
		; xxxx xxba
		lda	r_layer_b_y
		asla
		ora	r_layer_a_y
		sta	REG_LAYER_SCROLL_Y_HI

		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_B1
		beq	.b1_not_pressed
		lda	r_active_layer
		cmpa	#ACTIVE_LAYER_A
		beq	.switch_to_layer_b
		clr	r_active_layer
		lbra	.loop_test

	.switch_to_layer_b:
		lda	#ACTIVE_LAYER_B
		sta	r_active_layer
		lbra	.loop_test

	.b1_not_pressed:
		bita	#INPUT_B2
		beq	.b2_not_pressed

		clr	REG_LAYER_SCROLL_Y_HI
		clr	REG_LAYER_A_SCROLL_X
		clr	REG_LAYER_A_SCROLL_Y
		clr	REG_LAYER_B_SCROLL_X
		clr	REG_LAYER_B_SCROLL_Y
		rts

	.b2_not_pressed:
		lda	r_active_layer
		cmpa	#ACTIVE_LAYER_A
		beq	.active_layer_a
		ldx	#r_layer_b_x
		ldy	#r_layer_b_y
		bra	.handle_joystick
	.active_layer_a:
		ldx	#r_layer_a_x
		ldy	#r_layer_a_y

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
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "ACTIVE LAYER"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "LAYER A"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "LAYER B"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "JOY - SCROLL ACTIVE LAYER"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - SWITCH LAYER"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

d_str_layer_a:		STRING "LAYER A"
d_str_layer_b:		STRING "LAYER B"

	section bss

r_active_layer:		dcb.b 1
r_layer_a_x:		dcb.b 1
r_layer_a_y:		dcb.w 1
r_layer_b_x:		dcb.b 1
r_layer_b_y:		dcb.w 1
