	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"

	include "input.inc"
	include "machine.inc"
	include "mad_rom.inc"

	global sound_test_handler

	section code

; params:
;  a = start value
sound_test_handler:

		tfr	a, f

	.update_byte:
		SEEK_XY	14, 10
		tfr	f, a
		PSUB	print_hex_byte

	.loop_input:
		WATCHDOG
		pshs	b
		jsr	input_update
		puls	b
		lda	INPUT_EDGE

		bita	#INPUT_DOWN
		beq	.down_not_pressed
		subf	#$1
		bra	.update_byte

	.down_not_pressed:
		bita	#INPUT_UP
		beq	.up_not_pressed
		addf	#$1
		bra	.update_byte

	.up_not_pressed:
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		subf	#$10
		bra	.update_byte

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		addf	#$10
		bra	.update_byte

	.right_not_pressed:
		bita	#INPUT_B1
		beq	.b1_not_pressed
		tfr	f, a
		SOUND_PLAY
		bra	.loop_input

	.b1_not_pressed:
		bita	#INPUT_B2
		beq	.loop_input
		SOUND_STOP
		rts
