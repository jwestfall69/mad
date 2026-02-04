	include "cpu/z80/include/common.inc"

	global sound_test_handler

	section code

; params:
;  a = start value
;  b = mask
; ix = play sound function
; iy = stop sound function
sound_test_handler:
		ld	(r_sound_num), a
		ld	a, b
		ld	(r_mask), a
		ld	(r_sound_play_cb), ix
		ld	(r_sound_stop_cb), iy

		ld	de, d_screen_xys_list
		call	print_xy_string_list
		call	print_b2_return_to_menu

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

		ld	hl, (r_sound_play_cb)
		ld	de, .loop_test
		push	de
		ld	a, (r_sound_num)
		jp	(hl)

	.b1_not_pressed:
		bit	INPUT_B2_BIT, a
		jr	z, .b2_not_pressed

		ld	hl, (r_sound_stop_cb)
		ld	de, .sound_stop_return
		push	de
		jp	(hl)

	.sound_stop_return:
		ret

	.b2_not_pressed:
		ld	a, (r_mask)
		ld	ix, r_input_edge
		ld	iy, r_sound_num
		call	joystick_update_byte
		jr	.loop_test

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), <"SOUND NUM", CHAR_COLON>
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PLAY SOUND"
	XY_STRING_LIST_END

	section bss

r_sound_num:		dcb.b 1
r_mask:			dcb.b 1
r_sound_play_cb:	dcb.w 1
r_sound_stop_cb:	dcb.w 1
