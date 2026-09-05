	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		ldx	#d_str_menu_title
		ldy	#d_menu_list
		jsr	menu_handler
		rts

view_k005885_sprite_ram:
		ldx	#K005885_SPRITE
		bra	view_memory

view_k005885_tile_a_ram:
		ldx	#K005885_TILE_A
		bra	view_memory

view_k005885_tile_a_attr_ram:
		ldx	#K005885_TILE_A_ATTR
		bra	view_memory

view_k005885_tile_b_ram:
		ldx	#K005885_TILE_B
		bra	view_memory

view_k005885_tile_b_attr_ram:
		ldx	#K005885_TILE_B_ATTR
		bra	view_memory

view_mmio_input:
		ldx	#$0800
		bra	view_memory

view_rom_space:
		ldx	#$c000
		bra	view_memory

view_work_ram:
		ldx	#WORK_RAM
		bra	view_memory

view_memory:
		ldy	#$0			; no callback
		jsr	memory_viewer_handler
		rts

	section data

d_menu_list:
	MENU_ENTRY view_k005885_sprite_ram, d_str_k005885_sprite_ram, ME_FLAG_NONE
	MENU_ENTRY view_k005885_tile_a_ram, d_str_k005885_tile_a_ram, ME_FLAG_NONE
	MENU_ENTRY view_k005885_tile_a_attr_ram, d_str_k005885_tile_a_attr_ram, ME_FLAG_NONE
	MENU_ENTRY view_k005885_tile_b_ram, d_str_k005885_tile_b_ram, ME_FLAG_NONE
	MENU_ENTRY view_k005885_tile_b_attr_ram, d_str_k005885_tile_b_attr_ram, ME_FLAG_NONE
	MENU_ENTRY view_mmio_input, d_str_mmio_input, ME_FLAG_NONE
	MENU_ENTRY view_rom_space, d_str_rom_space, ME_FLAG_NONE
	MENU_ENTRY view_work_ram, d_str_work_ram, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "MEMORY VIEWER MENU"

d_str_k005885_sprite_ram:	STRING "K005885 SPRITE RAM"
d_str_k005885_tile_a_ram:	STRING "K005885 TILE A RAM"
d_str_k005885_tile_a_attr_ram:	STRING "K005885 TILE A ATTR RAM"
d_str_k005885_tile_b_ram:	STRING "K005885 TILE B RAM"
d_str_k005885_tile_b_attr_ram:	STRING "K005885 TILE B ATTR RAM"
d_str_mmio_input:		STRING "MMIO INPUT"
d_str_rom_space:		STRING "ROM SPACE"
d_str_work_ram:			STRING "WORK RAM"
