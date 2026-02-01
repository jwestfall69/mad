	include "cpu/z80/include/common.inc"

	global tile_16x16_viewer_handler

COLUMN_START	equ SCREEN_START_X + 1
COLUMN_END	equ COLUMN_START + 18
ROW_START	equ SCREEN_START_Y + 7
ROW_END		equ ROW_START + 16

	section code

; params:
;  b = tile offset upper
;  c = offset mask upper
;  de = seek_xy function
;  hl = draw_tile function
tile_16x16_viewer_handler:
		ld	a, b
		ld	(r_tile_offset_upper), a
		ld	a, c
		ld	(r_tile_offset_upper_mask), a
		ld	(r_seek_xy_cb), de
		ld	(r_draw_tile_cb), hl

		ld	a, $0
		ld	(r_quadrant), a

		ld	de, d_screen_xys_list
		call	print_xy_string_list

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

		ld	a, (r_quadrant)
		bit	0, a
		jr	nz, .row_8f
		ld	de, d_str_07
		jr	.do_print_row_header


	.row_8f:
		ld	de, d_str_8f
		ld	bc, (r_current_tile)
		ld	a, $8
		add	c
		ld	c, a
		ld	(r_current_tile), bc


	.do_print_row_header:
		SEEK_XY	(COLUMN_START + 2), (SCREEN_START_Y + 5)
		RSUB	print_string

		ld	a, ROW_START
		ld	(r_current_row), a

		ld	a, (r_quadrant)
		bit	1, a
		jr	nz, .column_8f
		ld	ix, d_str_07
		jr	.loop_next_row

	.column_8f:
		ld	ix, d_str_8f
		ld	bc, (r_current_tile)
		ld	a, $80
		add	c
		ld	c, a
		ld	(r_current_tile), bc

	.loop_next_row:
		ld	a, COLUMN_START
		ld	(r_current_column), a

		; seek/print row header
		ld	b, a
		ld	a, (r_current_row)
		ld	c, a
		RSUB	screen_seek_xy

		ld	c, (ix)
		RSUB	print_char
		inc	ix
		inc	ix		; deal with letter+space in tring

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
		inc	a
		ld	(r_current_column), a
		cp	COLUMN_END
		jr	nz, .loop_next_byte

		ld	bc, (r_current_tile)	; adjust by 8 since we only printing 8 of 16 per row
		ld	a, $8
		add	c
		ld	c, a
		ld	(r_current_tile), bc

		ld	a, (r_current_row)
		inc	a
		inc	a
		ld	(r_current_row), a
		cp	ROW_END
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
		bit	INPUT_B1_BIT, b
		jr	z, .b1_not_pressed
		ld	a, (r_quadrant)
		inc	a
		and	$3
		ld	(r_quadrant), a
		jp	.loop_redraw

	.b1_not_pressed:
		bit	INPUT_B2_BIT, b
		jp	z, .loop_next_input
		ret

	.update_tile_offset_upper:
		ld	(r_tile_offset_upper), a
		jp	.loop_redraw

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), <"OFFSET",CHAR_COLON>
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - SWITCH QUAD"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

; not part of d_screen_xys_list so we can use in row headers
d_str_07:			STRING "0 1 2 3 4 5 6 7"
d_str_8f:			STRING "8 9 A B C D E F"

	section bss

r_current_column:		dcb.b 1
r_current_row:			dcb.b 1
r_current_tile:			dcb.w 1
r_seek_xy_cb:			dcb.w 1
r_draw_tile_cb:			dcb.w 1
r_tile_offset_upper:		dcb.b 1
r_tile_offset_upper_mask:	dcb.b 1
r_quadrant:			dcb.b 1
