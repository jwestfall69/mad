	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global graphics_viewer_menu

	section code

graphics_viewer_menu:
		move.b	#0, r_menu_cursor

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		lea	d_str_menu_title, a0
		RSUB	print_string

		lea	d_menu_list, a0
		jsr	menu_handler

		cmp.b	#MENU_CONTINUE, d0
		beq	.loop_menu

		rts

	section data
	align 1

d_menu_list:
	MENU_ENTRY bg_tile_viewer, d_str_bg_tile
	MENU_ENTRY fg_tile_viewer, d_str_fg_tile
	MENU_ENTRY sprite_viewer, d_str_sprite_viewer
	MENU_ENTRY txt_tile_viewer, d_str_txt_tile
	MENU_LIST_END

d_str_menu_title:		STRING "GRAPHICS VIEWER"

d_str_bg_tile:			STRING "BG TILE"
d_str_fg_tile:			STRING "FG TILE"
d_str_sprite_viewer:		STRING "SPRITE VIEWER"
d_str_txt_tile:			STRING "TXT TILE"
