	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

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
	MENU_ENTRY k007121_10e_sprite_viewer, d_str_k007121_10e_sprite
	MENU_ENTRY k007121_10e_tile_viewer, d_str_k007121_10e_tile
	MENU_ENTRY k007121_18e_sprite_viewer, d_str_k007121_18e_sprite
	MENU_ENTRY k007121_18e_tile_viewer, d_str_k007121_18e_tile
	MENU_LIST_END

d_str_menu_title:		STRING "GRAPHICS VIEWER"

d_str_k007121_10e_sprite:	STRING "K007121 10E SPRITE"
d_str_k007121_10e_tile:		STRING "K007121 10E TILE"
d_str_k007121_18e_sprite:	STRING "K007121 18E SPRITE"
d_str_k007121_18e_tile:		STRING "K007121 18E TILE"
