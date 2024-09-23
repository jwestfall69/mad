	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/handlers/menu.inc"
	include "global/include/screen.inc"

	include "machine.inc"

	global debug_menu

	section code

debug_menu:
		clr	r_menu_cursor

	.loop_menu:
		PSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_menu_title
		PSUB	print_string

		ldy	#d_menu_list
		jsr	menu_handler
		rts

	section data

d_menu_list:
	;MENU_ENTRY ec_dupe_check, d_str_ec_dupe_check
	MENU_ENTRY fg_tile_viewer, d_str_fg_tile_viewer
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG MENU"

d_str_ec_dupe_check:		STRING "EC DUPE CHECK"
d_str_fg_tile_viewer:		STRING "FG TILE VIEWER"
