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
	MENU_ENTRY fix_tile_viewer, d_str_fix_tile, ME_FLAG_NONE
	MENU_ENTRY layer_a_tile_viewer, d_str_layer_a_tile, ME_FLAG_NONE
	MENU_ENTRY layer_b_tile_viewer, d_str_layer_b_tile, ME_FLAG_NONE
	MENU_ENTRY sprite_viewer, d_str_sprite_viewer, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "GRAPHICS VIEWER"

d_str_fix_tile:			STRING "FIX TILE"
d_str_layer_a_tile:		STRING "LAYER A TILE"
d_str_layer_b_tile:		STRING "LAYER B TILE"
d_str_sprite_viewer:		STRING "SPRITE VIEWER"
