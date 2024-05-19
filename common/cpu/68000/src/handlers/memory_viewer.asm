	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/menu_input.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"

	global memory_viewer_handler

	section code

NUM_ROWS	equ 20
START_ROW	equ 6

; a0 = start memory location
; a1 = input callback function
memory_viewer_handler:

		movem.l	a0-a1, -(a7)
		RSUB	screen_clear

		clr.b	READ_MODE

		SEEK_XY	9, 3
		lea	STR_MEMORY_VIEWER, a0
		RSUB	print_string

		SEEK_XY 16, 4
		lea	STR_READ_MODE, a0
		RSUB	print_string

		SEEK_XY	11, 4
		lea	STR_READ_MODE_WORD, a0
		RSUB	print_string

		movem.l	(a7)+, a0-a1

		movea.l	a1, a2

	.loop_next_input:
		WATCHDOG
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
		btst	#MENU_BUTTON_BIT, d0
		beq	.button_not_pressed

		movem.l	a0, -(a7)
		move.b	READ_MODE, d0
		add.b	#$1, d0
		and.b	#$1, d0
		move.b	d0, READ_MODE
		tst.b	d0
		beq	.read_mode_word
		lea	STR_READ_MODE_BYTE, a0
		bra	.print_read_mode

	.read_mode_word:
		lea	STR_READ_MODE_WORD, a0

	.print_read_mode:
		SEEK_XY	11, 4
		RSUB	print_string
		movem.l	(a7)+, a0

	.button_not_pressed:
		btst	#MENU_EXIT_BIT, d0
		beq	.loop_next_input

		rts

; params:
;  a0 = start adddress
;  READ_MODE = 0 (word reads), 1 (byte reads)
memory_dump:

		movem.l	d0-d6/a0, -(a7)

		moveq	#START_ROW, d3
		moveq	#(NUM_ROWS - 1), d4

		bra	.loop_start_address

	.loop_next_address:
		add.b	#$1, d3			; line number

	.loop_start_address:

		moveq	#4, d0
		move.w	d3, d1
		RSUB	screen_seek_xy

		move.l	a0, d0
		RSUB	print_hex_3_bytes	; address

		moveq	#17, d0
		move.w	d3, d1
		RSUB	screen_seek_xy

		btst	#$0, READ_MODE
		beq	.read_mode_word
		move.b	(a0), d0
		lsl.l	#8, d0
		move.b	(1,a0), d0
		lsl.l	#8, d0
		move.b	(2,a0), d0
		lsl.l	#8, d0
		move.b	(3, a0), d0
		bra	.read_done

	.read_mode_word:
		move.w	(a0), d0
		swap	d0
		move.w	(2, a0), d0

	.read_done:
		move.l	d0, d5
		RSUB	print_hex_word		; lower word

		moveq	#12, d0
		move.w	d3, d1
		RSUB	screen_seek_xy

		move.l	d5, d0
		swap	d0
		RSUB	print_hex_word		; upper word

		moveq	#26, d2			; x offset
		moveq	#3, d6			; num of chars

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


	section data

STR_MEMORY_VIEWER:	STRING "MEMORY VIEWER"
STR_READ_MODE:		STRING "READ"
STR_READ_MODE_BYTE:	STRING "BYTE"
STR_READ_MODE_WORD:	STRING "WORD"

	section bss

; ran out of registers in memory_dump so
; have to use ram for the read mode
READ_MODE:	dc.b	$0
