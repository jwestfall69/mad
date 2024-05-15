	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/handlers/menu.inc"

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

view_tile1_ram:
		lea	TILE1_RAM_START, a0
		bra	view_memory

view_tile2_ram:
		lea	TILE2_RAM_START, a0
		bra	view_memory

view_tile3_ram:
		lea	TILE3_RAM_START, a0
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
	MENU_ENTRY view_tile1_ram, STR_TILE1_RAM
	MENU_ENTRY view_tile2_ram, STR_TILE2_RAM
	MENU_ENTRY view_tile3_ram, STR_TILE3_RAM
	MENU_ENTRY view_work_ram, STR_WORK_RAM
	MENU_LIST_END


STR_MMIO:		STRING "MMIO"
STR_PALETTE_RAM:	STRING "PALETTE RAM"
STR_PALETTE_EXT_RAM:	STRING "PALETTE EXT RAM"
STR_ROM_SPACE:		STRING "ROM SPACE"
STR_SPRITE_RAM:		STRING "SPRITE RAM"
STR_TILE1_RAM:		STRING "TILE1 RAM"
STR_TILE2_RAM:		STRING "TILE2 RAM"
STR_TILE3_RAM:		STRING "TILE3 RAM"
STR_WORK_RAM:		STRING "WORK RAM"
