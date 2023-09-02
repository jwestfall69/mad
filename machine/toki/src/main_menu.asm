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
		moveq	#'*', d0
		moveq 	#' ', d1
		jsr	main_menu_handler

		bra	main_menu


; returns:
;  d0 = 0, MAIN_MENU_UP, MAIN_MENU_DOWN, MAIN_MENU_BUTTON
main_menu_get_input:
		move.w	#$1fff, d0
		RSUB	delay

		jsr	input_p1_update
		move.b	INPUT_P1_EDGE, d0

		; UP/DOWN are already lined up, we just need to set button 1
		btst	#P1_B1_BIT, d0
		beq	.a_not_pressed

		or.b	#4, d0
		and.b	#$7, d0
		rts

	.a_not_pressed:
		and.b	#$3, d0
		rts

	section data

MAIN_MENU_LIST:
	MAIN_MENU_ENTRY manual_ram_tests, STR_RAM_TEST
	MAIN_MENU_ENTRY manual_ram_tests, STR_TEST2
	MAIN_MENU_ENTRY manual_ram_tests, STR_TEST3
	MAIN_MENU_ENTRY manual_ram_tests, STR_TEST4
	MAIN_MENU_ENTRY	input_test, STR_INPUT_TESTS
	MAIN_MENU_ENTRY_LIST_END

STR_INPUT_TESTS:	STRING "INPUT TESTS"
STR_RAM_TEST:		STRING "RAM TEST"
STR_TEST2:		STRING "TEST2"
STR_TEST3:		STRING "TEST3"
STR_TEST4:		STRING "TEST4"
