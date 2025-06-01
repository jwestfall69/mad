	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "global/include/screen.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"

	global sound_test_handler

	section code

; params:
;  a = start value
sound_test_handler:
		sta	r_sound_num

	.loop_test:
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 6)
		lda	r_sound_num
		PSUB	print_hex_byte

		WATCHDOG
		pshs	b
		jsr	input_update
		puls	b
		lda	r_input_edge

		bita	#INPUT_B1
		beq	.b1_not_pressed
		lda	r_sound_num
		SOUND_PLAY
		bra	.loop_test

	.b1_not_pressed:
		bita	#INPUT_B2
		beq	.b2_not_pressed
		SOUND_STOP
		rts

	.b2_not_pressed:
		lda	#$ff
		ldx	#r_input_edge
		ldy	#r_sound_num
		jsr	joystick_update_byte
		bra	.loop_test

	section bss

r_sound_num:		dcb.b 1
