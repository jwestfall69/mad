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

view_mmio:
		lea	$30c000, a0
		bra	view_memory

view_palette_ram:
		lea	PALETTE_RAM_START, a0
		bra	view_memory


view_palette_ext_ram:
		lea	PALETTE_EXT_RAM_START, a0
		bra	view_memory

view_rom_space:
		lea	$0, a0
		bra	view_memory

view_sprite_ram:
		lea	SPRITE_RAM_START, a0
		bra	view_memory

view_tile1_space:
		lea	TILE1_DATA_START, a0
		bra	view_memory

view_tile2_space:
		lea	TILE2_DATA_START, a0
		bra	view_memory

view_tile3_space:
		lea	TILE3_DATA_START, a0
		bra	view_memory

view_work_ram:
		lea	WORK_RAM_START, a0

view_memory:
		lea	menu_input_generic, a1
		jsr	memory_viewer_handler
		rts


	section data

STR_MENU_TITLE:		STRING "MEMORY VIEWER MENU"

	align 2

MENU_LIST:
	MENU_ENTRY view_mmio, STR_MMIO
	MENU_ENTRY view_palette_ram, STR_PALETTE_RAM
	MENU_ENTRY view_palette_ext_ram, STR_PALETTE_EXT_RAM
	MENU_ENTRY view_rom_space, STR_ROM_SPACE
	MENU_ENTRY view_sprite_ram, STR_SPRITE_RAM
	MENU_ENTRY view_tile1_space, STR_TILE1_SPACE
	MENU_ENTRY view_tile2_space, STR_TILE2_SPACE
	MENU_ENTRY view_tile3_space, STR_TILE3_SPACE
	MENU_ENTRY view_work_ram, STR_WORK_RAM
	MENU_LIST_END


STR_MMIO:		STRING "MMIO"
STR_PALETTE_RAM:	STRING "PALETTE RAM"
STR_PALETTE_EXT_RAM:	STRING "PALETTE EXT RAM"
STR_ROM_SPACE:		STRING "ROM SPACE"
STR_SPRITE_RAM:		STRING "SPRITE RAM"
STR_TILE1_SPACE:	STRING "TILE1 SPACE"
STR_TILE2_SPACE:	STRING "TILE2 SPACE"
STR_TILE3_SPACE:	STRING "TILE3 SPACE"
STR_WORK_RAM:		STRING "WORK RAM"
