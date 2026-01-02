	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/values_edit.inc"

	global values_edit_handler

	section code

DATA_START_COLUMN	equ SCREEN_START_X + 15
DATA_START_ROW		equ SCREEN_START_Y + 2

CURSOR_X_OFFSET		equ SCREEN_START_X - 1
CURSOR_Y_OFFSET		equ SCREEN_START_Y + 2

; params:
;  a0 = ve_settings
;  a1 = ve_list
values_edit_handler:
		move.l	a0, r_ve_settings
		move.l	a1, r_ve_list

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list
		jsr	print_b2_return_to_menu

		; save off as 0 indexed count to r_cursor_max
		jsr	get_ve_entry_count
		subq.b	#$1, d0
		move.b	d0, r_cursor_max

		clr.b	r_cursor
		clr.b	r_cursor_prev

	.loop_redraw_data:
		jsr	print_data
		move.l	r_ve_settings, a1
		move.l	s_ves_value_changed_cb(a1), a1
		jsr	(a1)

	.loop_redraw_cursor:
		; clear old
		moveq	#CURSOR_X_OFFSET, d0
		moveq	#CURSOR_Y_OFFSET, d1
		add.b	r_cursor_prev, d1
		RSUB	screen_seek_xy

		move.b	#CURSOR_CLEAR_CHAR, d0
		RSUB	print_char

		; draw new
		moveq	#CURSOR_X_OFFSET, d0
		moveq	#CURSOR_Y_OFFSET, d1
		add.b	r_cursor, d1
		RSUB	screen_seek_xy

		move.b	#CURSOR_CHAR, d0
		RSUB	print_char

		move.b	r_cursor, r_cursor_prev

		; seek to the correct ve_entry based on the r_cursor
		move.l	r_ve_list, a0
		move.b	r_cursor, d0
	.loop_next_ve_entry:
		cmp.b	#$0, d0
		beq	.loop_input
		add.l	#s_vee_struct_size, a0
		subq.b	#$1, d0
		bra	.loop_next_ve_entry

	.loop_input:
		WATCHDOG

		move.l	r_ve_settings, a1
		move.l	s_ves_loop_input_cb(a1), a1
		movem.l	a0, -(a7)
		jsr	(a1)
		movem.l	(a7)+, a0

		bsr	input_update
		move.b	r_input_edge, d0

		btst	#INPUT_UP_BIT, d0
		beq	.up_not_pressed

		subq.b	#$1, r_cursor
		bpl	.loop_redraw_cursor
		move.b	r_cursor_max, r_cursor
		bra	.loop_redraw_cursor

	.up_not_pressed:
		btst	#INPUT_DOWN_BIT, d0
		beq	.down_not_pressed

		addq.b	#$1, r_cursor
		move.b	r_cursor_max, d0
		cmp.b	r_cursor, d0
		bge	.loop_redraw_cursor
		move.b	#$0, r_cursor
		bra	.loop_redraw_cursor

	.down_not_pressed:
		btst	#INPUT_B2_BIT, d0
		beq	.b2_not_pressed
		rts

	.b2_not_pressed:
		movem.l	a0, -(a7)
		move.l	a0, a1

		move.b	s_vee_input(a1), d0
		cmp.b	#VE_INPUT_EDGE, d0
		beq	.input_edge
		lea	r_input_raw, a0
		bra	.input_setup_done

	.input_edge:
		lea	r_input_edge, a0

	.input_setup_done:
		move.l	s_vee_mask(a1), d0
		move.b	s_vee_type(a1), d1
		move.l	s_vee_address(a1), a1

		cmp.b	#VE_TYPE_3_BYTES, d1
		bne	.not_type_3_bytes
		jsr	joystick_lr_update_long
		bra	.check_value_change

	.not_type_3_bytes:
		cmp.b	#VE_TYPE_WORD, d1
		bne	.not_type_word
		jsr	joystick_lr_update_word
		bra	.check_value_change

	.not_type_word:
		; byte/nibble both use
		jsr	joystick_lr_update_byte

	.check_value_change:
		movem.l	(a7)+, a0
		tst.b	d0
		beq	.loop_input
		bra	.loop_redraw_data

; returns
;  d0 = number of ve entries in the list
get_ve_entry_count:
		move.l	r_ve_list, a0
		moveq	#$0, d0

	.loop_next_entry:
		move.b	s_vee_type(a0), d1
		cmp.b	#$ff, d1
		beq	.list_end
		addq.b	#$1, d0
		add.l	#s_vee_struct_size, a0
		bra	.loop_next_entry

	.list_end:
		rts

print_data:
		move.b	#DATA_START_ROW, r_y_offset
		move.l	r_ve_list, a0

	.loop_next_ve_entry:
		move.b	s_vee_type(a0), d0
		cmp.b	#$ff, d0
		beq	.list_end

		add.b	#DATA_START_COLUMN, d0
		move.b	r_y_offset, d1
		RSUB	screen_seek_xy

		move.l	s_vee_address(a0), a1

		move.b	s_vee_type(a0), d0
		cmp.b	#VE_TYPE_3_BYTES, d0
		beq	.print_3_bytes
		cmp.b	#VE_TYPE_WORD, d0
		beq	.print_word
		cmp.b	#VE_TYPE_BYTE, d0
		beq	.print_byte

		move.b	(a1), d0
		RSUB	print_hex_nibble
		bra	.print_done

	.print_byte:
		move.b	(a1), d0
		RSUB	print_hex_byte
		bra	.print_done

	.print_word:
		move.w	(a1), d0
		RSUB	print_hex_word
		bra	.print_done

	.print_3_bytes:
		move.l	(a1), d0
		RSUB	print_hex_3_bytes

	.print_done:
		add.l	#s_vee_struct_size, a0
		add.b	#$1, r_y_offset
		bra	.loop_next_ve_entry

	.list_end:
		rts

	section data
	align 1

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 2), "UD - SWITCH ATTRIBUTE"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "LR - ADJUST VALUE"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - HOLD TO ADJUST 10X"
	XY_STRING_LIST_END

	section bss
	align 1

r_ve_list:		dcb.l 1
r_ve_settings:		dcb.l 1

r_y_offset:		dcb.b 1

r_cursor:		dcb.b 1
r_cursor_prev:		dcb.b 1
r_cursor_max:		dcb.b 1
