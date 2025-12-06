	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global debug_menu

	section code

debug_menu:
		lea	d_str_menu_title, a0
		lea	d_menu_list, a1
		jsr	menu_handler
		rts

	section data
	align 1

d_menu_list:
	MENU_ENTRY bg_tile_viewer, d_str_bg_tile_viewer
	MENU_ENTRY ec_dupe_check, d_str_ec_dupe_check
	MENU_ENTRY error_address_test, d_str_error_address_test
	MENU_ENTRY fg_tile_viewer, d_str_fg_tile_viewer
	MENU_ENTRY mad_git_hash, d_str_mad_git_hash
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG MENU"

d_str_bg_tile_viewer:		STRING "BG TILE VIEWER"
d_str_ec_dupe_check:		STRING "EC DUPE CHECK"
d_str_error_address_test:	STRING "ERROR ADDRESS TEST"
d_str_fg_tile_viewer:		STRING "FG TILE VIEWER"
d_str_mad_git_hash:		STRING "MAD GIT HASH"
