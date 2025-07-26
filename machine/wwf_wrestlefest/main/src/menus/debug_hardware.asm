	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global debug_hardware_menu

	section code

debug_hardware_menu:
		move.b	#0, r_menu_cursor

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		lea	d_str_menu_title, a0
		RSUB	print_string

		lea	d_menu_list, a0
		jsr	menu_handler

		cmp.b	#MENU_CONTINUE, d0
		beq	.loop_menu

		rts

	section data
	align 1

d_menu_list:
	MENU_ENTRY sprite_debug, d_str_sprite_debug
	MENU_ENTRY watchdog_time, d_str_watchdog_time
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG HARDWARE MENU"

d_str_sprite_debug:		STRING "SPRITE DEBUG"
d_str_watchdog_time:		STRING "WATCHDOG TIME"
