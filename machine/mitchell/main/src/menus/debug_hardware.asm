	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global debug_hardware_menu

	section code

debug_hardware_menu:
		ld	ix, d_str_menu_title
		ld	iy, d_menu_list
		call	menu_handler
		ret

	section data

d_menu_list:
	MENU_ENTRY sprite_debug, d_str_sprite_debug
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG HARDWARE MENU"

d_str_sprite_debug:		STRING "SPRITE DEBUG"

