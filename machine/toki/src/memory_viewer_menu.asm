	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/handlers/menu.inc"

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
		lea	menu_input_generic, a1
		jsr	menu_handler

		cmp.b	#MENU_CONTINUE, d0
		beq	.loop_menu

		rts

view_bg1_ram:
		lea	BG1_RAM_START, a0
		bra	view_memory

view_bg2_ram:
		lea	BG2_RAM_START, a0
		bra	view_memory

view_fg_ram:
		lea	FG_RAM_START, a0
		bra	view_memory

view_mmio_input:
		lea	$0c0000, a0
		bra	view_memory

view_mmio_screen:
		lea	$0a0000, a0
		bra	view_memory

view_palette_ram:
		lea	PALETTE_RAM_START, a0
		bra	view_memory

view_rom_space:
		lea	$0, a0
		bra	view_memory

view_sprite_ram:
		lea	SPRITE_RAM_START, a0
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
	MENU_ENTRY view_bg1_ram, STR_BG1_RAM
	MENU_ENTRY view_bg2_ram, STR_BG2_RAM
	MENU_ENTRY view_fg_ram, STR_FG_RAM
	MENU_ENTRY view_mmio_input, STR_MMIO_INPUT
	MENU_ENTRY view_mmio_screen, STR_MMIO_SCREEN
	MENU_ENTRY view_palette_ram, STR_PALETTE_RAM
	MENU_ENTRY view_rom_space, STR_ROM_SPACE
	MENU_ENTRY view_sprite_ram, STR_SPRITE_RAM
	MENU_ENTRY view_work_ram, STR_WORK_RAM
	MENU_LIST_END


STR_BG1_RAM:		STRING "BG1 RAM"
STR_BG2_RAM:		STRING "BG2 RAM"
STR_FG_RAM:		STRING "FG RAM"
STR_MMIO_INPUT:		STRING "MMIO INPUT"
STR_MMIO_SCREEN:	STRING "MMIO SCREEN"
STR_PALETTE_RAM:	STRING "PALETTE RAM"
STR_ROM_SPACE:		STRING "ROM SPACE"
STR_SPRITE_RAM:		STRING "SPRITE RAM"
STR_WORK_RAM:		STRING "WORK RAM"

