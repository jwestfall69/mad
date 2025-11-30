	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/memory_write.inc"

	global memory_write_handler

START_COLUMN	equ SCREEN_START_X
START_ROW	equ SCREEN_START_Y + 4

	section code

; params:
;  a0 = mw_settings_ptr
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
; constantly printing the couter value to the screen.
memory_write_handler:
		move.l	a0, r_mw_settings

		; make zero indexed
		move.b	s_mw_num_bytes(a0), d0
		subq.b	#$1, d0
		move.b	d0, r_num_bytes

		clr.b	r_active_bit
		clr.b	r_active_byte

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

	.loop_redraw_data:
		jsr	print_data

	.loop_redraw_active:
		move.b	#START_COLUMN + 7, d0
		sub.b	r_active_bit, d0
		move.b	#START_ROW, d1
		add.b	r_active_byte, d1

		RSUB	screen_seek_xy
		move.l	r_mw_settings, a0
		move.l	s_mw_highlight_cb(a0), a0
		jsr	(a0)

	.loop_input:
		WATCHDOG
		move.l	r_mw_settings, a0
		move.l	s_mw_loop_cb(a0), a0
		jsr	(a0)

		jsr	input_update
		move.b	r_input_edge, d0

		btst	#INPUT_UP_BIT, d0
		beq	.up_not_pressed
		subq.b	#$1, r_active_byte
		bpl	.loop_redraw_active
		move.b	r_num_bytes, r_active_byte
		bra	.loop_redraw_active


	.up_not_pressed:
		btst	#INPUT_DOWN_BIT, d0
		beq	.down_not_pressed
		addq.b	#$1, r_active_byte
		move.b	r_active_byte, d1
		cmp.b	r_num_bytes, d1
		ble	.loop_redraw_active
		clr.b	r_active_byte
		bra	.loop_redraw_active

	.down_not_pressed:
		btst	#INPUT_LEFT_BIT, d0
		beq	.left_not_pressed
		addq.b	#$1, r_active_bit
		move.b	r_active_bit, d1
		cmp.b	#$7, d1
		ble	.loop_redraw_active
		clr.b	r_active_bit
		bra	.loop_redraw_active


	.left_not_pressed:
		btst	#INPUT_RIGHT_BIT, d0
		beq	.right_not_pressed
		subq.b	#$1, r_active_bit
		bpl	.loop_redraw_active
		move.b	#$7, r_active_bit
		bra	.loop_redraw_active

	.right_not_pressed:
		btst	#INPUT_B1_BIT, d0
		beq	.b1_not_pressed
		lea	d_xor_table, a0
		move.b	r_active_bit, d1
		and.w	#$ff, d1
		move.b	(a0, d1), d1

		move.l	r_mw_settings, a0
		move.l	s_mw_buffer_ptr(a0), a0
		move.b	r_active_byte, d2
		and.w	#$ff, d2
		move.b	(a0, d2), d3
		eor.b	d1, d3
		move.b	d3, (a0, d2)
		bra	.loop_redraw_data

	.b1_not_pressed:
		btst	#INPUT_B2_BIT, d0
		beq	.loop_input

		move.b	r_input_raw, d0
		btst	#INPUT_RIGHT_BIT, d0
		bne	.do_exit

		move.l	r_mw_settings, a0
		move.l	s_mw_write_memory_cb(a0), a0
		jsr	(a0)
		bra	.loop_input

	.do_exit:
		rts

print_data:
		move.l	r_mw_settings, a1
		move.l	s_mw_buffer_ptr(a1), a1

		moveq	#$0, d5
		move.b	r_num_bytes, d5
	.print_next_byte:
		moveq	#START_COLUMN, d0
		moveq	#START_ROW, d1
		add.b	d5, d1
		RSUB	screen_seek_xy

		move.b	(a1, d5), d0
		RSUB	print_bits_byte

		moveq	#START_COLUMN + 10, d0
		moveq	#START_ROW, d1
		add.b	d5, d1
		RSUB	screen_seek_xy

		move.b	(a1, d5), d0
		RSUB	print_hex_byte
		dbra	d5, .print_next_byte

		rts
	section data
	align 1

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "76543210  HEX"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "JOY   SELECT BIT"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1    TOGGLE BIT"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2    WRITE MEMORY"
	XY_STRING SCREEN_START_X, (SCREEN_B2_Y + 1), "EXIT  HOLD R B2"
	XY_STRING_LIST_END

d_xor_table:	dc.b $01, $02, $04, $08, $10, $20, $40, $80

	section bss
	align 1

r_mw_settings:		dcb.l 1
r_num_bytes:		dcb.b 1
r_active_bit:		dcb.b 1
r_active_byte:		dcb.b 1
