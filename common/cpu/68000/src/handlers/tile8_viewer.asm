	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"

	include "input.inc"
	include "machine.inc"

	global tile8_viewer_handler

START_COLUMN	equ $4
START_ROW	equ $9

	section code

; params:
;  d0 = tile offset
;  d1 = offset mask
;  a0 = seek_xy function
;  a1 = draw_tile function
tile8_viewer_handler:
		move.w	d0, (TILE_OFFSET)
		move.w	d1, (TILE_OFFSET_MASK)
		move.l	a0, (SEEK_XY_CB)
		move.l	a1, (DRAW_TILE_CB)

		lea	SCREEN_XYS_LIST, a0
		RSUB	print_xy_string_list

		SEEK_XY	6, 7
		lea	STR_0F, a0
		RSUB	print_string

	.loop_redraw:
		move.w	(TILE_OFFSET), d6
		move.w	(TILE_OFFSET_MASK), d1
		and.w	d1, d6
		move.w	d6, (TILE_OFFSET)

		moveq	#15, d5			; number of rows - 1
		moveq	#START_ROW, d2		; current row number

		lea	STR_0F, a1

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
		move.l	(SEEK_XY_CB), a0
		jsr	(a0)

		move.w	d6, d0
		move.l	(DRAW_TILE_CB), a0
		jsr	(a0)

		addq.b	#1, d3			; next position over
		addq.b	#1, d6			; next byte to print
		dbra	d4, .loop_next_byte

		addq.b	#1, d2			; next row
		dbra	d5, .loop_next_row

	.loop_input:
		WATCHDOG

		SEEK_XY	16, 5
		move.w	TILE_OFFSET, d0
		RSUB	print_hex_word

		bsr	input_update
		move.b	INPUT_EDGE, d0

		btst	#INPUT_UP_BIT, d0
		beq	.up_not_pressed
		sub.w	#$100, TILE_OFFSET
		bra	.loop_redraw
	.up_not_pressed:

		btst	#INPUT_DOWN_BIT, d0
		beq	.down_not_pressed
		add.w	#$100, TILE_OFFSET
		bra	.loop_redraw
	.down_not_pressed:

		btst	#INPUT_LEFT_BIT, d0
		beq	.left_not_pressed
		sub.w	#$1000, TILE_OFFSET
		bra	.loop_redraw
	.left_not_pressed:

		btst	#INPUT_RIGHT_BIT, d0
		beq	.right_not_pressed
		add.w	#$1000, TILE_OFFSET
		bra	.loop_redraw
	.right_not_pressed:

		btst	#INPUT_B2_BIT, d0
		beq	.loop_input
		rts

	section data

	align 2

SCREEN_XYS_LIST:
	XY_STRING 8,  5, <"OFFSET",CHAR_COLON>
	XY_STRING 3, 26, "B2 - RETURN TO MENU"
	XY_STRING_LIST_END

; not part of SCREEN_XY_LIST so we can use in row headers
STR_0F:			STRING "0123456789ABCDEF"

	section bss

	align 2

SEEK_XY_CB:		dc.l	$0
DRAW_TILE_CB:		dc.l	$0
TILE_OFFSET:		dc.w	$0
TILE_OFFSET_MASK:	dc.w	$0
