	include "cpu/68000/include/common.inc"

	global tile16_viewer_handler

START_COLUMN	equ SCREEN_START_X + 1
START_ROW	equ SCREEN_START_Y + 7

	section code

; viewer for 16x16 pixel tiles.
; x, y values within the function are based fg tile locations. Its
; up to the r_seek_xy_cb to deal with translating those so the 16x16
; tile show up at the correct location on screen (ie divide them by 2)
; params:
;  d0 = tile offset
;  d1 = offset mask
;  a0 = seek_xy function
;  a1 = draw_tile function
tile16_viewer_handler:
		; we are only able to display 64 tiles (8x8) at a time.
		; r_quadrant is used to pick which 64 tiles to display
		; out the 256 tiles within a given tile offset.
		; 0x0 = top left
		; 0x1 = top right
		; 0x2 = bottom left
		; 0x3 = bottom right
		clr.b	r_quadrant
		move.w	d0, r_tile_offset
		move.w	d1, r_tile_offset_mask
		move.l	a0, r_seek_xy_cb
		move.l	a1, r_draw_tile_cb

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list

	.loop_redraw:
		move.w	r_tile_offset, d6
		move.w	r_tile_offset_mask, d1
		and.w	d1, d6
		move.w	d6, r_tile_offset

		btst	#0, r_quadrant
		bne	.row_8f			; right side?
		lea	d_str_07, a0
		bra	.do_print_row_header

	.row_8f:
		lea	d_str_8f, a0
		addq.l	#$8, d6

	.do_print_row_header:
		SEEK_XY	(START_COLUMN + 3), (SCREEN_START_Y + 4)
		RSUB	print_string

		moveq	#7, d5			; number of rows - 1
		moveq	#START_ROW, d2		; current row number

		btst	#1, r_quadrant
		bne	.column_8f		; bottom
		lea	d_str_07, a1
		bra	.loop_next_row

	.column_8f:
		lea	d_str_8f, a1
		add.l	#$80, d6

	.loop_next_row:
		moveq	#START_COLUMN, d3	; reset with each row

		move.l	d3, d0
		move.l	d2, d1
		RSUB	screen_seek_xy

		move.b	(a1), d0
		RSUB	print_char		; print the row header char
		adda.l	#2, a1			; deal with letter+space in string

		addq.b	#2, d3			; skip from header to first tile position for the row
		moveq	#7, d4			; number of bytes per row - 1

	.loop_next_byte:
		move.l	d3, d0
		move.l	d2, d1
		move.l	r_seek_xy_cb, a0
		jsr	(a0)

		move.w	d6, d0
		move.l	r_draw_tile_cb, a0
		jsr	(a0)

		addq.b	#2, d3			; next 16x16 position over
		addq.b	#1, d6			; next byte to print
		dbra	d4, .loop_next_byte

		addq.b	#2, d2			; next 16x16 row down
		addq.b	#8, d6			; adjust by 8 since we only printing 8 of 16 per row
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

		btst	#INPUT_B1_BIT, d0
		beq	.b1_not_pressed
		move.b	r_quadrant, d0
		addq.b	#$1, d0
		and.b	#$3, d0
		move.b	d0, r_quadrant
		bra	.loop_redraw

	.b1_not_pressed:
		btst	#INPUT_B2_BIT, d0
		beq	.loop_input
		rts

	section data
	align 1

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), <"OFFSET",CHAR_COLON>
	XY_STRING SCREEN_START_X, (SCREEN_B1_Y + 1), "B1 - SWITCH QUAD"
	XY_STRING SCREEN_START_X, (SCREEN_B2_Y + 1), "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

; not part of d_screen_xys_list so we can use in row headers
d_str_07:		STRING "0 1 2 3 4 5 6 7"
d_str_8f:		STRING "8 9 A B C D E F"

	section bss
	align 1

r_seek_xy_cb:		dcb.l 1
r_draw_tile_cb:		dcb.l 1
r_tile_offset:		dcb.w 1
r_tile_offset_mask:	dcb.w 1
r_quadrant:		dcb.b 1
