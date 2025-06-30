	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		clr	r_menu_cursor

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_menu_title
		RSUB	print_string

		ldy	#d_menu_list
		jsr	menu_handler

		cmpa	#MENU_CONTINUE
		beq	.loop_menu
		rts

view_mmio_input:
		ldx	#$2e00
		bra	view_memory

view_palette_ram:
		ldx	#PALETTE_RAM
		bra	view_memory

view_rom_space:
		ldx	#$8000
		bra	view_memory

view_rom_bank_space:
		ldx	#$6000
		bra	view_memory

view_sprite_ram:
		ldx	#SPRITE_RAM
		bra	view_memory

view_tile_ram:
		ldx	#TILE_RAM
		bra	view_memory

view_work_ram:
		ldx	#WORK_RAM
		bra	view_memory

view_memory:
		ldy	#$0			; no callback
		jsr	memory_viewer_handler
		rts

	section data

d_menu_list:
	MENU_ENTRY view_mmio_input, d_str_mmio_input
	MENU_ENTRY view_palette_ram, d_str_palette_ram
	MENU_ENTRY view_rom_space, d_str_rom_space
	MENU_ENTRY view_rom_bank_space, d_str_rom_bank_space
	MENU_ENTRY view_sprite_ram, d_str_sprite_ram
	MENU_ENTRY view_tile_ram, d_str_tile_ram
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:	STRING "MEMORY VIEWER MENU"

d_str_mmio_input:	STRING "MMIO INPUT"
d_str_palette_ram:	STRING "PALETTE RAM"
d_str_rom_space:	STRING "ROM SPACE"
d_str_rom_bank_space:	STRING "ROM BANK SPACE"
d_str_sprite_ram:	STRING "SPRITE RAM"
d_str_tile_ram:		STRING "TILE RAM"
d_str_work_ram:		STRING "WORK RAM"
