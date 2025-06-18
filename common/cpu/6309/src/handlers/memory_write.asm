	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"
	include "cpu/6309/include/handlers/memory_write.inc"

	include "input.inc"
	include "machine.inc"

	global memory_write_handler

START_COLUMN	equ SCREEN_START_X
START_ROW	equ SCREEN_START_Y + 4

	section code

; params:
;  x = mw_settings_ptr
memory_write_handler:
		stx	r_mw_settings
		lda	s_mw_num_bytes, x
		deca
		sta	r_num_bytes		; saving off 0 indexed

		clr	r_active_bit
		clr	r_active_byte

		ldy	#d_screen_xys_list
		PSUB	print_xy_string_list

	.loop_redraw_data:
		jsr	print_data

	.loop_redraw_active:
		lda	#START_COLUMN + 7
		suba	r_active_bit
		ldb	#START_ROW
		addb	r_active_byte

		PSUB	screen_seek_xy

		ldy	r_mw_settings
		jsr	[s_mw_highlight_cb, y]

	.loop_input:
		WATCHDOG
		ldy	r_mw_settings
		jsr	[s_mw_loop_cb, y]

		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_UP
		beq	.up_not_pressed
		dec	r_active_byte
		bpl	.loop_redraw_active
		lda	r_num_bytes
		sta	r_active_byte
		bra	.loop_redraw_active

	.up_not_pressed:
		bita	#INPUT_DOWN
		beq	.down_not_pressed
		inc	r_active_byte
		lda	r_active_byte
		cmpa	r_num_bytes
		ble	.loop_redraw_active
		clr	r_active_byte
		bra	.loop_redraw_active

	.down_not_pressed:
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		inc	r_active_bit
		lda	r_active_bit
		cmpa	#$7
		ble	.loop_redraw_active
		clr	r_active_bit
		bra	.loop_redraw_active

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		dec	r_active_bit
		bpl	.loop_redraw_active
		lda	#$7
		sta	r_active_bit
		bra	.loop_redraw_active

	.right_not_pressed:
		bita	#INPUT_B1
		beq	.b1_not_pressed

		ldy	#d_xor_table
		lda	r_active_bit
		ldb	a, y
		stb	r_scratch

		lda	r_active_byte
		ldy	r_mw_settings
		ldy	s_mw_buffer_ptr, y

		ldb	a, y
		eorb	r_scratch
		stb	a, y
		lbra	.loop_redraw_data

	.b1_not_pressed:
		bita	#INPUT_B2
		lbeq	.loop_input

		lda	r_input_raw
		bita	#INPUT_RIGHT
		bne	.do_exit

		ldy	r_mw_settings
		jsr	[s_mw_write_memory_cb, y]
		lbra	.loop_input

	.do_exit:
		rts

	section data

print_data:
		ldy	r_mw_settings
		ldy	s_mw_buffer_ptr, y

		ldb	r_num_bytes
		stb	r_scratch
	.print_next_byte:
		lda	#START_COLUMN
		ldb	#START_ROW
		addb	r_scratch
		PSUB	screen_seek_xy

		ldb	r_scratch
		lda	b, y
		PSUB	print_bits_byte

		lda	#START_COLUMN + 10
		ldb	#START_ROW
		addb	r_scratch
		PSUB	screen_seek_xy

		ldb	r_scratch
		lda	b, y
		PSUB	print_hex_byte

		dec	r_scratch
		bpl	.print_next_byte
		rts

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "76543210  HEX"
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y - 1), "JOY - SELECT BIT"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - TOGGLE BIT"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - WRITE MEMORY"
	XY_STRING SCREEN_START_X, (SCREEN_B2_Y + 1), "EXIT - HOLD R + B2"
	XY_STRING_LIST_END

d_xor_table:	dc.b $01, $02, $04, $08, $10, $20, $40, $80

	section bss

r_mw_settings:		dcb.w 1
r_num_bytes:		dcb.b 1
r_active_bit:		dcb.b 1
r_active_byte:		dcb.b 1
