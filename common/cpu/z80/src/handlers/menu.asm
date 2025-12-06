	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global menu_handler
	global r_menu_cursor

MENU_X_OFFSET		equ SCREEN_START_X - 1	; cursor is 1 less then start x
MENU_Y_OFFSET		equ SCREEN_START_Y + 2

	section code

; params:
;  ix = ptr to title string
;  iy = address of menu struct list
menu_handler:
		ld	(r_menu_title_ptr), ix
		ld	(r_menu_list_ptr), iy
		ld	a, 0
		ld	(r_menu_cursor), a

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, (r_menu_title_ptr)
		RSUB	print_string

		ld	ix, (r_menu_list_ptr)
		call	print_menu_list
		dec	a		; adjust for 0 index
		ld	(r_menu_cursor_max), a

		; This prevents us from exiting all the way back
		; to the main menu, when exiting a function in a
		; submenu
		ld	b, INPUT_B2
		call	wait_button_release

		ld	a, (r_menu_cursor)
		ld	(r_menu_cursor_prev), a

		jr	.update_cursor	; force initial cursor draw

	.loop_menu_input:
		WATCHDOG

		call	input_update
		ld	a, (r_input_edge)

		bit	INPUT_UP_BIT, a
		jr	z, .up_not_pressed
		ld	a, (r_menu_cursor)
		ld	(r_menu_cursor_prev), a
		dec	a
		jp	p, .update_cursor
		ld	a, (r_menu_cursor_max)
		jr	.update_cursor


	.up_not_pressed:
		bit	INPUT_DOWN_BIT, a
		jr	z, .down_not_pressed
		ld	a, (r_menu_cursor_max)
		ld	b, a
		; deal with no a > b compare instruction
		inc	b
		ld	a, (r_menu_cursor)
		ld	(r_menu_cursor_prev), a
		inc	a
		cp	b
		jp	m, .update_cursor
		ld	a, 0
		jr	.update_cursor

	.down_not_pressed:
		bit	INPUT_B1_BIT, a
		jr	nz, .menu_entry_run

		bit	INPUT_B2_BIT, a
		jr	z, .loop_menu_input
		ret

	.update_cursor:
		ld	(r_menu_cursor), a

		; remove old cursor
		ld	b, MENU_X_OFFSET
		ld	a, (r_menu_cursor_prev)
		add	a, MENU_Y_OFFSET
		ld	c, a
		RSUB	screen_seek_xy

		ld	c, CURSOR_CLEAR_CHAR
		RSUB	print_char

		; draw new cursor
		ld	b, MENU_X_OFFSET
		ld	a, (r_menu_cursor)
		add	a, MENU_Y_OFFSET
		ld	c, a
		RSUB	screen_seek_xy
		ld	c, CURSOR_CHAR
		RSUB	print_char
		jr	.loop_menu_input

	.menu_entry_run:
		RSUB	screen_init

		ld	a, (r_menu_cursor)
		ld	ix, (r_menu_title_ptr)
		ld	iy, (r_menu_list_ptr)

		push	af
		push	ix
		push	iy

		; based on the cursor number figure out
		; and got the correct entry in menu_list
		ld	b, 0
		sla	a
		sla	a
		ld	c, a
		add	iy, bc

		; menu entry string
		SEEK_XY SCREEN_START_X, SCREEN_START_Y
		ld	e, (iy + s_me_name_ptr)
		ld	d, (iy + s_me_name_ptr + 1)
		RSUB	print_string

		; menu entry function
		ld	l, (iy + s_me_function_ptr)
		ld	h, (iy + s_me_function_ptr + 1)

		; setup stack so we ret to after the jp
		ld	de, .function_return
		push	de
		jp	(hl)
	.function_return:
		pop	iy
		ld	(r_menu_list_ptr), iy
		pop	ix
		ld	(r_menu_title_ptr), ix
		pop	af
		ld	(r_menu_cursor), a
		jp	.loop_menu

; params:
;  ix = address of menu struct list
print_menu_list:

		ld	iy, r_print_menu_line
		ld	(iy), MENU_Y_OFFSET
	.loop_next_entry:
		ld	c, (ix + s_me_function_ptr)
		ld	b, (ix + s_me_function_ptr + 1)

		; function ptr of $0000 is list end
		ld	a, 0
		cp	b
		jr	nz, .not_list_end

		cp	c
		jr	z, .list_end

	.not_list_end:
		ld	b, MENU_X_OFFSET + 1
		ld	c, (iy)
		RSUB	screen_seek_xy

		ld	e, (ix + s_me_name_ptr)
		ld	d, (ix + s_me_name_ptr + 1)
		RSUB	print_string

		ld	bc, s_me_struct_size
		add	ix, bc


		inc	(iy)
		jr	.loop_next_entry
	.list_end:

		ld	a, (iy)
		sub	MENU_Y_OFFSET
		ret

	section bss

r_print_menu_line:	dcb.b 1
r_menu_list_ptr:	dcb.w 1
r_menu_title_ptr:	dcb.w 1
r_menu_cursor:		dcb.b 1
r_menu_cursor_prev:	dcb.b 1
r_menu_cursor_max:	dcb.b 1
