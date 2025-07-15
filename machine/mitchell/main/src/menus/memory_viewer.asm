	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

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

view_palette_ram:
		ld	ix, PALETTE_RAM
		jr	view_memory

view_rom_space:
		ld	ix, $0
		jr	view_memory

view_sprite_ram:
		ld	ix, SPRITE_RAM
		ld	iy, read_memory_sprite_cb
		jr	view_memory_cb

view_tile_ram:
		ld	ix, TILE_RAM
		jr	view_memory

view_tile_attr_ram:
		ld	ix, TILE_ATTR_RAM
		jr	view_memory
view_work_ram:
		ld	ix, WORK_RAM

view_memory:
		ld	iy, $0			; no callback
view_memory_cb:
		call	memory_viewer_handler
		ret

; sprite ram is banked with tile ram
; params:
;  ix = address to read from
;  iy = address to write long to
read_memory_sprite_cb:
		ld	a, VIDEO_BANK_SPRITE
		out	(IO_VIDEO_BANK), a

		ld	b, (ix)
		ld	(iy), b
		ld	b, (ix + 1)
		ld	(iy + 1), b
		ld	b, (ix + 2)
		ld	(iy + 2), b
		ld	b, (ix + 3)
		ld	(iy + 3), b

		ld	a, VIDEO_BANK_TILE
		out	(IO_VIDEO_BANK), a
		ret

	section data

d_menu_list:
	MENU_ENTRY view_palette_ram, d_str_palette_ram
	MENU_ENTRY view_rom_space, d_str_rom_space
	MENU_ENTRY view_sprite_ram, d_str_sprite_ram
	MENU_ENTRY view_tile_ram, d_str_tile_ram
	MENU_ENTRY view_tile_attr_ram, d_str_tile_attr_ram
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:	STRING "MEMORY VIEWER MENU"

d_str_palette_ram:	STRING "PALETTE RAM"
d_str_rom_space:	STRING "ROM SPACE"
d_str_sprite_ram:	STRING "SPRITE RAM"
d_str_tile_ram:		STRING "TILE RAM"
d_str_tile_attr_ram:	STRING "TILE ATTR RAM"
d_str_work_ram:		STRING "WORK RAM"
