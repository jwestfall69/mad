	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/handlers/menu.inc"

	include "machine.inc"

	global main_menu

	section code

main_menu:
		clr	r_menu_cursor

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_menu_title
		RSUB	print_string

		ldy	#d_menu_list
		jsr	menu_handler

		bra	.loop_menu


	section data

d_menu_list:
	MENU_ENTRY graphics_viewer_menu, d_str_graphics_viewer
	MENU_ENTRY ram_tests_menu, d_str_ram_tests
	MENU_ENTRY input_test, d_str_input_test
	MENU_ENTRY memory_viewer_menu, d_str_memory_viewer
	;MENU_ENTRY prog_bank_test, d_str_prog_bank_test
	MENU_ENTRY sound_test, d_str_sound_test
	MENU_ENTRY video_tests_menu, d_str_video_tests
	MENU_ENTRY debug_menu, d_str_debug_menu
	MENU_LIST_END

d_str_menu_title:		STRING "MAIN MENU"

d_str_debug_menu:		STRING "DEBUG MENU"
d_str_graphics_viewer:		STRING "GRAPHICS VIEWER"
d_str_input_test:		STRING "INPUT TEST"
d_str_memory_viewer:		STRING "MEMORY VIEWER"
;d_str_prog_bank_test:		STRING "PROG BANK TEST"
d_str_ram_tests:		STRING "RAM TESTS"
d_str_sound_test:		STRING "SOUND TEST"
d_str_video_tests:		STRING "VIDEO TESTS"
