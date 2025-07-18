	include "cpu/6x09/include/common.inc"
	include "cpu/6x09/include/handlers/values_edit.inc"

	global values_edit_handler

	section code

DATA_START_COLUMN	equ SCREEN_START_X + 15
DATA_START_ROW		equ SCREEN_START_Y + 2

CURSOR_X_OFFSET		equ SCREEN_START_X - 1
CURSOR_Y_OFFSET		equ SCREEN_START_Y + 2

; params:
;  x = ve_settings
;  y = ve_list
values_edit_handler:
		stx	r_ve_settings
		sty	r_ve_list

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list
		jsr	print_b2_return_to_menu

		; save off as 0 indexed count to r_cursor_max
		jsr	get_ve_entry_count
		deca
		sta	r_cursor_max

		clra
		sta	r_cursor
		sta	r_cursor_prev

	.loop_redraw_data:
		jsr	print_data
		ldx	r_ve_settings
		jsr	[s_ves_value_changed_cb, x]

	.loop_redraw_cursor:
		; remove old cursor
		lda	#CURSOR_X_OFFSET
		ldb	r_cursor_prev
		addb	#CURSOR_Y_OFFSET
		RSUB	screen_seek_xy

		lda	#CURSOR_CLEAR_CHAR
		RSUB	print_char

		; draw new cursor
		lda	#CURSOR_X_OFFSET
		ldb	r_cursor
		addb	#CURSOR_Y_OFFSET
		RSUB	screen_seek_xy

		lda	#CURSOR_CHAR
		RSUB	print_char

		lda	r_cursor
		sta	r_cursor_prev

		; seek to the correct ve_entry based on the r_cursor
		ldy	r_ve_list
		lda	r_cursor
	.loop_next_ve_entry:
		cmpa	#$0
		beq	.loop_input
		leay	s_vee_struct_size, y
		deca
		bra	.loop_next_ve_entry

	.loop_input:
		WATCHDOG
		ldx	r_ve_settings
		pshs	y
		jsr	[s_ves_loop_input_cb, x]
		puls	y

		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_UP
		beq	.up_not_pressed
		dec	r_cursor
		bpl	.loop_redraw_cursor
		lda	r_cursor_max
		sta	r_cursor
		bra	.loop_redraw_cursor
	.up_not_pressed:

		bita	#INPUT_DOWN
		beq	.down_not_pressed
		inc	r_cursor
		lda	r_cursor
		cmpa	r_cursor_max
		lble	.loop_redraw_cursor
		clr	r_cursor
		lbra	.loop_redraw_cursor

	.down_not_pressed:
		bita	#INPUT_B2
		beq	.b2_not_pressed
		rts

	.b2_not_pressed:
		pshs	y

		lda	s_vee_input, y
		cmpa	#VE_INPUT_EDGE
		beq	.input_edge
		ldx	#r_input_raw
		bra	.input_setup_done

	.input_edge:
		ldx	#r_input_edge

	.input_setup_done:

		lda	s_vee_type, y
		cmpa	#VE_TYPE_WORD
		beq	.type_word

		lda	s_vee_mask + 1, y
		ldy	s_vee_address, y
		jsr	joystick_lr_update_byte
		bra	.check_value_change

	.type_word:
		ldd	s_vee_mask, y
		ldy	s_vee_address, y
		jsr	joystick_lr_update_word

	.check_value_change:
		puls	y
		cmpa	#$0
		lbeq	.loop_input
		lbra	.loop_redraw_data

; returns
;  a = number of ve entries in the list
get_ve_entry_count:
		ldy	r_ve_list
		clra

	.loop_next_ve_entry:
		ldb	s_vee_type, y
		cmpb	#$ff
		beq	.list_end
		inca

		leay	s_vee_struct_size, y
		bra	.loop_next_ve_entry

	.list_end:
		rts

print_data:
		lda	#DATA_START_ROW
		sta	r_y_offset
		ldy	r_ve_list

	.loop_next_ve_entry:
		lda	s_vee_type, y
		cmpa	#$ff		; end of list byte
		beq	.list_end

		adda	#DATA_START_COLUMN
		ldb	r_y_offset
		RSUB	screen_seek_xy

		; print hex will clobber
		pshs	y

		lda	s_vee_type, y
		cmpa	#VE_TYPE_WORD
		beq	.print_word
		cmpa	#VE_TYPE_BYTE
		beq	.print_byte

		lda	[s_vee_address, y]
		RSUB	print_hex_nibble
		bra	.print_done

	.print_byte:
		lda	[s_vee_address, y]
		RSUB	print_hex_byte
		bra	.print_done

	.print_word:
		ldd	[s_vee_address, y]
		RSUB	print_hex_word

	.print_done:
		puls	y
		leay	s_vee_struct_size, y
		inc	r_y_offset
		bra	.loop_next_ve_entry

	.list_end:
		rts

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
r_ve_settings:		dcb.w 1

r_y_offset:		dcb.b 1

r_cursor:		dcb.b 1
r_cursor_prev:		dcb.b 1
r_cursor_max:		dcb.b 1
