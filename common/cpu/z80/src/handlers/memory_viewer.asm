	include "cpu/z80/include/common.inc"

	global memory_viewer_handler

	section code

; params:
;  ix = start address
;  iy = read_memory_cb or #$0000 to use default memory read
; read_memory_cb params:
;  ix = address to start reading from
;  iy = address to start writing data
;  function should write a long worth of data at iy
memory_viewer_handler:
		ld	(r_read_memory_cb), iy

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


ROW_START	equ SCREEN_START_Y + 3
ROW_END		equ ROW_START + 20
; params:
;  ix = start address
memory_dump:
		ld	(r_dump_address), ix
		ld	iy, r_dump_row
		ld	(iy), ROW_START

	.loop_next_address:
		ld	iy, r_dump_data

		; if a cb was supplied use that, otherwise
		; just do normal reads
		ld	a, $0
		ld	bc, (r_read_memory_cb)
		cp	b
		jr	nz, .has_read_memory_cb
		cp	c
		jr	nz, .has_read_memory_cb

		ld	ix, (r_dump_address)
		ld	b, (ix)
		ld	(iy), b
		ld	b, (ix + 1)
		ld	(iy + 1), b
		ld	b, (ix + 2)
		ld	(iy + 2), b
		ld	b, (ix + 3)
		ld	(iy + 3), b
		jr	.read_memory_done

	.has_read_memory_cb:
		ld	ix, r_read_memory_cb
		ld	l, (ix)
		ld	h, (ix + 1)

		ld	ix, (r_dump_address)
		ld	de, .read_memory_done
		push	de
		jp	(hl)

	.read_memory_done:
		ld	ix, r_dump_data
		ld	iy, r_dump_row

		; address
		ld	b, SCREEN_START_X
		ld	c, (iy)
		RSUB	screen_seek_xy

		ld	bc, (r_dump_address)
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

		ld	hl, (r_dump_address)
		ld	bc, 4
		add	hl, bc
		ld	(r_dump_address), hl

		inc	(iy)
		ld	a, ROW_END
		cp	(iy)
		jp	nz, .loop_next_address
		ret

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "MEMORY VIEWER"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "ADDR"
	XY_STRING (SCREEN_START_X + 8), (SCREEN_START_Y + 2), "DATA"
	XY_STRING (SCREEN_START_X + 17), (SCREEN_START_Y + 2), "CHAR"
	XY_STRING_LIST_END

	section bss

r_read_memory_cb:	dcb.w 1
r_dump_address:		dcb.w 1
r_dump_data:		dcb.w 2
r_dump_row		dcb.b 1

