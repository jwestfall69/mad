	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global graphics_viewer_menu

	section code

graphics_viewer_menu:
		ld	ix, d_str_menu_title
		ld	iy, d_menu_list
		call	menu_handler
		ret

	section data

d_menu_list:
	MENU_ENTRY tile_viewer, d_str_tile_viewer, ME_FLAG_NONE
	MENU_ENTRY sprite_viewer, d_str_sprite_viewer, ME_FLAG_NONE
	MENU_LIST_END


d_str_menu_title:		STRING "GRAPHICS VIEWER"

d_str_tile_viewer:		STRING "TILE VIEWER"
d_str_sprite_viewer:		STRING "SPRITE VIEWER"
