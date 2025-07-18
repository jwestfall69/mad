	include "cpu/68000/include/common.inc"

	global sound_test_handler

	section code

; params:
;  d0 = start value
sound_test_handler:
		move.w	d0, d4
		movea.l	a0, a1

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
		SOUND_PLAY
		bra	.loop_input

	.b1_not_pressed:
		btst	#INPUT_B2_BIT, d0
		beq	.loop_input

		SOUND_STOP
		rts
