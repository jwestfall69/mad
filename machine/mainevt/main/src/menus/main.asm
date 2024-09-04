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

STR_MENU_TITLE:	string "MAIN MENU"

STR_TEST1:		string "TEST1"
STR_TEST2:		string "TEST2"
STR_TEST3:		string "TEST3"
STR_MEMORY_VIEWER:	string "MEMORY VIEWER"
STR_TEST4:		string "TEST4"

MENU_LIST:
	MENU_ENTRY test1_func, STR_TEST1
	MENU_ENTRY test2_func, STR_TEST2
	MENU_ENTRY memory_viewer_menu, STR_MEMORY_VIEWER
	MENU_ENTRY test3_func, STR_TEST3
	MENU_ENTRY test4_func, STR_TEST4
	MENU_LIST_END


test1_func:
		STALL
		rts

test2_func:
		STALL
		rts

test3_func:
		STALL
		rts

test4_func:
		STALL
		rts
