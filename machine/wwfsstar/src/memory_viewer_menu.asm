	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/menu_handler.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		move.b	#0, MENU_CURSOR

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	3, 3
		lea	STR_MENU_TITLE, a0
		RSUB	print_string

		lea	MENU_LIST, a0
		lea	menu_input_generic, a1
		jsr	menu_handler

		cmp.b	#MENU_CONTINUE, d0
		beq	.loop_menu

		rts

view_palette_ram:
		lea	PALETTE_RAM_START, a0
		bra	view_ram

view_work_ram:
		lea	WORK_RAM_START, a0

view_ram:
		lea	menu_input_generic, a1
		jsr	memory_viewer_handler
		rts


	section data

STR_MENU_TITLE:		STRING "MEMORY VIEW MENU"

	align 2

MENU_LIST:
	MENU_ENTRY view_work_ram, STR_WORK_RAM
	MENU_ENTRY view_palette_ram, STR_PALETTE_RAM
	MENU_LIST_END


STR_WORK_RAM:		STRING "WORK RAM"
STR_PALETTE_RAM:	STRING "PALETTEL RAM"

