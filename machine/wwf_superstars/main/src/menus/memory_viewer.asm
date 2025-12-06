	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		lea	d_str_menu_title, a0
		lea	d_menu_list, a1
		jsr	menu_handler
		rts

view_bg_ram:
		lea	BG_RAM, a0
		bra	view_memory

view_fg_ram:
		lea	FG_RAM, a0
		bra	view_memory

view_mmio:
		lea	$180000, a0
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
	MENU_ENTRY view_bg_ram, d_str_bg_ram
	MENU_ENTRY view_fg_ram, d_str_fg_ram
	MENU_ENTRY view_mmio, d_str_mmio
	MENU_ENTRY view_palette_ram, d_str_palette_ram
	MENU_ENTRY view_rom_space, d_str_rom_space
	MENU_ENTRY view_sprite_ram, d_str_sprite_ram
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:		STRING "MEMORY VIEWER MENU"

d_str_bg_ram:			STRING "BG RAM"
d_str_fg_ram:			STRING "FG RAM"
d_str_mmio:			STRING "MMIO"
d_str_palette_ram:		STRING "PALETTE RAM"
d_str_rom_space:		STRING "ROM SPACE"
d_str_sprite_ram:		STRING "SPRITE RAM"
d_str_work_ram:			STRING "WORK RAM"
