	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/main_menu_handler.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global main_menu_input
	global main_menu_print_item
	global main_menu_move_cursor

	section code

; these are call backs from global main_menu that are machine specific

; returns:
;  d0 = 0, MAIN_MENU_UP, MAIN_MENU_DOWN, MAIN_MENU_BUTTON
main_menu_input:
		move.w	#$1fff, d0
		RSUB	delay

		jsr	p1_input_update

		moveq	#0, d0

		move.w	P1_INPUT_EDGE, d1

		btst	#2, d1
		bne	.down_pressed

		btst	#3, d1
		bne	.up_pressed

		btst	#4, d1
		bne	.a_pressed

		rts

	.down_pressed:
		bset	#MAIN_MENU_DOWN_BIT, d0
		rts

	.up_pressed:
		bset	#MAIN_MENU_UP_BIT, d0
		rts

	.a_pressed:
		bset	#MAIN_MENU_BUTTON_BIT, d0
		rts

; params:
; d0 = menu number that should have the cursor
; d1 = menu number that has the cursor
main_menu_move_cursor:
		cmp.b	d0, d1
		beq	.draw_only

		; remove first
		SEEK_XY	2, 2
		and.l	#$ff, d1
		lsl.l	#$2, d1
		add.l	d1, a6
		moveq	#0, d1
		move.w	d1, (a6)

	.draw_only:
		SEEK_XY	2, 2
		lsl.l	#$2, d0
		add.l	d0, a6
		moveq	#'*', d0
		or.w	#(ROMSET_TEXT_TILE_GROUP << 8), d0
		move.w	d0, (a6)
		rts

; params:
;  a0 = address of string
;  d0 = menu item number, 0 = first
main_menu_print_item:
		SEEK_XY	3, 2
		lsl.l	#$2, d0
		add.l	d0, a6
		RSUB	print_string
		rts
