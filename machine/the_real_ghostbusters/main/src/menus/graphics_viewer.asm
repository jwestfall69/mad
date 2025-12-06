	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global graphics_viewer_menu

	section code

graphics_viewer_menu:
		ldx	#d_str_menu_title
		ldy	#d_menu_list
		jsr	menu_handler
		rts

	section data

d_menu_list:
	MENU_ENTRY fix_tile_viewer, d_str_fix_tile
	MENU_ENTRY bac06_tile_viewer, d_str_bac06_tile
	MENU_ENTRY sprite_viewer, d_str_sprite_viewer
	MENU_LIST_END

d_str_menu_title:		STRING "GRAPHICS VIEWER"

d_str_fix_tile:			STRING "FIX TILE"
d_str_bac06_tile:		STRING "BAC06 TILE"
d_str_sprite_viewer:		STRING "SPRITE VIEWER"
