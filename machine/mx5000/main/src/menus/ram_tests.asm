	include "cpu/6309/include/common.inc"
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
	MENU_ENTRY manual_k007121_ram_tests, d_str_k007121_ram
	MENU_ENTRY manual_palette_ram_tests, d_str_palette_ram
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:		STRING "RAM TESTS"

d_str_k007121_ram:		STRING "K007121 RAM"
d_str_palette_ram:		STRING "PALETTE RAM"
d_str_work_ram:			STRING "WORK RAM"
