	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/handlers/menu.inc"

	include "machine.inc"

	global main_menu

	section code

main_menu:
		clra
		sta	r_menu_cursor

	.loop_menu:
		PSUB	screen_init

		SEEK_XY	3, 3
		ldy	#d_str_menu_title
		PSUB	print_string

		ldy	#d_menu_list
		jsr	menu_handler

		bra	.loop_menu


	section data

d_menu_list:
	MENU_ENTRY input_test, d_str_input_test
	MENU_ENTRY memory_viewer_menu, d_str_memory_viewer
	MENU_ENTRY manual_palette_ram_tests, d_str_palette_ram_test
	MENU_ENTRY sound_test, d_str_sound_test
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram_test
	MENU_LIST_END

d_str_menu_title:		string "MAIN MENU"

d_str_input_test:		string "INPUT TEST"
d_str_memory_viewer:		string "MEMORY VIEWER"
d_str_palette_ram_test:		string "PALETTE RAM TEST"
d_str_sound_test:		string "SOUND TEST"
d_str_work_ram_test:		string "WORK RAM TEST"
