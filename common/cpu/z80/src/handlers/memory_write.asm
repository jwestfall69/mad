	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_write.inc"

	global memory_write_handler

START_COLUMN	equ SCREEN_START_X
START_ROW	equ SCREEN_START_Y + 4

	section code

; params:
;  ix = mw_settings_ptr
; callbacks:
;  highlight_cb (params: x is at seek_xy)
;   This is responsible for applying a highlight to the char at the
;   tile address at x and also removing the highlight from the
;   previous's calls x address.
;  write_memory_cb (no params)
;   The is called when the user presses B2 to write memory.  You
;   should write the contents of your buffer to your memory location
;   and print whatever you see fit on screen. ie: last written.
;  loop_cb (no params)
;   This is called each input loop and can be used for monitoring
;   or displaying stuff outside of the user doing a write.  ie: if
;   you wanted to test nmi enable/disable, you could have an nmi
;   handler that increments a counter and then have this callback
; constantly printing the counter value to the screen.
memory_write_handler:
		; save off 0 indexed
		ld	a, (ix + s_mw_num_bytes)
		dec	a
		ld	(r_num_bytes), a

		; save off so we don't have to extract it multiple times
		ld	l, (ix + s_mw_buffer_ptr)
		ld	h, (ix + s_mw_buffer_ptr + 1)
		ld	(r_mw_buffer), hl

		ld	a, $0
		ld	(r_active_bit), a
		ld	(r_active_byte), a

		ld	de, d_screen_xys_list
		call	print_xy_string_list

	.loop_redraw_data:
		call	print_data

	.loop_redraw_active:
		ld	a, (r_active_bit)
		ld	b, a
		ld	a, START_COLUMN + 7
		sub	b
		ld	b, a

		ld	a, (r_active_byte)
		add	a, START_ROW
		ld	c, a
		RSUB	screen_seek_xy

		; hl is being used by screen xy location
		; so we need to use iy for jump/cb
		ld	e, (ix + s_mw_highlight_cb)
		ld	d, (ix + s_mw_highlight_cb + 1)
		push	de
		pop	iy

		ld	de, .highlight_cb_return
		push	ix
		push	de
		jp	(iy)

	.highlight_cb_return:
		pop	ix

	.loop_input:
		WATCHDOG
		ld	de, .loop_cb_return
		ld	l, (ix + s_mw_loop_cb)
		ld	h, (ix + s_mw_loop_cb + 1)
		push	ix
		push	de
		jp	(hl)

	.loop_cb_return:
		pop	ix
		call	input_update
		ld	a, (r_input_edge)

		bit	INPUT_UP_BIT, a
		jr	z, .up_not_pressed
		ld	a, (r_active_byte)
		dec	a
		ld	(r_active_byte), a
		jp	p, .loop_redraw_active
		ld	a, (r_num_bytes)
		ld	(r_active_byte), a
		jr	.loop_redraw_active

	.up_not_pressed:
		bit	INPUT_DOWN_BIT, a
		jr	z, .down_not_pressed
		ld	a, (r_num_bytes)
		ld	b, a
		inc	b
		ld	a, (r_active_byte)
		inc	a
		ld	(r_active_byte), a
		cp	b
		jp	m, .loop_redraw_active
		ld	a, $0
		ld	(r_active_byte), a
		jr	.loop_redraw_active

	.down_not_pressed:
		bit	INPUT_LEFT_BIT, a
		jr	z, .left_not_pressed
		ld	a, (r_active_bit)
		inc	a
		ld	(r_active_bit), a
		cp	$7 + 1
		jp	m, .loop_redraw_active
		ld	a, $0
		ld	(r_active_bit), a
		jp	.loop_redraw_active

	.left_not_pressed:
		bit	INPUT_RIGHT_BIT, a
		jr	z, .right_not_pressed
		ld	a, (r_active_bit)
		dec	a
		ld	(r_active_bit), a
		jp	p, .loop_redraw_active
		ld	a, $7
		ld	(r_active_bit), a
		jp	.loop_redraw_active

	.right_not_pressed:
		bit	INPUT_B1_BIT, a
		jr	z, .b1_not_pressed

		ld	hl, d_xor_table
		ld	a, (r_active_bit)
		ld	c, a

		ld	b, $0
		add	hl, bc
		ld	d, (hl)

		ld	hl, (r_mw_buffer)
		ld	a, (r_active_byte)
		ld	c, a

		ld	b, $0
		add	hl, bc
		ld	a, (hl)
		xor	d
		ld	(hl), a
		jp	.loop_redraw_data

	.b1_not_pressed:
		bit	INPUT_B2_BIT, a
		jp	z, .loop_input

		ld	a, (r_input_raw)
		bit	INPUT_RIGHT_BIT, a
		jr	nz, .do_exit

		ld	de, .write_memory_cb_return
		ld	l, (ix + s_mw_write_memory_cb)
		ld	h, (ix + s_mw_write_memory_cb + 1)
		push	ix
		push	de
		jp	(hl)

	.write_memory_cb_return:
		pop	ix
		jp	.loop_input


	.do_exit:
		ret


print_data:
		ld	iy, (r_mw_buffer)
		ld	a, (r_num_bytes)
		ld	(r_scratch), a
		ld	c, a
		ld	b, $0
		add	iy, bc

	.print_next_byte:
		ld	b, START_COLUMN
		ld	a, (r_scratch)
		add	a, START_ROW
		ld	c, a
		RSUB	screen_seek_xy

		ld	c, (iy)
		RSUB	print_bits_byte

		ld	b, START_COLUMN + 10
		ld	a, (r_scratch)
		add	a, START_ROW
		ld	c, a
		RSUB	screen_seek_xy

		ld	c, (iy)
		RSUB	print_hex_byte

		ld	bc, -$1
		add	iy, bc

		ld	a, (r_scratch)
		dec	a
		ld	(r_scratch), a
		jp	p, .print_next_byte
		ret

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "76543210  HEX"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "JOY   SELECT BIT"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1    TOGGLE BIT"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2    WRITE MEMORY"
	XY_STRING SCREEN_START_X, (SCREEN_B2_Y + 1), "EXIT  HOLD R B2"
	XY_STRING_LIST_END

d_xor_table:	dc.b $01, $02, $04, $08, $10, $20, $40, $80

	section bss

r_mw_buffer:		dcb.w 1
r_num_bytes:		dcb.b 1
r_active_bit:		dcb.b 1
r_active_byte:		dcb.b 1
