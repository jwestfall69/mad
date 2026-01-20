	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global graphics_viewer_menu

	section code

graphics_viewer_menu:
		lea	d_str_menu_title, a0
		lea	d_menu_list, a1
		jsr	menu_handler
		rts

	section data
	align 1

d_menu_list:
	MENU_ENTRY bg_tile_viewer, d_str_bg_tile, ME_FLAG_NONE
	MENU_ENTRY fg_tile_viewer, d_str_fg_tile, ME_FLAG_NONE
	MENU_ENTRY sprite_viewer, d_str_sprite_viewer, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "GRAPHICS VIEWER"

d_str_bg_tile:			STRING "BG TILE"
d_str_fg_tile:			STRING "FG TILE"
d_str_sprite_viewer:		STRING "SPRITE VIEWER"
