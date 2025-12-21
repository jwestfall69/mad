	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global ram_tests_menu

	section code

ram_tests_menu:
		ldx	#d_str_menu_title
		ldy	#d_menu_list
		jsr	menu_handler
		rts

	section data

d_menu_list:
	MENU_ENTRY manual_fg_ram_tests, d_str_fg_ram
	MENU_ENTRY manual_sprite_ram_tests, d_str_sprite_ram
	MENU_ENTRY manual_work_ram_tests, d_str_work_and_bg_ram
	MENU_LIST_END

d_str_menu_title:		STRING "RAM TESTS"

d_str_fg_ram:			STRING "FG RAM"
d_str_sprite_ram:		STRING "SPRITE RAM"
d_str_work_and_bg_ram:		STRING "WORK AND BG RAM"
