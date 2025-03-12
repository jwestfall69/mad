	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/dsub.inc"
	include "cpu/z80/include/xy_string.inc"
	include "global/include/screen.inc"

	include "machine.inc"
	include "input.inc"

	global memory_viewer_handler

	section code

NUM_ROWS	equ 20
START_ROW	equ SCREEN_START_Y + 3

; params:
;  ix = start address
memory_viewer_handler:
		RSUB 	screen_init
		ld 	de, d_screen_xys_list
		call	print_xy_string_list

	.loop_next_input:
		WATCHDOG

		push	ix
		call	memory_dump
		pop	ix

		call	input_update
		ld	a, (r_input_edge)

		bit	INPUT_UP_BIT, a
		jr	z, .up_not_pressed
		ld	bc, 4
		jr	.sub_offset

	.up_not_pressed:
		bit	INPUT_DOWN_BIT, a
		jr	z, .down_not_pressed
		ld	bc, 4
		add	ix, bc
		jr	.loop_next_input

	.down_not_pressed:
		bit	INPUT_LEFT_BIT, a
		jr	z, .left_not_pressed
		ld	bc, $50
		jr	.sub_offset

	.left_not_pressed:
		bit	INPUT_RIGHT_BIT, a
		jr	z, .right_not_pressed
		ld	bc, $50
		add	ix, bc
		jr	.loop_next_input

	.right_not_pressed:
		bit	INPUT_B2_BIT, a
		jr	z, .loop_next_input
		ret

	.sub_offset:
		push	ix
		pop	hl
		sbc	hl, bc
		push	hl
		pop	ix
		jr	.loop_next_input


memory_dump:
		ld	a, NUM_ROWS
		ld	(r_remaining_rows), a

		ld	iy, r_current_row
		ld	(iy), START_ROW
	.loop_next_address:
		; address
		ld	b, SCREEN_START_X
		ld	c, (iy)
		RSUB	screen_seek_xy

		push	ix
		pop	bc
		RSUB	print_hex_word

		; 1st word
		ld	b, SCREEN_START_X + 6
		ld	c, (iy)
		RSUB	screen_seek_xy

		ld	b, (ix + 0)
		ld	c, (ix + 1)
		RSUB	print_hex_word

		; 2nd word
		ld	b, SCREEN_START_X + 11
		ld	c, (iy)
		RSUB	screen_seek_xy

		ld	b, (ix + 2)
		ld	c, (ix + 3)
		RSUB	print_hex_word

		; 1st char
		ld	b, SCREEN_START_X + 17
		ld	c, (iy)
		RSUB	screen_seek_xy

		ld	c, (ix + 0)
		RSUB	print_char

		; 2st char
		ld	b, SCREEN_START_X + 18
		ld	c, (iy)
		RSUB	screen_seek_xy

		ld	c, (ix + 1)
		RSUB	print_char

		; 3st char
		ld	b, SCREEN_START_X + 19
		ld	c, (iy)
		RSUB	screen_seek_xy

		ld	c, (ix + 2)
		RSUB	print_char

		; 4st char
		ld	b, SCREEN_START_X + 20
		ld	c, (iy)
		RSUB	screen_seek_xy

		ld	c, (ix + 3)
		RSUB	print_char

		push	ix
		pop	hl
		ld	bc, 4
		add	hl, bc
		push 	hl
		pop	ix

		inc	(iy)

		ld	a, (r_remaining_rows)
		dec	a
		jr	z, .all_done
		ld	(r_remaining_rows), a
		jp	.loop_next_address

	.all_done:
		ret

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "MEMORY VIEWER"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "ADDR"
	XY_STRING (SCREEN_START_X + 8), (SCREEN_START_Y + 2), "DATA"
	XY_STRING (SCREEN_START_X + 17), (SCREEN_START_Y + 2), "CHAR"
	XY_STRING_LIST_END

	section bss
r_current_row		dc.b $0
r_remaining_rows	dc.b $0

