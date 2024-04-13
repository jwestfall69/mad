	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/main_menu_handler.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global main_menu

	section code

main_menu:
		RSUB	screen_init
		lea	MAIN_MENU_LIST, a0
		lea	main_menu_get_input, a1
		moveq	#ROMSET_MENU_CURSOR, d0
		moveq	#' ', d1
		jsr	main_menu_handler

		bra	main_menu

; these are call backs from global main_menu that are machine specific

; returns:
;  d0 = 0, MAIN_MENU_UP, MAIN_MENU_DOWN, MAIN_MENU_BUTTON
main_menu_get_input:
		move.w	#$1fff, d0
		RSUB	delay

		jsr	p1_input_update

		moveq	#0, d0

		move.b	P1_INPUT_EDGE, d1

		btst	#P1_DOWN_BIT, d1
		bne	.down_pressed

		btst	#P1_UP_BIT, d1
		bne	.up_pressed

		btst	#P1_B1_BIT, d1
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


MAIN_MENU_LIST:
	MAIN_MENU_ENTRY manual_work_ram_tests, STR_WORK_RAM_TEST
	MAIN_MENU_ENTRY input_test, STR_INPUT_TEST
	MAIN_MENU_ENTRY_LIST_END

STR_WORK_RAM_TEST:	STRING "WORK RAM TEST"
STR_INPUT_TEST:		STRING "INPUT TEST"
