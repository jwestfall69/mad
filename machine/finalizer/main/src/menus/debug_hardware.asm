	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global debug_hardware_menu

	section code

debug_hardware_menu:
		ldx	#d_str_menu_title
		ldy	#d_menu_list
		jsr	menu_handler
		rts


ram_find_k005885_tile_a:
		ldx	#K005885_TILE_A
		jmp	ram_find

ram_find_k005885_tile_b:
		ldx	#K005885_TILE_A
		jmp	ram_find

ram_find_k005885_sprite:
		ldx	#K005885_SPRITE
		jmp	ram_find

ram_find_work:
		ldx	#r_work_ram
		jmp	ram_find


	section data

d_menu_list:
	MENU_ENTRY k005885_reg_debug, d_str_k005885_reg_debug, ME_FLAG_NONE
	MENU_ENTRY k005885_sprite_debug, d_str_k005885_sprite_debug, ME_FLAG_NONE
	MENU_ENTRY ram_find_none, d_str_ram_find_none, ME_FLAG_NONE
	MENU_ENTRY ram_find_k005885_sprite, d_str_ram_find_k005885_sprite, ME_FLAG_NONE
	MENU_ENTRY ram_find_k005885_tile_a, d_str_ram_find_k005885_tile_a, ME_FLAG_NONE
	MENU_ENTRY ram_find_k005885_tile_b, d_str_ram_find_k005885_tile_b, ME_FLAG_NONE
	MENU_ENTRY ram_find_work, d_str_ram_find_work, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG HARDWARE MENU"

d_str_k005885_reg_debug:	STRING "K005885 REG DEBUG"
d_str_k005885_sprite_debug:	STRING "K005885 SPRITE DEBUG"

d_str_ram_find_k005885_sprite:	STRING "RAM FIND K005885 SPRITE"
d_str_ram_find_k005885_tile_a:	STRING "RAM FIND K005885 TILE A"
d_str_ram_find_k005885_tile_b:	STRING "RAM FIND K005885 TILE B"
d_str_ram_find_none:		STRING "RAM FIND NONE"
d_str_ram_find_work:		STRING "RAM FIND WORK"

	section bss

r_work_ram:	dcb.b 1
