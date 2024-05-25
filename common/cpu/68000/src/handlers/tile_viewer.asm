	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/menu_input.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/xy_string.inc"

	include "machine.inc"

	global tile_viewer_handler

START_COLUMN	equ $3
START_ROW	equ $8

	section code

; params:
;  a0 = menu get input function
tile_viewer_handler:

		movem.l	a0, -(a7)

		SEEK_XY	5, 6
		lea	STR_0F, a0
		RSUB	print_string

		SEEK_XY	3, 26
		lea	STR_B2_RETURN, a0
		RSUB	print_string

		moveq	#0, d6			; byte to write
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
		RSUB	screen_seek_xy

		move.b	d6, d0
		RSUB	print_byte

		addq.b	#1, d3			; next position over
		addq.b	#1, d6			; next byte to print
		dbra	d4, .loop_next_byte

		addq.b	#1, d2			; next row
		dbra	d5, .loop_next_row

		movem.l	(a7)+, a0

	.loop_input:
		WATCHDOG

		jsr	(a0)

		btst	#MENU_EXIT_BIT, d0
		beq	.loop_input
		rts

	section data

; skipping string_xy_list so we can use STR_0F in row headers
STR_0F:		STRING "0123456789ABCDEF"
STR_B2_RETURN:	STRING "B2 - RETURN TO MENU"
