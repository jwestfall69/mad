	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/main_menu_handler.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global main_menu

	section code

main_menu:
		move.b	#0, MAIN_MENU_CURSOR

	.loop_main_menu:
		RSUB	screen_init
		lea	MAIN_MENU_LIST, a0
		lea	menu_input_generic, a1
		moveq	#'*', d0
		moveq 	#' ', d1
		jsr	main_menu_handler

		bra	.loop_main_menu

	section data

MAIN_MENU_LIST:
	MAIN_MENU_ENTRY manual_ram_tests, STR_RAM_TEST
	MAIN_MENU_ENTRY manual_ram_tests, STR_TEST2
	MAIN_MENU_ENTRY manual_ram_tests, STR_TEST3
	MAIN_MENU_ENTRY manual_ram_tests, STR_TEST4
	MAIN_MENU_ENTRY	input_test, STR_INPUT_TEST
	MAIN_MENU_LIST_END

STR_INPUT_TEST:		STRING "INPUT TEST"
STR_RAM_TEST:		STRING "RAM TEST"
STR_TEST2:		STRING "TEST2"
STR_TEST3:		STRING "TEST3"
STR_TEST4:		STRING "TEST4"
