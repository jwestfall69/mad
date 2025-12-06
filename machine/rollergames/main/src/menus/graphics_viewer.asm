	include "cpu/konami2/include/common.inc"
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
	MENU_ENTRY sprite_viewer, d_str_sprite_viewer
	MENU_ENTRY tile_viewer, d_str_tile_viewer
	MENU_LIST_END

d_str_menu_title:		STRING "GRAPHICS VIEWER"

d_str_sprite_viewer:		STRING "SPRITE VIEWER"
d_str_tile_viewer:		STRING "TILE VIEWER"
