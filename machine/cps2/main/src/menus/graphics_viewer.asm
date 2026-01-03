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
	MENU_ENTRY scroll1_tile_viewer, d_str_scroll1_tile
	MENU_ENTRY scroll2_tile_viewer, d_str_scroll2_tile
	;MENU_ENTRY scroll3_tile_viewer, d_str_scroll3_tile
	MENU_ENTRY sprite_viewer, d_str_sprite_viewer
	MENU_LIST_END

d_str_menu_title:		STRING "GRAPHICS VIEWER"

d_str_scroll1_tile:		STRING "SCROLL1 TILE"
d_str_scroll2_tile:		STRING "SCROLL2 TILE"
d_str_scroll3_tile:		STRING "SCROLL3 TILE"
d_str_sprite_viewer:		STRING "SPRITE VIEWER"
