	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global debug_hardware_menu

	section code

debug_hardware_menu:
		clr	r_menu_cursor

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_menu_title
		RSUB	print_string

		ldy	#d_menu_list
		jsr	menu_handler

		cmpa	#MENU_CONTINUE
		beq	.loop_menu
		rts

	section data

d_menu_list:
	MENU_ENTRY k051733_collision_debug, d_str_k051733_collision_debug
	MENU_ENTRY k051733_math_debug, d_str_k051733_math_debug
	MENU_ENTRY k051733_rand_debug, d_str_k051733_rand_debug
	MENU_ENTRY k051960_zoom_debug, d_str_k051960_zoom_debug
	MENU_ENTRY k051960_zoom2_debug, d_str_k051960_zoom2_debug
	MENU_ENTRY sprite_debug, d_str_sprite_debug
	MENU_ENTRY watchdog_time, d_str_watchdog_time
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG HARDWARE MENU"

d_str_k051733_collision_debug	STRING "K051733 COLLISION DEBUG"
d_str_k051733_math_debug	STRING "K051733 MATH DEBUG"
d_str_k051733_rand_debug	STRING "K051733 RAND DEBUG"
d_str_k051960_zoom_debug	STRING "K051960 ZOOM DEBUG"
d_str_k051960_zoom2_debug	STRING "K051960 ZOOM2 DEBUG"
d_str_sprite_debug:		STRING "SPRITE DEBUG"
d_str_watchdog_time:		STRING "WATCHDOG TIME"
