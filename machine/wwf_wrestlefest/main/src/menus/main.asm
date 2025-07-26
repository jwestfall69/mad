	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global main_menu

	section code

main_menu:
		move.b	#0, r_menu_cursor

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		lea	d_str_menu_title, a0
		RSUB	print_string

		lea	d_menu_list, a0
		jsr	menu_handler

		bra	.loop_menu

	section data
	align 1

d_menu_list:
	MENU_ENTRY graphics_viewer_menu, d_str_graphics_viewer
	MENU_ENTRY input_test, d_str_input_test
	MENU_ENTRY memory_viewer_menu, d_str_memory_viewer
	MENU_ENTRY ram_tests_menu, d_str_ram_tests
	MENU_ENTRY sound_test, d_str_sound_test
	MENU_ENTRY video_tests_menu, d_str_video_tests
	MENU_ENTRY debug_menu, d_str_debug_menu
	MENU_LIST_END

d_str_menu_title:		STRING "MAIN MENU"

d_str_debug_menu:		STRING "DEBUG MENU"
d_str_graphics_viewer:		STRING "GRAPHICS VIEWER"
d_str_input_test:		STRING "INPUT TEST"
d_str_memory_viewer:		STRING "MEMORY VIEWER"
d_str_ram_tests:		STRING "RAM TESTS"
d_str_sound_test:		STRING "SOUND TEST"
d_str_video_tests:		STRING "VIDEO TESTS"
