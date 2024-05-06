	include "cpu/68000/dsub.inc"
	include "cpu/68000/menu_input.inc"
	include "cpu/68000/macros.inc"

	include "machine.inc"

	global memory_viewer_handler

	section code

NUM_ROWS	equ 20
START_ROW	equ 5

; a0 = start memory location
; a1 = input callback function
memory_viewer_handler:

		movem.l	a0-a1, -(a7)
		RSUB	screen_clear

		SEEK_XY	9, 3
		lea	STR_MEMORY_VIEWER, a0
		RSUB	print_string
		movem.l	(a7)+, a0-a1

		movea.l	a1, a2

	.loop_next_input:
		bsr	memory_dump
		jsr	(a2)		; input callback

		btst	#MENU_UP_BIT, d0
		beq	.up_not_pressed
		suba.l	#4, a0
		bra	.loop_next_input

	.up_not_pressed:
		btst	#MENU_DOWN_BIT, d0
		beq	.down_not_pressed
		adda.l	#4, a0
		bra	.loop_next_input

	.down_not_pressed:
		btst	#MENU_RIGHT_BIT, d0
		beq	.right_not_pressed
		adda.l	#$50, a0
		bra	.loop_next_input

	.right_not_pressed:
		btst	#MENU_LEFT_BIT, d0
		beq	.left_not_pressed
		suba.l	#$50, a0
		bra	.loop_next_input

	.left_not_pressed:
		btst	#MENU_EXIT_BIT, d0
		beq	.loop_next_input

		rts

; a0 = start adddress
memory_dump:

		movem.l	d0-d6/a0, -(a7)

		moveq	#START_ROW, d3
		moveq	#(NUM_ROWS - 1), d4

		bra	.loop_start_address

	.loop_next_address:
		add.b	#$1, d3

	.loop_start_address:

		moveq	#4, d0
		move.w	d3, d1
		RSUB	screen_seek_xy

		move.l	a0, d0
		RSUB	print_hex_3_bytes	; address

		moveq	#17, d0
		move.w	d3, d1
		RSUB	screen_seek_xy

		move.l	(a0), d0
		move.l	d0, d5
		RSUB	print_hex_word		; lower word

		moveq	#12, d0
		move.w	d3, d1
		RSUB	screen_seek_xy

		move.l	d5, d0
		swap	d0
		RSUB	print_hex_word		; upper word

		moveq	#26, d2

		moveq	#3, d6

	.loop_next_char:
		move.w	d2, d0
		move.w	d3, d1
		RSUB	screen_seek_xy

		move.l	d5, d0
		and.l	#$ff, d0
		RSUB	print_char

		lsr.l	#8, d5
		sub.b	#1, d2
		dbra	d6, .loop_next_char


		adda.l	#4, a0
		dbra	d4, .loop_next_address


		movem.l (a7)+, d0-d6/a0
		rts

STR_MEMORY_VIEWER:	STRING "MEMORY VIEWER"
