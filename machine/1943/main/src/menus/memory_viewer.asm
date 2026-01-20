	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		ld	ix, d_str_menu_title
		ld	iy, d_menu_list
		call	menu_handler
		ret

view_rom_space:
		ld	ix, $0
		jr	view_memory

view_sprite_ram:
		ld	ix, SPRITE_RAM
		jr	view_memory

view_fix_tile_ram:
		ld	ix, FIX_TILE
		jr	view_memory

view_fix_tile_attr_ram:
		ld	ix, FIX_TILE_ATTR
		jr	view_memory
view_work_ram:
		ld	ix, WORK_RAM

view_memory:
		ld	iy, $0			; no callback
		call	memory_viewer_handler
		ret

	section data

d_menu_list:
	MENU_ENTRY view_rom_space, d_str_rom_space, ME_FLAG_NONE
	MENU_ENTRY view_sprite_ram, d_str_sprite_ram, ME_FLAG_NONE
	MENU_ENTRY view_fix_tile_ram, d_str_fix_tile_ram, ME_FLAG_NONE
	MENU_ENTRY view_fix_tile_attr_ram, d_str_fix_tile_attr_ram, ME_FLAG_NONE
	MENU_ENTRY view_work_ram, d_str_work_ram, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:	STRING "MEMORY VIEWER MENU"

d_str_rom_space:		STRING "ROM SPACE"
d_str_sprite_ram:		STRING "SPRITE RAM"
d_str_fix_tile_ram:		STRING "FIX TILE RAM"
d_str_fix_tile_attr_ram:	STRING "FIX TILE ATTR RAM"
d_str_work_ram:			STRING "WORK RAM"
