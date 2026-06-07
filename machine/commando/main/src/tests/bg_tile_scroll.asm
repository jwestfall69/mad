	include "cpu/z80/include/common.inc"

	global bg_tile_scroll_test

	section code

bg_tile_scroll_test:
		ld	de, d_screen_xys_list
		call	print_xy_string_list
		call	print_b2_return_to_menu

		ld	bc, $0
		ld	(r_bg_scroll_x), bc
		ld	(r_bg_scroll_y), bc
		ld	(REG_BG_SCROLL_X), bc
		ld	(REG_BG_SCROLL_Y), bc

		ld	a, $02
		ld	(BG_TILE_RAM + $109), a

	.loop_test:
		WATCHDOG

		ld	bc, (r_bg_scroll_x)
		ld	(REG_BG_SCROLL_X), bc
		SEEK_XY	(SCREEN_START_X + 10), (SCREEN_START_Y + 3)
		RSUB	print_hex_word

		ld	bc, (r_bg_scroll_y)
		ld	(REG_BG_SCROLL_Y), bc
		SEEK_XY	(SCREEN_START_X + 2), (SCREEN_START_Y + 3)
		RSUB	print_hex_word

		call	input_update
		ld	a, (r_input_edge)

		bit	INPUT_B2_BIT, a
		jr	z, .b2_not_pressed
		ret

	.b2_not_pressed:
		ld	ix, (r_bg_scroll_x)
		ld	iy, (r_bg_scroll_y)

		ld	a, (r_input_raw)
		bit	INPUT_UP_BIT, a
		jr	z, .up_not_pressed
		dec	ix

	.up_not_pressed:
		bit	INPUT_DOWN_BIT, a
		jr	z, .down_not_pressed
		inc	ix

	.down_not_pressed:
		bit	INPUT_RIGHT_BIT, a
		jr	z, .right_not_pressed
		dec	iy

	.right_not_pressed:
		bit	INPUT_LEFT_BIT, a
		jr	z, .left_not_pressed
		inc	iy

	.left_not_pressed:
		ld	a, ixh
		and	$1
		ld	ixh, a
		ld	(r_bg_scroll_x), ix

		ld	a, iyh
		and	$1
		ld	iyh, a
		ld	(r_bg_scroll_y), iy
		jp	.loop_test

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "X"
	XY_STRING (SCREEN_START_X + 8), (SCREEN_START_Y + 3), "Y"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "JOY - SCROLL ACTIVE LAYER"
	XY_STRING_LIST_END

	section bss

r_bg_scroll_x:		dcb.w 1
r_bg_scroll_y:		dcb.w 1
