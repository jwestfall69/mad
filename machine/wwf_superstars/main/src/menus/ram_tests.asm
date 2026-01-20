	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global ram_tests_menu

	section code

ram_tests_menu:
		lea	d_str_menu_title, a0
		lea	d_menu_list, a1
		jsr	menu_handler
		rts

	section data
	align 1

d_menu_list:
	MENU_ENTRY manual_bg_ram_tests, d_str_bg_ram_test, ME_FLAG_NONE
	MENU_ENTRY manual_fg_ram_tests, d_str_fg_ram_test, ME_FLAG_NONE
	MENU_ENTRY manual_palette_ram_tests, d_str_palette_ram_test, ME_FLAG_NONE
	MENU_ENTRY manual_sprite_ram_tests, d_str_sprite_ram_test, ME_FLAG_NONE
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram_test, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "RAM TESTS"

d_str_bg_ram_test:		STRING "BG RAM TEST"
d_str_fg_ram_test:		STRING "FG RAM TEST"
d_str_palette_ram_test:		STRING "PALETTE RAM TEST"
d_str_sprite_ram_test:		STRING "SPRITE RAM TEST"
d_str_work_ram_test:		STRING "WORK RAM TEST"
