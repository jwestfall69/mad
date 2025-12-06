	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global main_menu

	section code

main_menu:
		ld	ix, d_str_menu_title
		ld	iy, d_menu_list
		call	menu_handler
		jr	main_menu

	section data

d_menu_list:
	MENU_ENTRY graphics_viewer_menu, d_str_graphics_viewer
	MENU_ENTRY input_test, d_str_input_test
	MENU_ENTRY memory_viewer_menu, d_str_memory_viewer
	MENU_ENTRY ram_tests_menu, d_str_ram_tests
	MENU_ENTRY sound_test, d_str_sound_test
	MENU_ENTRY video_dac_test, d_str_video_dac_test
	MENU_ENTRY debug_menu, d_str_debug_menu
	MENU_LIST_END

d_str_menu_title:		STRING "MAIN MENU"

d_str_debug_menu:		STRING "DEBUG MENU"
d_str_graphics_viewer:		STRING "GRAPHICS VIEWER"
d_str_input_test:		STRING "INPUT TEST"
d_str_memory_viewer:		STRING "MEMORY VIEWER"
d_str_ram_tests:		STRING "RAM TESTS"
d_str_sound_test:		STRING "SOUND TEST"
d_str_video_dac_test:		STRING "VIDEO DAC TEST"
