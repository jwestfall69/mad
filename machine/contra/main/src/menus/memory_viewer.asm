	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/handlers/menu.inc"

	include "machine.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		clr	r_menu_cursor

	.loop_menu:
		PSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_menu_title
		PSUB	print_string

		ldy	#d_menu_list
		jsr	menu_handler

		cmpa	#MENU_CONTINUE
		beq	.loop_menu
		rts

view_mmio_input:
		ldy	#$0000
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

view_sprite1_ram:
		ldy	#SPRITE1_RAM_START
		bra	view_memory

view_sprite2_ram:
		ldy	#SPRITE2_RAM_START
		bra	view_memory

view_tile1_ram:
		ldy	#TILE1_RAM_START
		bra	view_memory

view_tile2_ram:
		ldy	#TILE2_RAM_START
		bra	view_memory

view_tile3_ram:
		ldy	#TILE3_RAM_START
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
	MENU_ENTRY view_sprite1_ram, d_str_sprite1_ram
	MENU_ENTRY view_sprite2_ram, d_str_sprite2_ram
	MENU_ENTRY view_tile1_ram, d_str_tile1_ram
	MENU_ENTRY view_tile2_ram, d_str_tile2_ram
	MENU_ENTRY view_tile3_ram, d_str_tile3_ram
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:	STRING "MEMORY VIEWER MENU"

d_str_mmio_input:	STRING "MMIO INPUT"
d_str_palette_ram:	STRING "PALETTE RAM"
d_str_rom_space:	STRING "ROM SPACE"
d_str_rom_bank_space:	STRING "ROM BANK SPACE"
d_str_sprite1_ram:	STRING "SPRITE1 RAM"
d_str_sprite2_ram:	STRING "SPRITE2 RAM"
d_str_tile1_ram:	STRING "TILE1 RAM"
d_str_tile2_ram:	STRING "TILE2 RAM"
d_str_tile3_ram:	STRING "TILE3 RAM"
d_str_work_ram:		STRING "WORK RAM"
