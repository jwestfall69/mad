	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/handlers/menu.inc"

	include "machine.inc"

	global main_menu

	section code

main_menu:
		clra
		sta	MENU_CURSOR

	.loop_menu:
		PSUB	screen_init

		SEEK_XY	3, 3
		ldy	#STR_MENU_TITLE
		PSUB	print_string

		ldy	#MENU_LIST
		jsr	menu_handler

		bra	.loop_menu


	section data

STR_INPUT_TEST:		string "INPUT TEST"
STR_MEMORY_VIEWER:	string "MEMORY VIEWER"
STR_SOUND_TEST:		string "SOUND TEST"

STR_MENU_TITLE:		string "MAIN MENU"

MENU_LIST:
	MENU_ENTRY input_test, STR_INPUT_TEST
	MENU_ENTRY sound_test, STR_SOUND_TEST
	MENU_ENTRY memory_viewer_menu, STR_MEMORY_VIEWER
	MENU_LIST_END
