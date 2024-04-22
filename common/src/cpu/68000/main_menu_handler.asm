	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/menu_input.inc"
	include "cpu/68000/main_menu_handler.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global main_menu_handler
	global MAIN_MENU_CURSOR

MAIN_MENU_X_OFFSET		equ $2
MAIN_MENU_Y_OFFSET		equ $2

	section code

; params:
;  a0 = main menu struct list
;  a1 = input callback function
main_menu_handler:

		move.l	a0, MAIN_MENU_LIST
		move.l	a1, a2

		jsr	print_main_menu_list
		move.b	d0, d6			; max menu entries
		subq.b	#1, d6

		move.b	MAIN_MENU_CURSOR, d4	; current menu entry
		move.b	d4, d5			; previous menu entry

		; force an initial draw of the cursor
		bra	.update_cursor

	.loop_menu_input:
		jsr	(a2)			; input callback

	.check_button_pressed:
		btst	#MENU_BUTTON_BIT, d0
		bne	.menu_entry_run

		btst	#MENU_UP_BIT, d0
		beq	.up_not_pressed

		move.b	d4, d5
		subq.b	#1, d4
		bpl	.update_cursor
		move.b	d6, d4
		bra	.update_cursor

	.up_not_pressed:
		btst	#MENU_DOWN_BIT, d0
		beq	.loop_menu_input

		move.b	d4, d5
		addq.b	#1, d4
		cmp.b	d4, d6
		bge	.update_cursor
		moveq	#0, d4

	.update_cursor:
		; clear old
		moveq	#MAIN_MENU_X_OFFSET, d0
		moveq	#MAIN_MENU_Y_OFFSET, d1
		add.b	d5, d1
		RSUB	screen_seek_xy

		move.b	#CURSOR_CLEAR_CHAR, d0
		RSUB	print_char

		; draw new
		moveq	#MAIN_MENU_X_OFFSET, d0
		moveq	#MAIN_MENU_Y_OFFSET, d1
		add.b	d4, d1
		RSUB	screen_seek_xy

		move.b	#CURSOR_CHAR, d0
		RSUB	print_char

		bra	.loop_menu_input

	.menu_entry_run:

		move.b	d4, MAIN_MENU_CURSOR

		RSUB	screen_clear

		move.l	MAIN_MENU_LIST, a1
		move.l	d4, d0
		mulu	#8, d0
		add.l	d0, a1

		move.l	(4, a1), a0

		SEEK_XY	3, 4
		RSUB	print_string

		move.la	(a1), a1
		jsr	(a1)			; menu entry's function

		rts


; params
;  a0 = address of start of MAIN_MENU struct list
; returns
;  d0 = number of items printed
print_main_menu_list:
		moveq	#0, d4		; number of entries
		move.l	a0, a1

	.loop_next_entry:
		cmp.l	#0, (a1)
		beq	.list_end

		moveq	#(MAIN_MENU_X_OFFSET + 1), d0
		moveq	#MAIN_MENU_Y_OFFSET, d1
		add.b	d4, d1
		RSUB	screen_seek_xy

		move.l	(4, a1), a0
		RSUB	print_string

		addq.l	#8, a1
		addq.b	#1, d4
		bra	.loop_next_entry

	.list_end:
		move.b	d4, d0
		rts

	section bss

	align 2

MAIN_MENU_LIST:			dc.l	$0
MAIN_MENU_CURSOR:		dc.b	$0
