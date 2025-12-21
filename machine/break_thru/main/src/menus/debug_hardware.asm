	include "cpu/6809/include/common.inc"
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
	MENU_ENTRY reg1803_debug, d_str_reg1803_debug
	MENU_ENTRY sprite_debug, d_str_sprite_debug
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG HARDWARE MENU"

d_str_reg1803_debug:		STRING "REG1803 DEBUG"
d_str_sprite_debug:		STRING "SPRITE DEBUG"
