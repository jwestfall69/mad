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
	MENU_ENTRY a0000_debug, d_str_a0000_debug
	MENU_ENTRY a0010_debug, d_str_a0010_debug
	MENU_ENTRY a0020_debug, d_str_a0020_debug
	MENU_ENTRY a0030_debug, d_str_a0030_debug
	MENU_ENTRY a0040_debug, d_str_a0040_debug
	MENU_ENTRY a0050_debug, d_str_a0050_debug
	MENU_ENTRY sprite_debug, d_str_sprite_debug
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG HARDWARE MENU"

d_str_a0000_debug:		STRING "A0000 DEBUG"
d_str_a0010_debug:		STRING "A0010 DEBUG"
d_str_a0020_debug:		STRING "A0020 DEBUG"
d_str_a0030_debug:		STRING "A0030 DEBUG"
d_str_a0040_debug:		STRING "A0040 DEBUG"
d_str_a0050_debug:		STRING "A0050 DEBUG"
d_str_sprite_debug:		STRING "SPRITE DEBUG"
