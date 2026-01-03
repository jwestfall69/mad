	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global debug_hardware_menu

	section code

palette_debug:
		RSUB	screen_update_palette
		WATCHDOG
		bra	palette_debug

debug_hardware_menu:
		lea	d_str_menu_title, a0
		lea	d_menu_list, a1
		jsr	menu_handler
		rts

	section data
	align 1

d_menu_list:
	MENU_ENTRY sprite_debug, d_str_sprite_debug
	MENU_ENTRY palette_debug, d_str_palette_debug
	MENU_ENTRY watchdog_time, d_str_watchdog_time
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG HARDWARE MENU"

d_str_sprite_debug:		STRING "SPRITE DEBUG"
d_str_palette_debug:		STRING "PALETTE DEBUG"
d_str_watchdog_time:		STRING "WATCHDOG TIME"
