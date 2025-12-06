	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global debug_menu

	section code

debug_menu:
		ld	ix, d_str_menu_title
		ld	iy, d_menu_list
		call	menu_handler
		ret

	section data

d_menu_list:
	ifd _DEBUG_HARDWARE_
		MENU_ENTRY debug_hardware_menu, d_str_debug_hardware
	endif
	;MENU_ENTRY ec_dupe_check, d_str_ec_dupe_check
	MENU_ENTRY error_address_test, d_str_error_address_test
	MENU_ENTRY mad_git_hash, d_str_mad_git_hash
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG MENU"

d_str_debug_hardware:		STRING "DEBUG HARDWARE"
;d_str_ec_dupe_check:		STRING "EC DUPE CHECK"
d_str_error_address_test:	STRING "ERROR ADDRESS TEST"
d_str_fg_tile_viewer:		STRING "FG TILE VIEWER"
d_str_mad_git_hash:		STRING "MAD GIT HASH"
