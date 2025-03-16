	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/z80/include/dsub.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/xy_string.inc"

	include "input.inc"
	include "machine.inc"

	global tile8_viewer_handler

START_COLUMN	equ SCREEN_START_X
START_ROW	equ SCREEN_START_Y + 6

	section code

; params:
;  b = tile offset upper
;  c = offset mask upper
;  de = seek_xy function
;  hl = draw_tile function
tile8_viewer_handler:
		ld	a, b
		ld	(r_tile_offset_upper), a
		ld	a, c
		ld	(r_tile_offset_upper_mask), a
		ld	(r_seek_xy_cb), de
		ld	(r_draw_tile_cb), hl

		ld	de, d_screen_xys_list
		call	print_xy_string_list

		SEEK_XY	(START_COLUMN + 2), (SCREEN_START_Y + 4)
		ld	de, d_str_0f
		RSUB	print_string

	.loop_redraw:
		; stay within our mask and print
		ld	a, (r_tile_offset_upper_mask)
		ld	b, a
		ld	a, (r_tile_offset_upper)

		and	b

		ld	(r_tile_offset_upper), a
		ld	b, a
		ld	c, 0
		ld	(r_current_tile), bc

		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 2)
		RSUB	print_hex_word

		ld	a, START_ROW
		ld	(r_current_row), a

		ld	ix, d_str_0f
	.loop_next_row:
		ld	a, START_COLUMN
		ld	(r_current_column), a

		; seek/print row header
		ld	b, a
		ld	a, (r_current_row)
		ld	c, a
		RSUB	screen_seek_xy

		ld	c, (ix)
		RSUB	print_char
		inc	ix

		; adjust to for column with tiles
		ld	a, (r_current_column)
		inc	a
		inc	a
		ld	(r_current_column), a

	.loop_next_byte:

		; seek to current tile x,y
		ld	a, (r_current_column)
		ld	b, a
		ld	a, (r_current_row)
		ld	c, a

		ld	iy, (r_seek_xy_cb)
		ld	de, .seek_xy_return
		push	de
		jp	(iy)
	.seek_xy_return:

		; draw current tile
		ld	bc, (r_current_tile)
		ld	iy, (r_draw_tile_cb)
		ld	de, .draw_tile_return
		push	de
		jp	(iy)
	.draw_tile_return:

		ld	bc, (r_current_tile)
		inc	bc
		ld	(r_current_tile), bc

		ld	a, (r_current_column)
		inc	a
		ld	(r_current_column), a
		cp	START_COLUMN + $12
		jr	nz, .loop_next_byte

		ld	a, (r_current_row)
		inc	a
		ld	(r_current_row), a
		cp	START_ROW + $10
		jr	nz, .loop_next_row

	.loop_next_input:
		WATCHDOG

		call	input_update
		ld	a, (r_input_edge)
		ld	b, a
		ld	a, (r_tile_offset_upper)

		bit	INPUT_UP_BIT, b
		jr	z, .up_not_pressed
		inc	a
		jr	.update_tile_offset_upper

	.up_not_pressed:
		bit	INPUT_DOWN_BIT, b
		jr	z, .down_not_pressed
		dec	a
		jr	.update_tile_offset_upper

	.down_not_pressed:
		bit	INPUT_LEFT_BIT, b
		jr	z, .left_not_pressed
		sub	$10
		jr	.update_tile_offset_upper

	.left_not_pressed:
		bit	INPUT_RIGHT_BIT, b
		jr	z, .right_not_pressed
		add	$10
		jr	.update_tile_offset_upper

	.right_not_pressed:
		bit	INPUT_B2_BIT, b
		jp	z, .loop_redraw
		ret

	.update_tile_offset_upper:
		ld	(r_tile_offset_upper), a
		jp	.loop_redraw

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), <"OFFSET",CHAR_COLON>
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

; not part of d_screen_xys_list so we can use in row headers
d_str_0f:			STRING "0123456789ABCDEF"

	section bss

r_current_column:		dcb.b 1
r_current_row:			dcb.b 1
r_current_tile:			dcb.w 1
r_seek_xy_cb:			dcb.w 1
r_draw_tile_cb:			dcb.w 1
r_tile_offset_upper:		dcb.b 1
r_tile_offset_upper_mask:	dcb.b 1
