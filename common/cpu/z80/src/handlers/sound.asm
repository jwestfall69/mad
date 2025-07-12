	include "cpu/z80/include/common.inc"

	global sound_test_handler

	section code

; params:
;  a = start value
; b = mask
sound_test_handler:
		ld	(r_sound_num), a
		ld	a, b
		ld	(r_mask), a

	.loop_test:
		SEEK_XY	(SCREEN_START_X + 12), (SCREEN_START_Y + 6)
		ld	a, (r_sound_num)
		ld	c, a
		RSUB	print_hex_byte

		WATCHDOG
		call	input_update
		ld	a, (r_input_edge)

		bit	INPUT_B1_BIT, a
		jr	z, .b1_not_pressed
		ld	a, (r_sound_num)
		SOUND_PLAY
		jr	.loop_test

	.b1_not_pressed:
		bit	INPUT_B2_BIT, a
		jr	z, .b2_not_pressed
		SOUND_STOP
		ret

	.b2_not_pressed:
		ld	a, (r_mask)
		ld	ix, r_input_edge
		ld	iy, r_sound_num
		call	joystick_update_byte
		jr	.loop_test

	section bss

r_sound_num:		dcb.b 1
r_mask:			dcb.b 1
