	include "global/include/macros.inc"
	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"
	include "cpu/6x09/include/xy_string.inc"

	include "cpu/6309/include/dsub.inc"

	include "input.inc"
	include "machine.inc"

	global bac06_tile_scroll_test

	section code


bac06_tile_scroll_test:
		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		ldd	#$0
		std	r_pos_x
		std	r_pos_y

		ldd	#$408c
		std	BAC06_RAM + $10e
		ldb	#$8d
		std	BAC06_RAM + $12e
		ldb	#$8e
		std	BAC06_RAM + $14e

	.loop_test:
		WATCHDOG

		ldd	r_pos_x
		anda	#$1
		std	r_pos_x
		std	REG_BAC06_SCROLL_X
		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 4)
		RSUB	print_hex_word

		ldd	r_pos_y
		anda	#$1
		std	r_pos_y
		std	REG_BAC06_SCROLL_Y
		SEEK_XY	(SCREEN_START_X + 9), (SCREEN_START_Y + 5)
		RSUB	print_hex_word

		ldx	#r_pos_x
		ldy	#r_pos_y

		jsr	input_update
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
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		ldw	, x
		addw	#$1
		stw	, x
		lbra	.loop_test

	.left_not_pressed:
		bita	#INPUT_RIGHT
		lbeq	.right_not_pressed
		ldw	, x
		subw	#$1
		stw	, x
		lbra	.loop_test

	.right_not_pressed:
		bita	#INPUT_B2
		lbeq	.loop_test

		clrd
		std	REG_BAC06_SCROLL_X
		std	REG_BAC06_SCROLL_Y
		rts

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "JOY - SCROLL TILE"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - SWITCH LAYER"
	XY_STRING_LIST_END

	section bss

r_pos_x:		dcb.w 1
r_pos_y:		dcb.w 1
