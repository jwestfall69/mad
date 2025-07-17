	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/values_edit.inc"

	global values_edit_handler

	section code

DATA_START_COLUMN	equ SCREEN_START_X + 15
DATA_START_ROW		equ SCREEN_START_Y + 2

CURSOR_X_OFFSET		equ SCREEN_START_X - 1
CURSOR_Y_OFFSET		equ SCREEN_START_Y + 2

; params:
;  ix = ve_settings
;  iy = ve_list
values_edit_handler:
		ld	l, (ix + s_ves_value_changed_cb)
		ld	h, (ix + s_ves_value_changed_cb + 1)
		ld	(r_value_changed_cb), hl

		ld	l, (ix + s_ves_loop_input_cb)
		ld	h, (ix + s_ves_loop_input_cb + 1)
		ld	(r_loop_input_cb), hl

		ld	(r_ve_list), iy

		ld	de, d_screen_xys_list
		call	print_xy_string_list
		call	print_b2_return_to_menu

		; save off as 0 indexed count to r_cursor_max
		call	get_ve_entry_count
		dec	a
		ld	(r_cursor_max), a

		ld	a, $0
		ld	(r_cursor), a
		ld	(r_cursor_prev), a

	.loop_redraw_data:
		call	print_data
		ld	hl, (r_value_changed_cb)
		ld	de, .loop_redraw_cursor
		push	de
		jp	(hl)

	.loop_redraw_cursor:
		; remove old cursor
		ld	b, CURSOR_X_OFFSET
		ld	a, (r_cursor_prev)
		add	a, CURSOR_Y_OFFSET
		ld	c, a
		RSUB	screen_seek_xy

		ld	c, CURSOR_CLEAR_CHAR
		RSUB	print_char

		; draw new cursor
		ld	b, CURSOR_X_OFFSET
		ld	a, (r_cursor)
		add	a, CURSOR_Y_OFFSET
		ld	c, a
		RSUB	screen_seek_xy
		ld	c, CURSOR_CHAR
		RSUB	print_char

		; seek to the correct ve_entry based on the r_cursor
		ld	ix, (r_ve_list)
		ld	a, (r_cursor)
		ld	bc, s_vee_struct_size
	.loop_next_ve_entry:
		cp	$0
		jr	z, .loop_input
		add	ix, bc
		dec	a
		jr	.loop_next_ve_entry

	.loop_input:
		WATCHDOG
		ld	hl, (r_loop_input_cb)
		ld	de, .loop_input_cb_return
		push	ix
		push	de
		jp	(hl)

	.loop_input_cb_return:
		pop	ix
		call	input_update
		ld	a, (r_input_edge)

		bit	INPUT_UP_BIT, a
		jr	z, .up_not_pressed
		ld	a, (r_cursor)
		ld	(r_cursor_prev), a
		dec	a
		ld	(r_cursor), a
		jp	p, .loop_redraw_cursor
		ld	a, (r_cursor_max)
		ld	(r_cursor), a
		jr	.loop_redraw_cursor

	.up_not_pressed:
		bit	INPUT_DOWN_BIT, a
		jr	z, .down_not_pressed
		ld	a, (r_cursor_max)
		ld	b, a
		; deal with no a > b compare instruction
		inc	b
		ld	a, (r_cursor)
		ld	(r_cursor_prev), a
		inc	a
		ld	(r_cursor), a
		cp	b
		jp	m, .loop_redraw_cursor
		ld	a, $0
		ld	(r_cursor), a
		jr	.loop_redraw_cursor

	.down_not_pressed:
		bit	INPUT_B2_BIT, a
		jr	z, .b2_not_pressed
		ret

	.b2_not_pressed:
		; get iy pointing at the entry's variable address
		ld	e, (ix + s_vee_address)
		ld	d, (ix + s_vee_address + 1)
		push	de
		pop	iy

		ld	a, (ix + s_vee_input)
		cp	VE_INPUT_EDGE
		jr	z, .input_edge
		ld	de, r_input_raw
		jr	.input_setup_done

	.input_edge:
		ld	de, r_input_edge

	.input_setup_done:
		push	ix
		ld	a, (ix + s_vee_type)
		cp	VE_TYPE_WORD
		jr	z, .type_word

		ld	a, (ix + s_vee_mask)
		push	de
		pop	ix
		call	joystick_lr_update_byte
		jr	.check_value_change

	.type_word:
		ld	c, (ix + s_vee_mask)
		ld	b, (ix + s_vee_mask + 1)
		push	de
		pop	ix
		call	joystick_lr_update_word

	.check_value_change:
		pop	ix
		cp	$0
		jp	z, .loop_input
		jp	.loop_redraw_data

; returns
;  a = number of ve entries in the list
get_ve_entry_count:
		ld	ix, (r_ve_list)
		ld	d, $0

	.loop_next_ve_entry:
		ld	a, (ix + s_vee_type)
		cp	$ff
		jr	z, .list_end
		inc	d

		ld	bc, s_vee_struct_size
		add	ix, bc
		jr	.loop_next_ve_entry

	.list_end:
		ld	a, d
		ret

print_data:
		ld	a, DATA_START_ROW
		ld	(r_y_offset), a
		ld	ix, (r_ve_list)

	.loop_next_ve_entry:
		ld	a, (ix + s_vee_type)
		cp	$ff		; end of list byte
		jr	z, .list_end

		add	a, DATA_START_COLUMN
		ld	b, a
		ld	a, (r_y_offset)
		ld	c, a
		RSUB	screen_seek_xy

		; get iy pointing at the entry's variable address
		ld	e, (ix + s_vee_address)
		ld	d, (ix + s_vee_address + 1)
		push	de
		pop	iy

		; read in the byte
		ld	c, (iy)

		ld	a, (ix + s_vee_type)
		cp	VE_TYPE_WORD
		jr	z, .print_word
		cp	VE_TYPE_BYTE
		jr	z, .print_byte
		RSUB	print_hex_nibble
		jr	.print_done

	.print_byte:
		RSUB	print_hex_byte
		jr	.print_done

	.print_word:
		; read in 2nd byte to make the word
		ld	b, (iy + 1)
		RSUB	print_hex_word

	.print_done:
		ld	bc, s_vee_struct_size
		add	ix, bc

		ld	a, (r_y_offset)
		inc	a
		ld	(r_y_offset), a

		jr	.loop_next_ve_entry

	.list_end:
		ret

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 2), "UD - SWITCH ATTRIBUTE"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "LR - ADJUST VALUE"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - HOLD TO ADJUST 10X"
	XY_STRING_LIST_END

	section bss

r_value_changed_cb:	dcb.w 1
r_loop_input_cb:	dcb.w 1

r_ve_list:		dcb.w 1

r_y_offset:		dcb.b 1

r_cursor:		dcb.b 1
r_cursor_prev:		dcb.b 1
r_cursor_max:		dcb.b 1
