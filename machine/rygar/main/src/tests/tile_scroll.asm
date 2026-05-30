	include "cpu/z80/include/common.inc"

	global tile_scroll_test

	section code

ACTIVE_BG_TILE		equ $0
ACTIVE_FG_TILE		equ $1

tile_scroll_test:
		ld	de, d_screen_xys_list
		call	print_xy_string_list
		call	print_b2_return_to_menu

		ld	bc, $0
		ld	(r_bg_scroll_x), bc
		ld	(r_fg_scroll_x), bc
		ld	(REG_BG_SCROLL_X), bc
		ld	(REG_FG_SCROLL_X), bc

		ld	a, $0
		ld	(r_active_layer), a
		ld	(r_bg_scroll_y), a
		ld	(r_fg_scroll_y), a
		ld	(REG_BG_SCROLL_Y), a
		ld	(REG_FG_SCROLL_Y), a

		; todo setup palette
		ld	hl, BG_TILE_PALETTE
		ld	de, PALETTE_SIZE
		ld	bc, $00f
		RSUB	memory_fill_word

		ld	a, $07
		ld	(BG_TILE_RAM + $109), a

		ld	hl, FG_TILE_PALETTE
		ld	de, PALETTE_SIZE
		ld	bc, $0f0
		RSUB	memory_fill_word

		ld	a, $07
		ld	(FG_TILE_RAM + $10a), a

	.loop_test:
		WATCHDOG

		ld	a, (r_active_layer)
		cp	ACTIVE_BG_TILE
		jr	nz, .fg_tile_cursor
		SEEK_XY	(SCREEN_START_X - 1), (SCREEN_START_Y + 3)
		ld	c, CURSOR_CHAR
		RSUB	print_char

		SEEK_XY	(SCREEN_START_X - 1), (SCREEN_START_Y + 4)
		ld	c, CURSOR_CLEAR_CHAR
		RSUB	print_char

		jr	.cursor_done

	.fg_tile_cursor:
		SEEK_XY	(SCREEN_START_X - 1), (SCREEN_START_Y + 3)
		ld	c, CURSOR_CLEAR_CHAR
		RSUB	print_char

		SEEK_XY	(SCREEN_START_X - 1), (SCREEN_START_Y + 4)
		ld	c, CURSOR_CHAR
		RSUB	print_char

	.cursor_done:

		ld	bc, (r_bg_scroll_x)
		ld	(REG_BG_SCROLL_X), bc
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 3)
		RSUB	print_hex_word

		ld	a, (r_bg_scroll_y)
		ld	(REG_BG_SCROLL_Y), a
		ld	c, a
		SEEK_XY	(SCREEN_START_X + 13), (SCREEN_START_Y + 3)
		RSUB	print_hex_byte

		ld	bc, (r_fg_scroll_x)
		ld	(REG_FG_SCROLL_X), bc
		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 4)
		RSUB	print_hex_word

		ld	a, (r_fg_scroll_y)
		ld	(REG_FG_SCROLL_Y), a
		ld	c, a
		SEEK_XY	(SCREEN_START_X + 13), (SCREEN_START_Y + 4)
		RSUB	print_hex_byte

		call	input_update
		ld	a, (r_input_edge)

		bit	INPUT_B1_BIT, a
		jr	z, .b1_not_pressed
		ld	a, (r_active_layer)
		inc	a
		and	$1
		ld	(r_active_layer), a
		jr	.loop_test

	.b1_not_pressed:
		bit	INPUT_B2_BIT, a
		jr	z, .b2_not_pressed
		ret

	.b2_not_pressed:
		; setup ix/iy to point at active layer memory addresses
		ld	a, (r_active_layer)
		cp	ACTIVE_BG_TILE
		jr	nz, .active_fg_tile
		ld	ix, r_bg_scroll_x
		ld	iy, r_bg_scroll_y
		jr	.handle_joystick

	.active_fg_tile:
		ld	ix, r_fg_scroll_x
		ld	iy, r_fg_scroll_y

	.handle_joystick:
		ld	h, (ix + 1)
		ld	l, (ix + 0)
		ld	bc, $1

		ld	a, (r_input_raw)
		bit	INPUT_UP_BIT, a
		jr	z, .up_not_pressed
		inc	(iy)

	.up_not_pressed:
		bit	INPUT_DOWN_BIT, a
		jr	z, .down_not_pressed
		dec	(iy)

	.down_not_pressed:
		bit	INPUT_RIGHT_BIT, a
		jr	z, .right_not_pressed
		sbc	hl, bc

	.right_not_pressed:
		bit	INPUT_LEFT_BIT, a
		jr	z, .left_not_pressed
		add	hl, bc

	.left_not_pressed:
		ld	a, h
		and	$1
		ld	(ix + 1), a
		ld	(ix + 0), l
		jp	.loop_test

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "BG TILE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "FG TILE"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "JOY - SCROLL ACTIVE LAYER"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - SWITCH LAYER"
	XY_STRING_LIST_END

d_str_bg_tile:	STRING "BG TILE"
d_str_fg_tile:	STRING "FG TILE"

	section bss

r_active_layer:		dcb.b 1
r_bg_scroll_x:		dcb.w 1
r_bg_scroll_y:		dcb.b 1
r_fg_scroll_x:		dcb.w 1
r_fg_scroll_y:		dcb.b 1
