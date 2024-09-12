	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/handlers/menu.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global debug_menu

	section code

debug_menu:
		move.b	#0, r_menu_cursor

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	3, 3
		lea	d_str_menu_title, a0
		RSUB	print_string

		lea	d_menu_list, a0
		jsr	menu_handler

		cmp.b	#MENU_CONTINUE, d0
		beq	.loop_menu

		rts

	section data
	align 2

d_menu_list:
	MENU_ENTRY ec_dupe_check, d_str_ec_dupe_check
	MENU_ENTRY fg_tile_viewer, d_str_fg_tile_viewer
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG MENU"

d_str_ec_dupe_check:		STRING "EC DUPE CHECK"
d_str_fg_tile_viewer:		STRING "FG TILE VIEWER"
