	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/handlers/menu.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global debug_menu

	section code

debug_menu:
		move.b	#0, MENU_CURSOR

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	3, 3
		lea	STR_MENU_TITLE, a0
		RSUB	print_string

		lea	MENU_LIST, a0
		jsr	menu_handler

		cmp.b	#MENU_CONTINUE, d0
		beq	.loop_menu

		rts

	section data

STR_MENU_TITLE:		STRING "DEBUG MENU"

	align 2

MENU_LIST:
	MENU_ENTRY tile_viewer_handler, STR_TILE_VIEWER
	MENU_LIST_END

STR_TILE_VIEWER:		STRING "TILE/FONT VIEWER"
