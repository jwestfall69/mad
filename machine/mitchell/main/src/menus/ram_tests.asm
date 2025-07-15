	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global ram_tests_menu

	section code

ram_tests_menu:
		ld	a, 0
		ld	(r_menu_cursor), a

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_menu_title
		RSUB	print_string

		ld	ix, d_menu_list
		call	menu_handler

		cp	MENU_CONTINUE
		jr	z, .loop_menu
		ret

	section data

d_menu_list:
	MENU_ENTRY manual_sprite_ram_tests, d_str_sprite_ram_tests
	MENU_ENTRY manual_tile_ram_tests, d_str_tile_ram_tests
	MENU_ENTRY manual_tile_attr_ram_tests, d_str_tile_attr_ram_tests
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram_tests
	MENU_LIST_END

d_str_menu_title:		STRING "RAM TESTS MENU"

d_str_sprite_ram_tests:		STRING "SPRITE RAM TESTS"
d_str_tile_ram_tests:		STRING "TILE RAM TESTS"
d_str_tile_attr_ram_tests:	STRING "TILE ATTR RAM TESTS"
d_str_work_ram_tests:		STRING "WORK RAM TESTS"
