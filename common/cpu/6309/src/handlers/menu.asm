	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/handlers/menu.inc"

	include "input.inc"
	include "machine.inc"
	include "mad_rom.inc"

	global menu_handler
	global r_menu_cursor

MENU_X_OFFSET		equ $2
MENU_Y_OFFSET		equ $5

	section code

; params:
;  y = address of menu struct list
; returns:
;  a = 0 (function ran) or 1 (menu exit)
menu_handler:
		sty	r_menu_list_addr
		jsr	print_menu_list
		tfr	a, b		; max cursor
		subb	#$1		; convert to 0 index
		lde	r_menu_cursor	; e = current menu entry
		tfr	e, f		; f = previous
		bra	.update_cursor	; force initial cursor draw

	.loop_menu_input:
		WATCHDOG
		pshs	b
		jsr	input_update
		puls	b
		lda	r_input_edge

		bita	#INPUT_UP
		beq	.up_not_pressed
		tfr	e, f
		sube	#$1
		bpl	.update_cursor
		tfr	b, e
		bra	.update_cursor

	.up_not_pressed:
		bita	#INPUT_DOWN
		beq	.down_not_pressed
		tfr	e, f
		adde	#$1
		cmpr	e, b
		bge	.update_cursor
		clre
		bge	.update_cursor

	.down_not_pressed:
		bita	#INPUT_B1
		bne	.menu_entry_run

		bita	#INPUT_B2
		beq	.loop_menu_input
		lda	#MENU_EXIT
		rts

	.update_cursor:
		ste	r_menu_cursor
		pshs	b

		; remove old cursor location
		lda	#MENU_X_OFFSET
		tfr	f, b
		addb	#MENU_Y_OFFSET
		PSUB	screen_seek_xy

		lda	#CURSOR_CLEAR_CHAR
		PSUB	print_char

		; draw new cursor location
		lda	#MENU_X_OFFSET
		tfr	e, b
		addb	#MENU_Y_OFFSET
		PSUB	screen_seek_xy

		lda	#CURSOR_CHAR
		PSUB	print_char
		puls	b

		bra	.loop_menu_input

	.menu_entry_run:
		ste	r_menu_cursor

		PSUB	screen_clear

		; convert into the array offset
		; for the selected menu item
		lde	r_menu_cursor
		tfr	e, a
		lsla
		lsla

		; goto the menu entry
		ldy	r_menu_list_addr
		leay	a, y
		pshs	y
		ldy	$2, y		; string address

		SEEK_XY 3, 4
		PSUB	print_string
		puls	y

		lde	r_menu_cursor
		pshsw

		jsr	[0, y]		; run function

		pulsw
		ste	r_menu_cursor

		lda	#MENU_CONTINUE
		rts

; params:
;  y = address of menu struct list
; return:
;  a = number of items
print_menu_list:

		clre
	.loop_next_entry:
		pshs	y, d, x

		ldy	$2, y		; string adderss
		beq	.list_end

		lda	#(MENU_X_OFFSET + 1)
		ldb	#MENU_Y_OFFSET
		addr	e, b
		PSUB	screen_seek_xy
		PSUB	print_string

		puls	x, d, y
		leay	$4, y		; got next entry
		ince
		bra	.loop_next_entry

	.list_end:
		puls	x, d, y
		tfr	e, a
		rts

	section bss

r_menu_list_addr:	dc.w $0
r_menu_cursor:		dc.b $0

