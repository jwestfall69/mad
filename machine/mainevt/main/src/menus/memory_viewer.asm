	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/handlers/menu.inc"

	include "machine.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		clra
		sta	MENU_CURSOR

	.loop_menu:
		PSUB	screen_init

		SEEK_XY	3, 3
		ldy	#STR_MENU_TITLE
		PSUB	print_string

		ldy	#MENU_LIST
		jsr	menu_handler

		cmpa	#MENU_CONTINUE
		beq	.loop_menu
		rts

view_mmio_input:
		ldy	#$1f90
		bra	view_memory

view_palette_ram:
		ldy	#PALETTE_RAM_START
		bra	view_memory

view_rom_space:
		ldy	#$8000
		bra	view_memory

view_rom_bank_space:
		ldy	#$6000
		bra	view_memory

view_tile_ram:
		ldy	#TILE_RAM_START
		bra	view_memory

view_work_ram:
		ldy	#WORK_RAM_START
		bra	view_memory

view_memory:
		jsr	memory_viewer_handler
		rts

	section data

STR_MENU_TITLE:	string "MEMORY VIEWER MENU"

MENU_LIST:
	MENU_ENTRY view_mmio_input, STR_MMIO_INPUT
	MENU_ENTRY view_palette_ram, STR_PALETTE_RAM
	MENU_ENTRY view_rom_space, STR_ROM_SPACE
	MENU_ENTRY view_rom_bank_space, STR_ROM_BANK_SPACE
	MENU_ENTRY view_tile_ram, STR_TILE_RAM
	MENU_ENTRY view_work_ram, STR_WORK_RAM
	MENU_LIST_END

STR_MMIO_INPUT:		string "MMIO INPUT"
STR_PALETTE_RAM:	string "PALETTE RAM"
STR_ROM_SPACE:		string "ROM SPACE"
STR_ROM_BANK_SPACE:	string "ROM BANK SPACE"
STR_TILE_RAM:		string "TILE RAM"
STR_WORK_RAM:		string "WORK RAM"
