	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global debug_menu

	section code

debug_menu:
		ld	a, 0
		ld	(r_menu_cursor), a

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ld	de, d_str_menu_title
		RSUB	print_string

		ld	ix, d_menu_list
		call	menu_handler

		cp	MENU_CONTINUE
		jr	z, .loop_menu
		ret

	section data

d_menu_list:
	;MENU_ENTRY ec_dupe_check, d_str_ec_dupe_check
	MENU_ENTRY error_address_test, d_str_error_address_test
	MENU_ENTRY fg_tile_viewer, d_str_fg_tile_viewer
	MENU_ENTRY mad_git_hash, d_str_mad_git_hash
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG MENU"

d_str_ec_dupe_check:		STRING "EC DUPE CHECK"
d_str_error_address_test:	STRING "ERROR ADDRESS TEST"
d_str_fg_tile_viewer:		STRING "FG TILE VIEWER"
d_str_mad_git_hash:		STRING "MAD GIT HASH"
