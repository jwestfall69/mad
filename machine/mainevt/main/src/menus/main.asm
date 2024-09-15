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
	MENU_ENTRY manual_palette_ram_tests, d_str_palette_ram_test
	MENU_ENTRY manual_sprite_ram_tests, d_str_sprite_ram_test
	MENU_ENTRY manual_tile1_ram_tests, d_str_tile1_ram_test
	MENU_ENTRY manual_tile2_ram_tests, d_str_tile2_ram_test
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram_test
	MENU_ENTRY input_test, d_str_input_test
	MENU_ENTRY memory_viewer_menu, d_str_memory_viewer
	MENU_ENTRY sound_test, d_str_sound_test
	MENU_LIST_END

d_str_menu_title:		STRING "MAIN MENU"

d_str_input_test:		STRING "INPUT TEST"
d_str_memory_viewer:		STRING "MEMORY VIEWER"
d_str_palette_ram_test:		STRING "PALETTE RAM TEST"
d_str_sound_test:		STRING "SOUND TEST"
d_str_sprite_ram_test:		STRING "SPRITE RAM TEST"
d_str_tile1_ram_test:		STRING "TILE1 RAM TEST"
d_str_tile2_ram_test:		STRING "TILE2 RAM TEST"
d_str_work_ram_test:		STRING "WORK RAM TEST"
