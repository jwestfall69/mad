	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/xy_string.inc"

	include "input.inc"
	include "machine.inc"

	global tile16_viewer_handler

START_COLUMN	equ SCREEN_START_X + 1
START_ROW	equ SCREEN_START_Y + 7

	section code

; viewer for 16x16 pixel tiles.
; x, y values within the function are based fg tile locations. Its
; up to the r_seek_xy_cb to deal with translating those so the 16x16
; tile show up at the correct location on screen (ie divide them by 2)
; params:
;  d = tile offset
;  w = offset mask
;  x = seek_xy function
;  y = draw_tile function
tile16_viewer_handler:
		; we are only able to display 64 tiles (8x8) at a time.
		; r_quadrant is used to pick which 64 tiles to display
		; out the 256 tiles within a given tile offset.
		; 0x0 = top left
		; 0x1 = top right
		; 0x2 = bottom left
		; 0x3 = bottom right
		clr	r_quadrant
		std	r_tile_offset
		stw	r_tile_offset_mask
		stx	r_seek_xy_cb
		sty	r_draw_tile_cb

		ldy	#d_screen_xys_list
		RSUB	print_xy_string_list

	.loop_redraw:
		ldd	r_tile_offset
		ldw	r_tile_offset_mask

		andr	w, d
		std	r_tile_offset
		std	r_current_tile

		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 2)
		RSUB	print_hex_word

		lda	r_quadrant
		bita	#$1
		bne	.row_8f
		ldy	#d_str_07
		bra	.do_print_row_header

	.row_8f:
		ldy	#d_str_8f
		ldd	r_current_tile
		addd	#$8
		std	r_current_tile

	.do_print_row_header:
		SEEK_XY	(START_COLUMN + 2), (SCREEN_START_Y + 4)
		RSUB	print_string

		ldf	#$8	; number or rows
		lda	#START_ROW
		sta	r_current_row

		lda	r_quadrant
		bita	#$2
		bne	.column_8f
		ldy	#d_str_07
		bra	.loop_next_row

	.column_8f:
		ldy	#d_str_8f
		ldd	r_current_tile
		addd	#$80
		std	r_current_tile

	.loop_next_row:
		lda	#START_COLUMN
		sta	r_current_column

		ldb	r_current_row
		RSUB	screen_seek_xy

		lda	, y
		RSUB	print_char
		leay	2, y		; deal with letter+space in string

		inc	r_current_column
		inc	r_current_column

		lde	#$8	; number of columns

	.loop_next_byte:
		lda	r_current_column
		ldb	r_current_row
		jsr	[r_seek_xy_cb]

		ldd	r_current_tile
		jsr	[r_draw_tile_cb]

		inc	r_current_column
		inc	r_current_column
		ldd	r_current_tile
		addd	#$1
		std	r_current_tile

		dece
		bne	.loop_next_byte

		inc	r_current_row
		inc	r_current_row
		ldd	r_current_tile	; adjust by 8 since we only printing 8 of 16 per row
		addd	#$8
		std	r_current_tile

		decf
		bne	.loop_next_row

	.loop_next_input:
		WATCHDOG

		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_UP
		beq	.up_not_pressed
		ldd	r_tile_offset
		addd	#$100
		std	r_tile_offset
		lbra	.loop_redraw

	.up_not_pressed:
		bita	#INPUT_DOWN
		beq	.down_not_pressed
		ldd	r_tile_offset
		subd	#$100
		std	r_tile_offset
		lbra	.loop_redraw

	.down_not_pressed:
		bita	#INPUT_LEFT
		beq	.left_not_pressed
		ldd	r_tile_offset
		subd	#$1000
		std	r_tile_offset
		lbra	.loop_redraw

	.left_not_pressed:
		bita	#INPUT_RIGHT
		beq	.right_not_pressed
		ldd	r_tile_offset
		addd	#$1000
		std	r_tile_offset
		lbra	.loop_redraw

	.right_not_pressed:
		bita	#INPUT_B1
		beq	.b1_not_pressed
		lda	r_quadrant
		inca
		anda	#$3
		sta	r_quadrant
		lbra	.loop_redraw

	.b1_not_pressed:
		bita	#INPUT_B2
		lbeq	.loop_next_input
		rts

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), <"OFFSET",CHAR_COLON>
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - SWITCH QUAD"
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

; not part of d_screen_xys_list so we can use in row headers
d_str_07:		STRING "0 1 2 3 4 5 6 7"
d_str_8f:		STRING "8 9 A B C D E F"

	section bss

r_current_column:	dcb.b 1
r_current_row:		dcb.b 1
r_current_tile:		dcb.w 1
r_seek_xy_cb:		dcb.w 1
r_draw_tile_cb:		dcb.w 1
r_tile_offset:		dcb.w 1
r_tile_offset_mask:	dcb.w 1
r_quadrant:		dcb.b 1
