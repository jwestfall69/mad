	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global debug_hardware_menu

	section code

debug_hardware_menu:
		ldx	#d_str_menu_title
		ldy	#d_menu_list
		jsr	menu_handler
		rts

ram_find_scroll:
		ldx	#SCROLL_RAM
		jmp	ram_find

ram_find_sprite:
		ldx	#SPRITE_RAM
		jmp	ram_find

ram_find_tile:
		ldx	#TILE_RAM
		jmp	ram_find

ram_find_work:
		ldx	#r_work_ram
		jmp	ram_find


	section data

d_menu_list:
	MENU_ENTRY k005849_reg_debug, d_str_k005849_reg_debug, ME_FLAG_NONE
	MENU_ENTRY sprite_debug, d_str_sprite_debug, ME_FLAG_NONE
	MENU_ENTRY tile_debug, d_str_tile_debug, ME_FLAG_NONE
	MENU_ENTRY ram_find_none, d_str_ram_find_none, ME_FLAG_NONE
	MENU_ENTRY ram_find_scroll, d_str_ram_find_scroll, ME_FLAG_NONE
	MENU_ENTRY ram_find_sprite, d_str_ram_find_sprite, ME_FLAG_NONE
	MENU_ENTRY ram_find_tile, d_str_ram_find_tile, ME_FLAG_NONE
	MENU_ENTRY ram_find_work, d_str_ram_find_work, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG HARDWARE MENU"

d_str_k005849_reg_debug:	STRING "K005849 REG DEBUG"
d_str_sprite_debug:		STRING "SPRITE DEBUG"
d_str_tile_debug:		STRING "TILE DEBUG"

d_str_ram_find_none:		STRING "RAM FIND NONE"
d_str_ram_find_scroll:		STRING "RAM FIND SCROLL"
d_str_ram_find_sprite:		STRING "RAM FIND SPRITE"
d_str_ram_find_tile:		STRING "RAM FIND TILE"
d_str_ram_find_work:		STRING "RAM FIND WORK"

	section bss

r_work_ram:	dcb.b 1
