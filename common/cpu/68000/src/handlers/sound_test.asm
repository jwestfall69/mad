	include "cpu/68000/include/common.inc"

	global sound_test_handler

	section code

; params:
;  d0 = start value
;  a0 = sound play function
;  a1 = sound stop function
sound_test_handler:
		move.w	d0, d4
		move.l	a0, (r_sound_play_cb)
		move.l	a1, (r_sound_stop_cb)

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list
		jsr	print_b2_return_to_menu

	.update_byte:
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 6)
		move.w	d4, d0
		DSUB	print_hex_word

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
		move.w	d4, d0
		move.l	(r_sound_play_cb), a0
		jsr	(a0)
		bra	.loop_input

	.b1_not_pressed:
		btst	#INPUT_B2_BIT, d0
		beq	.loop_input

		move.l	(r_sound_stop_cb), a0
		jsr	(a0)
		rts

	section data
	align 1

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), <"SOUND NUM", CHAR_COLON>
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PLAY SOUND"
	XY_STRING_LIST_END

	section bss
	align 1

r_sound_play_cb:	dcb.l 1
r_sound_stop_cb:	dcb.l 1
