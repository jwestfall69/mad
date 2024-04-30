	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/menu_input.inc"
	include "cpu/68000/menu_handler.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global menu_handler
	global MENU_CURSOR

MENU_X_OFFSET		equ $2
MENU_Y_OFFSET		equ $5

	section code

; params:
;  a0 = menu struct { menu_title_ptr, menu_entry's }
;  a1 = input callback function
; returns:
;  d0 = 0 (function ran) or 1 (menu exit)
menu_handler:

		move.l	a0, MENU_LIST
		move.l	a1, a2

		jsr	print_menu_list
		move.b	d0, d6			; max menu entries
		subq.b	#1, d6

		move.b	MENU_CURSOR, d4		; current menu entry
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
		beq	.down_not_pressed

		move.b	d4, d5
		addq.b	#1, d4
		cmp.b	d4, d6
		bge	.update_cursor
		moveq	#0, d4

	.down_not_pressed:
		btst	#MENU_EXIT_BIT, d0
		beq	.loop_menu_input
		moveq	#MENU_EXIT, d0
		rts

	.update_cursor:
		; clear old
		moveq	#MENU_X_OFFSET, d0
		moveq	#MENU_Y_OFFSET, d1
		add.b	d5, d1
		RSUB	screen_seek_xy

		move.b	#CURSOR_CLEAR_CHAR, d0
		RSUB	print_char

		; draw new
		moveq	#MENU_X_OFFSET, d0
		moveq	#MENU_Y_OFFSET, d1
		add.b	d4, d1
		RSUB	screen_seek_xy

		move.b	#CURSOR_CHAR, d0
		RSUB	print_char

		bra	.loop_menu_input

	.menu_entry_run:

		move.b	d4, MENU_CURSOR

		RSUB	screen_clear

		move.l	MENU_LIST, a1
		move.l	d4, d0
		mulu	#8, d0
		add.l	d0, a1

		move.l	(4, a1), a0

		SEEK_XY	3, 4
		RSUB	print_string

		move.b	MENU_CURSOR, -(a7)

		move.la	(a1), a1
		jsr	(a1)			; menu entry's function

		move.b	(a7)+, MENU_CURSOR

		moveq	#MENU_CONTINUE, d0
		rts


; params
;  a0 = address of start of MENU struct list
; returns
;  d0 = number of items printed
print_menu_list:
		moveq	#0, d4		; number of entries
		move.l	a0, a1

	.loop_next_entry:
		cmp.l	#0, (a1)
		beq	.list_end

		moveq	#(MENU_X_OFFSET + 1), d0
		moveq	#MENU_Y_OFFSET, d1
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

MENU_LIST:		dc.l	$0
MENU_CURSOR:		dc.b	$0
