	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		ld	ix, d_str_menu_title
		ld	iy, d_menu_list
		call	menu_handler
		ret

view_mmio_space:
		ld	ix, $f200
		jr	view_memory

view_rom_space:
		ld	ix, $0
		jr	view_memory

view_sprite_ram:
		ld	ix, SPRITE_RAM
		jr	view_memory

view_tile_ram:
		ld	ix, TILE_RAM
		jr	view_memory

view_work_ram:
		ld	ix, WORK_RAM

view_memory:
		ld	iy, $0			; no callback
		call	memory_viewer_handler
		ret

	section data

d_menu_list:
	MENU_ENTRY view_mmio_space, d_str_mmio_space
	MENU_ENTRY view_rom_space, d_str_rom_space
	MENU_ENTRY view_sprite_ram, d_str_sprite_ram
	MENU_ENTRY view_tile_ram, d_str_tile_ram
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:	STRING "MEMORY VIEWER MENU"

d_str_mmio_space:	STRING "MMIO SPACE"
d_str_rom_space:	STRING "ROM SPACE"
d_str_sprite_ram:	STRING "SPRITE RAM"
d_str_tile_ram:		STRING "TILE RAM"
d_str_work_ram:		STRING "WORK RAM"
