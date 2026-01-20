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
	MENU_ENTRY manual_bac06_ram_tests, d_str_bac06_ram, ME_FLAG_NONE
	MENU_ENTRY manual_sprite_ram_tests, d_str_sprite_ram, ME_FLAG_NONE
	MENU_ENTRY manual_video_ram_tests, d_str_video_ram, ME_FLAG_NONE
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "RAM TESTS"

d_str_bac06_ram:		STRING "BAC06 RAM"
d_str_palette_ram:		STRING "PALETTE RAM"
d_str_sprite_ram:		STRING "SPRITE RAM"
d_str_video_ram:		STRING "VIDEO RAM"
d_str_work_ram:			STRING "WORK RAM"
