	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global ram_tests_menu

	section code

ram_tests_menu:
		ld	ix, d_str_menu_title
		ld	iy, d_menu_list
		call	menu_handler
		ret

d_menu_list:
	MENU_ENTRY manual_main_ram_tests, d_str_main_ram, ME_FLAG_NONE
	MENU_ENTRY manual_scroll_ram_tests, d_str_scroll_ram, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "RAM TESTS"

d_str_scroll_ram:		STRING "SCROLL RAM"
d_str_main_ram:			STRING "MAIN RAM"
