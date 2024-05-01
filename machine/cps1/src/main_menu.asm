	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/menu_handler.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global main_menu

	section code

main_menu:
		move.b	#0, MENU_CURSOR

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	3, 3
		lea	STR_MENU_TITLE, a0
		RSUB	print_string

		lea	MENU_LIST, a0
		lea	menu_input_generic, a1
		jsr	menu_handler

		bra	.loop_menu

	section data

STR_INPUT_TEST:		STRING "INPUT TEST"
STR_MEMORY_VIEWER:	STRING "MEMORY VIEWER"
STR_SOUND_TEST:		STRING "SOUND TEST"
STR_WORK_RAM_TEST:	STRING "WORK RAM TEST"

STR_MENU_TITLE:		STRING "MAIN MENU"

	align 2

MENU_LIST:
	MENU_ENTRY manual_work_ram_tests, STR_WORK_RAM_TEST
	MENU_ENTRY input_test, STR_INPUT_TEST
	MENU_ENTRY sound_test, STR_SOUND_TEST
	MENU_ENTRY memory_viewer_menu, STR_MEMORY_VIEWER
	MENU_LIST_END
