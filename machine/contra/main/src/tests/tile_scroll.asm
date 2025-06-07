	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"

	include "input.inc"
	include "machine.inc"

	global tile_scroll_test

	section code

ACTIVE_K007121_10E		equ $0
ACTIVE_K007121_18E		equ $1

tile_scroll_test:
		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list

		ldd	#$0
		sta	r_active
		sta	r_10e_x
		std	r_10e_y
		sta	r_18e_x
		std	r_18e_y

		; 18e doesn't have any font tiles, so
		; we just going to use a short red/green
		; line
		SEEK_XY	16, 14
		lda	#$31
		sta	, x
		sta	$20, x
		sta	$40, x
		sta	$60, x

		SEEK_XY	16, 15
		leax	$2000, x	; for 18e
		lda	#$01
		sta	, x
		sta	$20, x
		sta	$40, x
		sta	$60, x

		; setup block color for 10e/18e
		ldd	#$1f00		; red
		std	K007121_10E_TILE_A_PALETTE + $2
		ldd	#$e003		; green
		std	K007121_18E_TILE_A_PALETTE + $2

	.loop_test:
		WATCHDOG
		clra
		cmpa	r_active
		bne	.active_18e
		ldy	#d_str_10e
		bra	.print_active
	.active_18e:
		ldy	#d_str_18e

	.print_active:
		SEEK_XY	(SCREEN_START_X + 16), (SCREEN_START_Y + 3)
		PSUB	print_string

		lda	r_10e_x
		sta	REG_K007121_10E_SCROLL_X
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 4)
		PSUB	print_hex_byte

		ldd	r_10e_y
		anda	#$1
		std	r_10e_y
		stb	REG_K007121_10E_SCROLL_Y
		SEEK_XY	(SCREEN_START_X + 15), (SCREEN_START_Y + 4)
		PSUB	print_hex_word

		lda	r_18e_x
		sta	REG_K007121_18E_SCROLL_X
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 5)
		PSUB	print_hex_byte

		ldd	r_18e_y
		anda	#$1
		std	r_18e_y
		stb	REG_K007121_18E_SCROLL_Y
		SEEK_XY	(SCREEN_START_X + 15), (SCREEN_START_Y + 5)
		PSUB	print_hex_word

		; high bit
		lda	r_10e_y
		sta	REG_K007121_10E_SCROLL_Y_HI
		lda	r_18e_y
		sta	REG_K007121_18E_SCROLL_Y_HI

		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_B1
		beq	.b1_not_pressed
		lda	r_active
		cmpa	#ACTIVE_K007121_10E
		beq	.switch_to_k007121_18e
		clr	r_active
		lbra	.loop_test

	.switch_to_k007121_18e:
		lda	#ACTIVE_K007121_18E
		sta	r_active
		lbra	.loop_test

	.b1_not_pressed:
		bita	#INPUT_B2
		beq	.b2_not_pressed

		clr	REG_K007121_10E_SCROLL_Y_HI
		clr	REG_K007121_10E_SCROLL_X
		clr	REG_K007121_10E_SCROLL_Y
		clr	REG_K007121_18E_SCROLL_X
		clr	REG_K007121_18E_SCROLL_Y
		rts

	.b2_not_pressed:
		lda	r_active
		cmpa	#ACTIVE_K007121_10E
		beq	.active_10e
		ldx	#r_18e_x
		ldy	#r_18e_y
		bra	.handle_joystick
	.active_10e:
		ldx	#r_10e_x
		ldy	#r_10e_y

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
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "ACTIVE K007121"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "K007121 10E"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "K007121 18E"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "JOY - SCROLL ACTIVE K007121"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - SWITCH LAYER"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

d_str_10e:			STRING "10E"
d_str_18e:			STRING "18E"

	section bss

r_active:		dcb.b 1
r_10e_x:		dcb.b 1
r_10e_y:		dcb.w 1
r_18e_x:		dcb.b 1
r_18e_y:		dcb.w 1
