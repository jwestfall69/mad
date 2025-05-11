	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/handlers/menu.inc"

	include "mad.inc"
	include "machine.inc"

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

view_bg1_ram:
		lea	BG_RAM, a0
		bra	view_memory

view_bg2_ram:
		lea	BG2_RAM, a0
		bra	view_memory

view_fg_ram:
		lea	FG_RAM, a0
		bra	view_memory

view_mmio_input:
		lea	$140020, a0
		bra	view_memory

view_palette_ram:
		lea	PALETTE_RAM, a0
		bra	view_memory

view_rom_space:
		lea	$0, a0
		bra	view_memory

view_sprite_ram:
		lea	SPRITE_RAM, a0
		bra	view_memory

view_work_ram:
		lea	WORK_RAM, a0

view_memory:
		lea	$0, a1			; no callback
		jsr	memory_viewer_handler
		rts

	section data
	align 1

d_menu_list:
	MENU_ENTRY view_bg1_ram, d_str_bg1_ram
	MENU_ENTRY view_bg2_ram, d_str_bg2_ram
	MENU_ENTRY view_fg_ram, d_str_fg_ram
	MENU_ENTRY view_mmio_input, d_str_mmio_input
	MENU_ENTRY view_palette_ram, d_str_palette_ram
	MENU_ENTRY view_rom_space, d_str_rom_space
	MENU_ENTRY view_sprite_ram, d_str_sprite_ram
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:		STRING "MEMORY VIEWER MENU"

d_str_bg1_ram:			STRING "BG1 RAM"
d_str_bg2_ram:			STRING "BG2 RAM"
d_str_fg_ram:			STRING "FG RAM"
d_str_mmio_input:		STRING "MMIO INPUT"
d_str_palette_ram:		STRING "PALETTE RAM"
d_str_rom_space:		STRING "ROM SPACE"
d_str_sprite_ram:		STRING "SPRITE RAM"
d_str_work_ram:			STRING "WORK RAM"

