	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		lea	d_str_menu_title, a0
		lea	d_menu_list, a1
		jsr	menu_handler
		rts

view_fix_tile:
		lea	FIX_TILE, a0
		bra	view_memory

view_layer_a_tile:
		lea	LAYER_A_TILE, a0
		bra	view_memory

view_layer_b_tile:
		lea	LAYER_B_TILE, a0
		bra	view_memory

view_mmio_input:
		lea	$140020, a0
		bra	view_memory

view_palette_ram:
		lea	PALETTE_RAM, a0
		bra	view_memory

view_rom_space:
		lea	$0, a0
		bra	view_memory

view_sprite_ram:
		lea	SPRITE_RAM, a0
		bra	view_memory

view_work_ram:
		lea	WORK_RAM, a0

view_memory:
		lea	$0, a1			; no callback
		jsr	memory_viewer_handler
		rts

	section data
	align 1

d_menu_list:
	MENU_ENTRY view_fix_tile, d_str_fix_tile
	MENU_ENTRY view_layer_a_tile, d_str_layer_a_tile
	MENU_ENTRY view_layer_b_tile, d_str_layer_b_tile
	MENU_ENTRY view_mmio_input, d_str_mmio_input
	MENU_ENTRY view_palette_ram, d_str_palette_ram
	MENU_ENTRY view_rom_space, d_str_rom_space
	MENU_ENTRY view_sprite_ram, d_str_sprite_ram
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:		STRING "MEMORY VIEWER MENU"

d_str_fix_tile:			STRING "FIX TILE"
d_str_layer_a_tile:		STRING "LAYER A TILE"
d_str_layer_b_tile:		STRING "LAYER B TILE"
d_str_mmio_input:		STRING "MMIO INPUT"
d_str_palette_ram:		STRING "PALETTE RAM"
d_str_rom_space:		STRING "ROM SPACE"
d_str_sprite_ram:		STRING "SPRITE RAM"
d_str_work_ram:			STRING "WORK RAM"

