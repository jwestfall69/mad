	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/handlers/menu.inc"

	include "machine.inc"
	include "mad.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		move.b	#0, r_menu_cursor

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		lea	d_str_menu_title, a0
		RSUB	print_string

		lea	d_menu_list, a0
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
		lea	$0, a1			; no callback
		jsr	memory_viewer_handler
		rts

	section data
	align 1

d_menu_list:
	MENU_ENTRY view_mmio, d_str_mmio
	MENU_ENTRY view_palette_ram, d_str_palette_ram
	MENU_ENTRY view_palette_ext_ram, d_str_palette_ext_ram
	MENU_ENTRY view_rom_space, d_str_rom_space
	MENU_ENTRY view_sprite_ram, d_str_sprite_ram
	MENU_ENTRY view_tile1_ram, d_str_tile1_ram
	MENU_ENTRY view_tile2_ram, d_str_tile2_ram
	MENU_ENTRY view_tile3_ram, d_str_tile3_ram
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:		STRING "MEMORY VIEWER MENU"

d_str_mmio:			STRING "MMIO"
d_str_palette_ram:		STRING "PALETTE RAM"
d_str_palette_ext_ram:		STRING "PALETTE EXT RAM"
d_str_rom_space:		STRING "ROM SPACE"
d_str_sprite_ram:		STRING "SPRITE RAM"
d_str_tile1_ram:		STRING "TILE1 RAM"
d_str_tile2_ram:		STRING "TILE2 RAM"
d_str_tile3_ram:		STRING "TILE3 RAM"
d_str_work_ram:			STRING "WORK RAM"
