	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		ldy	#d_str_menu_title
		ldy	#d_menu_list
		jsr	menu_handler
		rts

view_k007121_sprite_ram:
		ldx	#K007121_SPRITE
		bra	view_memory

view_k007121_tile_a_ram:
		ldx	#K007121_TILE_A
		bra	view_memory

view_k007121_tile_b_ram:
		ldx	#K007121_TILE_B
		bra	view_memory

view_mmio_input:
		ldx	#$0400
		bra	view_memory

view_palette_ram:
		ldx	#PALETTE_RAM
		bra	view_memory

view_rom_space:
		ldx	#$8000
		bra	view_memory

view_rom_bank_space:
		ldx	#$4000
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
	MENU_ENTRY view_k007121_sprite_ram, d_str_k007121_sprite
	MENU_ENTRY view_k007121_tile_a_ram, d_str_k007121_tile_a
	MENU_ENTRY view_k007121_tile_b_ram, d_str_k007121_tile_b
;	reading the from 0x410? causes the screen to stop drawing
;	MENU_ENTRY view_mmio_input, d_str_mmio_input
	MENU_ENTRY view_palette_ram, d_str_palette_ram
	MENU_ENTRY view_rom_space, d_str_rom_space
	MENU_ENTRY view_rom_bank_space, d_str_rom_bank_space
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:		STRING "MEMORY VIEWER MENU"

d_str_k007121_sprite:		STRING "K007121 SPRITE"
d_str_k007121_tile_a:		STRING "K007121 TILE A"
d_str_k007121_tile_b:		STRING "K007121 TILE B"
d_str_mmio_input:		STRING "MMIO INPUT"
d_str_palette_ram:		STRING "PALETTE RAM"
d_str_rom_space:		STRING "ROM SPACE"
d_str_rom_bank_space:		STRING "ROM BANK SPACE"
d_str_work_ram:			STRING "WORK RAM"
