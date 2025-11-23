	include "cpu/konami2/include/common.inc"
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
	MENU_ENTRY sprite_debug, d_str_sprite_debug
	MENU_ENTRY irq_debug, d_str_irq_debug
	MENU_ENTRY k053251_debug, d_str_k053251_debug
	;MENU_ENTRY watchdog_time, d_str_watchdog_time
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG HARDWARE MENU"

d_str_irq_debug:		STRING "IRQ DEBUG"
d_str_k053251_debug:		STRING "K053251 DEBUG"
d_str_sprite_debug:		STRING "SPRITE DEBUG"
d_str_watchdog_time:		STRING "WATCHDOG TIME"
