	include "cpu/6x09/include/common.inc"

	global sound_test_handler

	section code

; params:
;  a = start value
;  x = sound play function
;  y = sound stop function
sound_test_handler:
		sta	r_sound_num
		stx	r_sound_play_cb
		sty	r_sound_stop_cb

	.loop_test:
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 6)
		lda	r_sound_num
		RSUB	print_hex_byte

		WATCHDOG
		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_B1
		beq	.b1_not_pressed
		lda	r_sound_num
		jsr	[r_sound_play_cb]
		bra	.loop_test

	.b1_not_pressed:
		bita	#INPUT_B2
		beq	.b2_not_pressed
		jsr	[r_sound_stop_cb]
		rts

	.b2_not_pressed:
		lda	#$ff
		ldx	#r_input_edge
		ldy	#r_sound_num
		jsr	joystick_update_byte
		bra	.loop_test

	section bss

r_sound_num:		dcb.b 1
r_sound_play_cb:	dcb.w 1
r_sound_stop_cb:	dcb.w 1
