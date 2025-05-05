	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami2/include/dsub.inc"
	include "cpu/konami2/include/macros.inc"
	include "cpu/konami2/include/handlers/menu.inc"

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
	MENU_ENTRY manual_palette_ram_tests, d_str_palette_ram_test
	MENU_ENTRY manual_sprite_ram_tests, d_str_sprite_ram_test
	MENU_ENTRY manual_tile_ram_tests, d_str_tile_ram_test
	MENU_ENTRY manual_tile_attr_ram_tests, d_str_tile_attr_ram_test
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram_test
	MENU_ENTRY cpu_tests_menu, d_str_cpu_tests
	MENU_ENTRY input_test, d_str_input_test
	MENU_ENTRY memory_viewer_menu, d_str_memory_viewer
	MENU_ENTRY prog_bank_test, d_str_prog_bank_test
	MENU_ENTRY video_dac_test, d_str_video_dac_test
	MENU_ENTRY debug_menu, d_str_debug_menu
	MENU_LIST_END

d_str_menu_title:		STRING "MAIN MENU"

d_str_cpu_tests:		STRING "CPU TESTS"
d_str_debug_menu:		STRING "DEBUG MENU"
d_str_input_test:		STRING "INPUT TEST"
d_str_memory_viewer:		STRING "MEMORY VIEWER"
d_str_palette_ram_test:		STRING "PALETTE RAM TEST"
d_str_prog_bank_test:		STRING "PROG BANK TEST"
d_str_sprite_ram_test:		STRING "SPRITE RAM TEST"
d_str_tile_ram_test:		STRING "TILE RAM TEST"
d_str_tile_attr_ram_test:	STRING "TILE ATTR RAM TEST"
d_str_video_dac_test:		STRING "VIDEO DAC TEST"
d_str_work_ram_test:		STRING "WORK RAM TEST"
