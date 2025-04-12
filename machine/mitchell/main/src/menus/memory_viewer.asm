	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/dsub.inc"
	include "cpu/z80/include/xy_string.inc"
	include "cpu/z80/include/handlers/menu.inc"

	include "machine.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		ld	a, 0
		ld	(r_menu_cursor), a

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_menu_title
		RSUB	print_string

		ld	ix, d_menu_list
		call	menu_handler

		cp	MENU_CONTINUE
		jr	z, .loop_menu
		ret

view_color_ram:
		ld	ix, COLOR_RAM_START
		jr	view_memory

view_palette_ram:
		ld	ix, PALETTE_RAM_START
		jr	view_memory

view_rom_space:
		ld	ix, $0
		jr	view_memory

view_tile_ram:
		ld	ix, TILE_RAM_START
		jr	view_memory

view_work_ram:
		ld	ix, WORK_RAM_START

view_memory:
		ld	iy, $0			; no callback
		call	memory_viewer_handler
		ret

	section data

d_menu_list:
	MENU_ENTRY view_color_ram, d_str_color_ram
	MENU_ENTRY view_palette_ram, d_str_palette_ram
	MENU_ENTRY view_rom_space, d_str_rom_space
	MENU_ENTRY view_tile_ram, d_str_tile_ram
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:	STRING "MEMORY VIEWER MENU"

d_str_color_ram:	STRING "COLOR RAM"
d_str_palette_ram:	STRING "PALETTE RAM"
d_str_rom_space:	STRING "ROM SPACE"
d_str_tile_ram:		STRING "TILE RAM"
d_str_work_ram:		STRING "WORK RAM"
