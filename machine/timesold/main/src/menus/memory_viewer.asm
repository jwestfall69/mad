	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/handlers/menu.inc"

	include "machine.inc"
	include "mad_rom.inc"

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
		jsr	menu_handler

		cmp.b	#MENU_CONTINUE, d0
		beq	.loop_menu

		rts

view_palette_ram:
		lea	PALETTE_RAM_START, a0
		bra	view_memory

view_rom_space:
		lea	$0, a0
		bra	view_memory

view_sprite_ram:
		lea	SPRITE_RAM_START, a0
		bra	view_memory

view_tile_ram:
		lea	TILE_RAM_START, a0
		bra	view_memory

view_work_ram:
		lea	WORK_RAM_START, a0

view_memory:
		jsr	memory_viewer_handler
		rts

	section data

STR_MENU_TITLE:		STRING "MEMORY VIEWER MENU"

	align 2

MENU_LIST:
	MENU_ENTRY view_palette_ram, STR_PALETTE_RAM
	MENU_ENTRY view_rom_space, STR_ROM_SPACE
	MENU_ENTRY view_sprite_ram, STR_SPRITE_RAM
	MENU_ENTRY view_tile_ram, STR_TILE_RAM
	MENU_ENTRY view_work_ram, STR_WORK_RAM
	MENU_LIST_END


STR_MMIO:		STRING "MMIO"
STR_PALETTE_RAM:	STRING "PALETTE RAM"
STR_ROM_SPACE:		STRING "ROM SPACE"
STR_SPRITE_RAM:		STRING "SPRITE RAM"
STR_TILE_RAM:		STRING "TILE RAM"
STR_WORK_RAM:		STRING "WORK RAM"
