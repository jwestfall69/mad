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
	MENU_ENTRY manual_k007121_g8_ram_tests, d_str_k007121_g8_ram, ME_FLAG_NONE
	MENU_ENTRY manual_k007121_g15_ram_tests, d_str_k007121_g15_ram, ME_FLAG_NONE
	MENU_ENTRY manual_palette_ram_tests, d_str_palette_ram, ME_FLAG_NONE
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "RAM TESTS"

d_str_k007121_g8_ram:		STRING "K007121 G8 RAM"
d_str_k007121_g15_ram:		STRING "K007121 G15 RAM"
d_str_palette_ram:		STRING "PALETTE RAM"
d_str_work_ram:			STRING "WORK RAM"
