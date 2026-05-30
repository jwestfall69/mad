	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global ram_tests_menu

	section code

ram_tests_menu:
		ld	ix, d_str_menu_title
		ld	iy, d_menu_list
		call	menu_handler
		ret

	section data

d_menu_list:
	MENU_ENTRY manual_bg_tile_ram_tests, d_str_bg_tile_ram_tests, ME_FLAG_NONE
	MENU_ENTRY manual_fg_tile_ram_tests, d_str_fg_tile_ram_tests, ME_FLAG_NONE
	MENU_ENTRY manual_fix_tile_ram_tests, d_str_fix_tile_ram_tests, ME_FLAG_NONE
	MENU_ENTRY manual_palette_ram_tests, d_str_palette_ram_tests, ME_FLAG_NONE
	MENU_ENTRY manual_sprite_ram_tests, d_str_sprite_ram_tests, ME_FLAG_NONE
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram_tests, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "RAM TESTS MENU"

d_str_bg_tile_ram_tests:	STRING "BG TILE RAM TESTS"
d_str_fg_tile_ram_tests:	STRING "FG TILE RAM TESTS"
d_str_fix_tile_ram_tests:	STRING "FIX TILE RAM TESTS"
d_str_palette_ram_tests:	STRING "PALETTE RAM TESTS"
d_str_sprite_ram_tests:		STRING "SPRITE RAM TESTS"
d_str_work_ram_tests:		STRING "WORK RAM TESTS"
