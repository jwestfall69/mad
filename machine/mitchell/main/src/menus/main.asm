	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global main_menu

	section code

main_menu:
		ld	a, 0
		ld	(r_menu_cursor), a

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_menu_title
		RSUB	print_string

		ld	ix, d_menu_list
		call	menu_handler

		jr	.loop_menu

	section data

d_menu_list:
	MENU_ENTRY manual_color_ram_tests, d_str_color_ram_tests
	MENU_ENTRY manual_object_ram_tests, d_str_object_ram_tests
	MENU_ENTRY manual_tile_ram_tests, d_str_tile_ram_tests
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram_tests
	MENU_ENTRY input_test, d_str_input_test
	MENU_ENTRY memory_viewer_menu, d_str_memory_viewer
	MENU_ENTRY sound_test, d_str_sound_test
	MENU_ENTRY video_dac_test, d_str_video_dac_test
	MENU_ENTRY debug_menu, d_str_debug_menu
	MENU_LIST_END

d_str_menu_title:		STRING "MAIN MENU"

d_str_color_ram_tests:		STRING "COLOR RAM TESTS"
d_str_debug_menu:		STRING "DEBUG MENU"
d_str_input_test:		STRING "INPUT TEST"
d_str_memory_viewer:		STRING "MEMORY VIEWER"
d_str_object_ram_tests:		STRING "OBJECT RAM TESTS"
d_str_sound_test:		STRING "SOUND TEST"
d_str_tile_ram_tests:		STRING "TILE RAM TESTS"
d_str_video_dac_test:		STRING "VIDEO DAC TEST"
d_str_work_ram_tests:		STRING "WORK RAM TESTS"
