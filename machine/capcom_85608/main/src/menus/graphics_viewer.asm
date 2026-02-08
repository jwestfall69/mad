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
	MENU_ENTRY bg_image_viewer, d_str_bg_image_viewer, ME_FLAG_NONE
	MENU_ENTRY bg_tile_viewer, d_str_bg_tile_viewer, ME_FLAG_NONE
	MENU_ENTRY fix_tile_viewer, d_str_fix_tile_viewer, ME_FLAG_NONE
	MENU_ENTRY sprite_viewer, d_str_sprite_viewer, ME_FLAG_NONE
	MENU_LIST_END


d_str_menu_title:		STRING "GRAPHICS VIEWER"

d_str_bg_image_viewer:		STRING "BG IMAGE VIEWER"
d_str_bg_tile_viewer:		STRING "BG TILE VIEWER"
d_str_fix_tile_viewer:		STRING "FIX TILE VIEWER"
d_str_sprite_viewer:		STRING "SPRITE VIEWER"
