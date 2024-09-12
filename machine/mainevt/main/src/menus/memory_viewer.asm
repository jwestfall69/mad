	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/handlers/menu.inc"

	include "machine.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		clra
		sta	r_menu_cursor

	.loop_menu:
		PSUB	screen_init

		SEEK_XY	3, 3
		ldy	#d_str_menu_title
		PSUB	print_string

		ldy	#d_menu_list
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

d_menu_list:
	MENU_ENTRY view_mmio_input, d_str_mmio_input
	MENU_ENTRY view_palette_ram, d_str_palette_ram
	MENU_ENTRY view_rom_space, d_str_rom_space
	MENU_ENTRY view_rom_bank_space, d_str_rom_bank_space
	MENU_ENTRY view_tile_ram, d_str_tile_ram
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:	string "MEMORY VIEWER MENU"

d_str_mmio_input:	string "MMIO INPUT"
d_str_palette_ram:	string "PALETTE RAM"
d_str_rom_space:	string "ROM SPACE"
d_str_rom_bank_space:	string "ROM BANK SPACE"
d_str_tile_ram:		string "TILE RAM"
d_str_work_ram:		string "WORK RAM"
