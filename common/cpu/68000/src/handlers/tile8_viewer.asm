	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"

	include "input.inc"
	include "machine.inc"

	global tile8_viewer_handler

START_COLUMN	equ SCREEN_START_X
START_ROW	equ SCREEN_START_Y + 6

	section code

; params:
;  d0 = tile offset
;  d1 = offset mask
;  a0 = seek_xy function
;  a1 = draw_tile function
tile8_viewer_handler:
		move.w	d0, (r_tile_offset)
		move.w	d1, (r_tile_offset_mask)
		move.l	a0, (r_seek_xy_cb)
		move.l	a1, (r_draw_tile_cb)

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

		SEEK_XY	(START_COLUMN + 2), (SCREEN_START_Y + 4)
		lea	d_str_0f, a0
		RSUB	print_string

	.loop_redraw:
		move.w	(r_tile_offset), d6
		move.w	(r_tile_offset_mask), d1
		and.w	d1, d6
		move.w	d6, (r_tile_offset)

		moveq	#15, d5			; number of rows - 1
		moveq	#START_ROW, d2		; current row number

		lea	d_str_0f, a1

	.loop_next_row:
		moveq	#START_COLUMN, d3	; reset with each row

		move.l	d3, d0
		move.l	d2, d1
		RSUB	screen_seek_xy

		move.b	(a1)+, d0
		RSUB	print_char		; print the row header char

		addq.b	#2, d3			; skip from header to first tile position for the row
		moveq	#15, d4			; number of bytes per row - 1

	.loop_next_byte:
		move.l	d3, d0
		move.l	d2, d1
		move.l	(r_seek_xy_cb), a0
		jsr	(a0)

		move.w	d6, d0
		move.l	(r_draw_tile_cb), a0
		jsr	(a0)

		addq.b	#1, d3			; next position over
		addq.b	#1, d6			; next byte to print
		dbra	d4, .loop_next_byte

		addq.b	#1, d2			; next row
		dbra	d5, .loop_next_row

	.loop_input:
		WATCHDOG

		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 2)
		move.w	r_tile_offset, d0
		RSUB	print_hex_word

		bsr	input_update
		move.b	r_input_edge, d0

		btst	#INPUT_UP_BIT, d0
		beq	.up_not_pressed
		add.w	#$100, r_tile_offset
		bra	.loop_redraw
	.up_not_pressed:

		btst	#INPUT_DOWN_BIT, d0
		beq	.down_not_pressed
		sub.w	#$100, r_tile_offset
		bra	.loop_redraw
	.down_not_pressed:

		btst	#INPUT_LEFT_BIT, d0
		beq	.left_not_pressed
		sub.w	#$1000, r_tile_offset
		bra	.loop_redraw
	.left_not_pressed:

		btst	#INPUT_RIGHT_BIT, d0
		beq	.right_not_pressed
		add.w	#$1000, r_tile_offset
		bra	.loop_redraw
	.right_not_pressed:

		btst	#INPUT_B2_BIT, d0
		beq	.loop_input
		rts

	section data
	align 2

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), <"OFFSET",CHAR_COLON>
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

; not part of d_screen_xys_list so we can use in row headers
d_str_0f:		STRING "0123456789ABCDEF"

	section bss
	align 2

r_seek_xy_cb:		dc.l	$0
r_draw_tile_cb:		dc.l	$0
r_tile_offset:		dc.w	$0
r_tile_offset_mask:	dc.w	$0
