	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/xy_string.inc"

	include "input.inc"
	include "machine.inc"

	global tile8_viewer_handler

START_COLUMN	equ SCREEN_START_X
START_ROW	equ SCREEN_START_Y + 6

	section code

; params:
;  d = tile offset
;  w = offset mask
;  x = seek_xy function
;  y = draw_tile function
tile8_viewer_handler:
		std	r_tile_offset
		stw	r_tile_offset_mask
		stx	r_seek_xy_cb
		sty	r_draw_tile_cb

		ldy	#d_screen_xys_list
		RSUB	print_xy_string_list

		SEEK_XY	(START_COLUMN + 2), (SCREEN_START_Y + 4)
		ldy	#d_str_0f
		RSUB	print_string

	.loop_redraw:
		ldd	r_tile_offset
		ldw	r_tile_offset_mask

		andr	w, d
		std	r_tile_offset
		std	r_current_tile

		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 2)
		RSUB	print_hex_word

		ldf	#$10	; number or rows
		lda	#START_ROW
		sta	r_current_row

		ldy	#d_str_0f
	.loop_next_row:
		lda	#START_COLUMN
		sta	r_current_column

		ldb	r_current_row
		RSUB	screen_seek_xy

		lda	,y+
		RSUB	print_char

		inc	r_current_column
		inc	r_current_column

		lde	#$10

	.loop_next_byte:
		lda	r_current_column
		ldb	r_current_row
		jsr	[r_seek_xy_cb]

		ldd	r_current_tile
		jsr	[r_draw_tile_cb]

		inc	r_current_column
		ldd	r_current_tile
		addd	#$1
		std	r_current_tile

		dece
		bne	.loop_next_byte

		inc	r_current_row
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
		bita	#INPUT_B2
		lbeq	.loop_next_input
		rts

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), <"OFFSET",CHAR_COLON>
	XY_STRING SCREEN_START_X, SCREEN_B2_Y, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

; not part of d_screen_xys_list so we can use in row headers
d_str_0f:		STRING "0123456789ABCDEF"

	section bss

r_current_column:	dcb.b 1
r_current_row:		dcb.b 1
r_current_tile:		dcb.w 1
r_seek_xy_cb:		dcb.w 1
r_draw_tile_cb:		dcb.w 1
r_tile_offset:		dcb.w 1
r_tile_offset_mask:	dcb.w 1
