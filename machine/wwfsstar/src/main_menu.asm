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

		lea	MENU_LIST, a0
		lea	menu_input_generic, a1
		jsr	main_menu_handler

		bra	.loop_main_menu

	section data

MENU_LIST:
	MAIN_MENU_ENTRY manual_work_ram_tests, STR_RAM_TEST
	MAIN_MENU_ENTRY input_test, STR_INPUT_TEST
	MAIN_MENU_ENTRY sound_test, STR_SOUND_TEST
	MAIN_MENU_LIST_END

STR_RAM_TEST:		STRING "RAM TEST"
STR_INPUT_TEST:		STRING "INPUT TEST"
STR_SOUND_TEST:		STRING "SOUND TEST"
