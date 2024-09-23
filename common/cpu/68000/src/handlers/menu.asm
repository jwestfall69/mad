	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/handlers/menu.inc"
	include "global/include/screen.inc"

	include "input.inc"
	include "machine.inc"
	include "mad_rom.inc"

	global menu_handler
	global r_menu_cursor

MENU_X_OFFSET		equ SCREEN_START_X - 1	; cursor is 1 less then start x
MENU_Y_OFFSET		equ SCREEN_START_Y + 2

	section code

; params:
;  a0 = array of menu entries
; returns:
;  d0 = 0 (function ran) or 1 (menu exit)
menu_handler:

		move.l	a0, r_menu_list
		move.l	a1, a2

		bsr	print_menu_list
		move.b	d0, d6			; max menu entries
		subq.b	#1, d6

		move.b	r_menu_cursor, d4	; current menu entry
		move.b	d4, d5			; previous menu entry

		; This prevents us from exiting all the way back
		; to the main menu, when exiting a function in a
		; submenu
		move.b	#INPUT_B2_BIT, d0
		RSUB	wait_button_release

		; force an initial draw of the cursor
		bra	.update_cursor

	.loop_menu_input:
		WATCHDOG
		bsr	input_update
		move.b	r_input_edge, d0

		btst	#INPUT_UP_BIT, d0
		beq	.up_not_pressed

		move.b	d4, d5
		subq.b	#1, d4
		bpl	.update_cursor
		move.b	d6, d4
		bra	.update_cursor

	.up_not_pressed:
		btst	#INPUT_DOWN_BIT, d0
		beq	.down_not_pressed

		move.b	d4, d5
		addq.b	#1, d4
		cmp.b	d4, d6
		bge	.update_cursor
		moveq	#0, d4
		bra	.update_cursor

	.down_not_pressed:
		btst	#INPUT_B1_BIT, d0
		beq	.b1_not_pressed
		bra	.menu_entry_run

	.b1_not_pressed:
		btst	#INPUT_B2_BIT, d0
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

		move.b	d4, r_menu_cursor

		RSUB	screen_init

		move.l	r_menu_list, a1
		move.l	d4, d0
		mulu	#8, d0
		add.l	d0, a1

		move.l	s_me_name_ptr(a1), a0

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		RSUB	print_string

		move.b	r_menu_cursor, -(a7)

		move.la	s_me_function_ptr(a1), a1
		jsr	(a1)

		move.b	(a7)+, r_menu_cursor

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

		move.l	s_me_name_ptr(a1), a0
		RSUB	print_string

		addq.l	#s_me_struct_size, a1
		addq.b	#1, d4
		bra	.loop_next_entry

	.list_end:
		move.b	d4, d0
		rts

	section bss
	align 2

r_menu_list:		dc.l	$0
r_menu_cursor:		dc.b	$0
