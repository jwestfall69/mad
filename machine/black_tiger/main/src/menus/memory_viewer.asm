	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		ld	ix, d_str_menu_title
		ld	iy, d_menu_list
		call	menu_handler
		ret

view_bg_tile_ram_bank0:
		ld	ix, BG_TILE_RAM
		ld	a, $0
		jr	view_bg_tile_ram_bankx

view_bg_tile_ram_bank1:
		ld	ix, BG_TILE_RAM
		ld	a, $1
		jr	view_bg_tile_ram_bankx

view_bg_tile_ram_bank2:
		ld	ix, BG_TILE_RAM
		ld	a, $2
		jr	view_bg_tile_ram_bankx

view_bg_tile_ram_bank3:
		ld	ix, BG_TILE_RAM
		ld	a, $3
		jr	view_bg_tile_ram_bankx

view_fix_tile_ram:
		ld	ix, FIX_TILE
		jr	view_memory

view_fix_tile_attr_ram:
		ld	ix, FIX_TILE_ATTR
		jr	view_memory

view_palette_ram:
		ld	ix, PALETTE_RAM
		jr	view_memory

view_rom_space:
		ld	ix, $0
		jr	view_memory

view_sprite_ram:
		ld	ix, SPRITE_RAM
		jr	view_memory

view_work_ram:
		ld	ix, WORK_RAM
		jr	view_memory

view_bg_tile_ram_bankx:
		out	(IO_BG_RAM_BANK), a
view_memory:
		ld	iy, $0			; no callback
		call	memory_viewer_handler
		ld	a, $0
		out	(IO_BG_RAM_BANK), a
		ret

	section data

d_menu_list:
	MENU_ENTRY view_bg_tile_ram_bank0, d_str_bg_tile_ram_bank0, ME_FLAG_NONE
	MENU_ENTRY view_bg_tile_ram_bank1, d_str_bg_tile_ram_bank1, ME_FLAG_NONE
	MENU_ENTRY view_bg_tile_ram_bank2, d_str_bg_tile_ram_bank2, ME_FLAG_NONE
	MENU_ENTRY view_bg_tile_ram_bank3, d_str_bg_tile_ram_bank3, ME_FLAG_NONE
	MENU_ENTRY view_fix_tile_ram, d_str_fix_tile_ram, ME_FLAG_NONE
	MENU_ENTRY view_fix_tile_attr_ram, d_str_fix_tile_attr_ram, ME_FLAG_NONE
	MENU_ENTRY view_palette_ram, d_str_palette_ram, ME_FLAG_NONE
	MENU_ENTRY view_rom_space, d_str_rom_space, ME_FLAG_NONE
	MENU_ENTRY view_sprite_ram, d_str_sprite_ram, ME_FLAG_NONE
	MENU_ENTRY view_work_ram, d_str_work_ram, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "MEMORY VIEWER MENU"

d_str_bg_tile_ram_bank0:	STRING "BG TILE RAM BANK0"
d_str_bg_tile_ram_bank1:	STRING "BG TILE RAM BANK1"
d_str_bg_tile_ram_bank2:	STRING "BG TILE RAM BANK2"
d_str_bg_tile_ram_bank3:	STRING "BG TILE RAM BANK3"
d_str_fix_tile_ram:		STRING "FIX TILE RAM"
d_str_fix_tile_attr_ram:	STRING "FIX TILE ATTR RAM"
d_str_palette_ram:		STRING "PALETTE RAM"
d_str_rom_space:		STRING "ROM SPACE"
d_str_sprite_ram:		STRING "SPRITE RAM"
d_str_work_ram:			STRING "WORK RAM"
