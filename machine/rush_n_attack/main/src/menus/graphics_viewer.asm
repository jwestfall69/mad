	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global graphics_viewer_menu

	section code

graphics_viewer_menu:

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

	section data

d_menu_list:
	MENU_ENTRY tile_viewer, d_str_tile_viewer
	MENU_ENTRY sprite_viewer, d_str_sprite_viewer
	MENU_LIST_END


d_str_menu_title:		STRING "GRAPHICS VIEWER"

d_str_tile_viewer:		STRING "TILE VIEWER"
d_str_sprite_viewer:		STRING "SPRITE VIEWER"
