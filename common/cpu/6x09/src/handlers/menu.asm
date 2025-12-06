	include "cpu/6x09/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global menu_handler
	global r_menu_cursor

MENU_X_OFFSET		equ SCREEN_START_X - 1	; cursor is 1 less then start x
MENU_Y_OFFSET		equ SCREEN_START_Y + 2

	section code

; params:
;  x = ptr to title string
;  y = address of menu struct list
menu_handler:
		stx	r_menu_title_ptr
		sty	r_menu_list_ptr
		clr	r_menu_cursor

	.loop_menu:
		RSUB	screen_init

		SEEK_XY SCREEN_START_X, SCREEN_START_Y
		ldy	r_menu_title_ptr
		RSUB	print_string

		ldy	r_menu_list_ptr
		jsr	print_menu_list

		; if no entries exit back
		cmpa	#$0
		lbeq	.menu_exit

		deca	; adjust for 0 index
		sta	r_menu_cursor_max

		; This prevents us from exiting all the way back
		; to the main menu, when exiting a function in a
		; submenu
		lda	#INPUT_B2
		jsr	wait_button_release

		lda	r_menu_cursor
		sta	r_menu_cursor_prev
		bra	.update_cursor

	.loop_input:
		WATCHDOG

		jsr	input_update
		lda	r_input_edge

		bita	#INPUT_UP
		beq	.up_not_pressed
		lda	r_menu_cursor
		sta	r_menu_cursor_prev
		deca
		bpl	.update_cursor
		lda	r_menu_cursor_max
		bra	.update_cursor
	.up_not_pressed:

		bita	#INPUT_DOWN
		beq	.down_not_pressed
		lda	r_menu_cursor
		sta	r_menu_cursor_prev
		inca
		cmpa	r_menu_cursor_max
		ble	.update_cursor
		clra
		bra	.update_cursor
	.down_not_pressed:

		bita	#INPUT_B1
		bne	.run_menu_entry

		bita	#INPUT_B2
		beq	.loop_input
		bra	.menu_exit

	.update_cursor:
		sta	r_menu_cursor

		; remove old cursor
		lda	#MENU_X_OFFSET
		ldb	r_menu_cursor_prev
		addb	#MENU_Y_OFFSET
		RSUB	screen_seek_xy

		lda	#CURSOR_CLEAR_CHAR
		RSUB	print_char

		; draw new cursor
		lda	#MENU_X_OFFSET
		ldb	r_menu_cursor
		addb	#MENU_Y_OFFSET
		RSUB	screen_seek_xy

		lda	#CURSOR_CHAR
		RSUB	print_char
		bra	.loop_input

	.menu_exit:
		rts


	.run_menu_entry:
		RSUB	screen_init

		; convert into the offset into the menu list array
		lda	r_menu_cursor
		lsla
		lsla

		; goto menu entry
		ldy	r_menu_list_ptr
		leay	a, y

		pshs	y
		SEEK_XY SCREEN_START_X, SCREEN_START_Y
		ldy	s_me_name_ptr, y
		RSUB	print_string
		puls	y

		lda	r_menu_cursor
		ldx	r_menu_list_ptr
		pshs	a, x
		ldx	r_menu_title_ptr
		pshs	x

		jsr	[s_me_function_ptr, y]

		puls	x
		stx	r_menu_title_ptr
		puls	a, y
		sty	r_menu_list_ptr
		sta	r_menu_cursor
		jmp	.loop_menu


; params:
;  y = address of menu struct list
; return:
;  a = number of items
print_menu_list:
		lda	#MENU_Y_OFFSET
		sta	r_menu_print_line

	.loop_next_entry:
		pshs	y
		ldy	s_me_name_ptr, y
		beq	.list_end

		lda	#MENU_X_OFFSET + 1
		ldb	r_menu_print_line
		RSUB	screen_seek_xy
		RSUB	print_string
		puls	y

		leay	s_me_struct_size, y
		inc	r_menu_print_line
		bra	.loop_next_entry

	.list_end:
		puls	y
		lda	r_menu_print_line
		suba	#MENU_Y_OFFSET
		rts

	section bss

r_menu_print_line:	dcb.b 1
r_menu_list_ptr:	dcb.w 1
r_menu_title_ptr:	dcb.w 1
r_menu_cursor:		dcb.b 1
r_menu_cursor_prev:	dcb.b 1
r_menu_cursor_max:	dcb.b 1
