	include "global/include/macros.inc"
	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	include "cpu/6309/include/dsub.inc"

	include "machine.inc"

	global graphics_viewer_menu

	section code

graphics_viewer_menu:
		clr	r_menu_cursor

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_menu_title
		RSUB	print_string

		ldy	#d_menu_list
		jsr	menu_handler

		cmpa	#MENU_CONTINUE
		beq	.loop_menu
		rts

	section data

d_menu_list:
	MENU_ENTRY fix_tile_viewer, d_str_fix_tile
	MENU_ENTRY layer_a_tile_viewer, d_str_layer_a_tile
	MENU_ENTRY layer_b_tile_viewer, d_str_layer_b_tile
	MENU_ENTRY sprite_viewer, d_str_sprite_viewer
	MENU_LIST_END

d_str_menu_title:		STRING "GRAPHICS VIEWER"

d_str_fix_tile:			STRING "FIX TILE"
d_str_layer_a_tile:		STRING "LAYER A TILE"
d_str_layer_b_tile:		STRING "LAYER B TILE"
d_str_sprite_viewer:		STRING "SPRITE VIEWER"
