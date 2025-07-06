	include "cpu/6x09/include/common.inc"

	global tile_8x8_viewer_handler

COLUMN_START	equ SCREEN_START_X
COLUMN_END	equ COLUMN_START + $12
ROW_START	equ SCREEN_START_Y + 6
ROW_END		equ ROW_START + $10

	section code

; params:
;  d = tile mask
;  x = seek_xy function
;  y = draw_tile function
tile_8x8_viewer_handler:
		std	r_tile_offset_mask
		stx	r_seek_xy_cb
		sty	r_draw_tile_cb

		ldd	#$0
		std	r_tile_offset

		SEEK_XY	SCREEN_START_X, (SCREEN_START_Y + 2)
		ldy	#d_str_offset
		RSUB	print_string
		jsr	print_b2_return_to_menu

		SEEK_XY	(COLUMN_START + 2), (SCREEN_START_Y + 4)
		ldy	#d_str_0f
		RSUB	print_string

	.loop_redraw:
		ldd	r_tile_offset

		anda	r_tile_offset_mask
		andb	r_tile_offset_mask + 1

		std	r_tile_offset
		std	r_current_tile

		SEEK_XY	(SCREEN_START_X + 8), (SCREEN_START_Y + 2)
		RSUB	print_hex_word

		lda	#ROW_START
		sta	r_current_row

		ldy	#d_str_0f
		pshs	y
	.loop_next_row:
		lda	#COLUMN_START
		sta	r_current_column

		ldb	r_current_row
		RSUB	screen_seek_xy

		puls	y
		lda	,y+
		pshs	y
		RSUB	print_char

		inc	r_current_column
		inc	r_current_column

	.loop_next_byte:
		lda	r_current_column
		ldb	r_current_row
		jsr	[r_seek_xy_cb]

		ldd	r_current_tile
		jsr	[r_draw_tile_cb]

		ldd	r_current_tile
		addd	#$1
		std	r_current_tile

		inc	r_current_column
		lda	r_current_column
		cmpa	#COLUMN_END
		bne	.loop_next_byte

		inc	r_current_row
		lda	r_current_row
		cmpa	#ROW_END
		bne	.loop_next_row

		puls	y

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

d_str_offset:		STRING <"OFFSET",CHAR_COLON>
d_str_0f:		STRING "0123456789ABCDEF"

	section bss

r_current_column:	dcb.b 1
r_current_row:		dcb.b 1
r_current_tile:		dcb.w 1
r_seek_xy_cb:		dcb.w 1
r_draw_tile_cb:		dcb.w 1
r_tile_offset:		dcb.w 1
r_tile_offset_mask:	dcb.w 1
