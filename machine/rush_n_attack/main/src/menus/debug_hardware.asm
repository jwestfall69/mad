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
	MENU_ENTRY k005849_reg_debug, d_str_k005849_reg_debug, ME_FLAG_NONE
	MENU_ENTRY sprite_debug, d_str_sprite_debug, ME_FLAG_NONE
	MENU_ENTRY tile_debug, d_str_tile_debug, ME_FLAG_NONE
	MENU_ENTRY watchdog_time, d_str_watchdog_time, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG HARDWARE MENU"

d_str_k005849_reg_debug:	STRING "K005849 REG DEBUG"
d_str_sprite_debug:		STRING "SPRITE DEBUG"
d_str_tile_debug:		STRING "TILE DEBUG"
d_str_watchdog_time:		STRING "WATCHDOG TIME"

