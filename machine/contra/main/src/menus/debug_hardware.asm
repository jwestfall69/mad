	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global debug_hardware_menu

	section code

debug_hardware_menu:
		ldx	#d_str_menu_title
		ldy	#d_menu_list
		jsr	menu_handler
		rts

	section data

d_menu_list:
	MENU_ENTRY sprite_debug, d_str_sprite_debug
	MENU_ENTRY sprite_draw_order, d_str_sprite_draw_order
	MENU_ENTRY sprite_max_8x8, d_str_sprite_max_8x8
	MENU_ENTRY sprite_max_8x16, d_str_sprite_max_8x16
	MENU_ENTRY sprite_max_16x8, d_str_sprite_max_16x8
	MENU_ENTRY sprite_max_16x16, d_str_sprite_max_16x16
	MENU_ENTRY sprite_max_32x32, d_str_sprite_max_32x32
	MENU_ENTRY sprite_max_column, d_str_sprite_max_column
	MENU_ENTRY sprite_max_row, d_str_sprite_max_row
	MENU_ENTRY watchdog_time, d_str_watchdog_time
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG HARDWARE MENU"

d_str_sprite_debug:		STRING "SPRITE DEBUG"
d_str_sprite_draw_order:	STRING "SPRITE DRAW ORDER"
d_str_sprite_max_8x8:		STRING "SPRITE MAX 8X8"
d_str_sprite_max_8x16:		STRING "SPRITE MAX 8X16"
d_str_sprite_max_16x8:		STRING "SPRITE MAX 16X8"
d_str_sprite_max_16x16:		STRING "SPRITE MAX 16X16"
d_str_sprite_max_32x32:		STRING "SPRITE MAX 32X32"
d_str_sprite_max_column:	STRING "SPRITE MAX COLUMN"
d_str_sprite_max_row:		STRING "SPRITE MAX ROW"
d_str_watchdog_time:		STRING "WATCHDOG TIME"
