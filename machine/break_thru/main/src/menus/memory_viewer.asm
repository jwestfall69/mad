	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		ldx	#d_str_menu_title
		ldy	#d_menu_list
		jsr	menu_handler
		rts

view_bg_ram:
		ldx	#FG_RAM
		bra	view_memory


view_fg_ram:
		ldx	#BG_RAM
		bra	view_memory

view_mmio_input:
		ldx	#$1800
		bra	view_memory

view_rom_space:
		ldx	#$4000
		bra	view_memory

view_rom_bank_space:
		ldx	#$2000
		bra	view_memory

view_sprite_ram:
		ldx	#SPRITE_RAM
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
	MENU_ENTRY view_bg_ram, d_str_bg_ram, ME_FLAG_NONE
	MENU_ENTRY view_fg_ram, d_str_fg_ram, ME_FLAG_NONE
	MENU_ENTRY view_mmio_input, d_str_mmio_input, ME_FLAG_NONE
	MENU_ENTRY view_rom_space, d_str_rom_space, ME_FLAG_NONE
	MENU_ENTRY view_rom_bank_space, d_str_rom_bank_space, ME_FLAG_NONE
	MENU_ENTRY view_sprite_ram, d_str_sprite_ram, ME_FLAG_NONE
	MENU_ENTRY view_work_ram, d_str_work_ram, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:	STRING "MEMORY VIEWER MENU"

d_str_bg_ram:		STRING "BG RAM"
d_str_fg_ram:		STRING "FG RAM"
d_str_mmio_input:	STRING "MMIO INPUT"
d_str_rom_space:	STRING "ROM SPACE"
d_str_rom_bank_space:	STRING "ROM BANK SPACE"
d_str_sprite_ram:	STRING "SPRITE RAM"
d_str_work_ram:		STRING "WORK RAM"
