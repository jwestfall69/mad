	include "cpu/6809/include/common.inc"
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
	MENU_ENTRY k005885_tile_a_viewer, d_str_k005885_tile_a, ME_FLAG_NONE
	MENU_ENTRY k005885_sprite_viewer, d_str_k005885_sprite_viewer, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "GRAPHICS VIEWER"

d_str_k005885_tile_a:		STRING "K005885 TILE A"
d_str_k005885_sprite_viewer:	STRING "K005885 SPRITE VIEWER"
