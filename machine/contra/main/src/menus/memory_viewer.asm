	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/handlers/menu.inc"

	include "machine.inc"

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

view_k007121_10e_sprite_ram:
		ldx	#K007121_10E_SPRITE
		bra	view_memory

view_k007121_10e_tile_a_ram:
		ldx	#K007121_10E_TILE_A
		bra	view_memory

view_k007121_10e_tile_b_ram:
		ldx	#K007121_10E_TILE_B
		bra	view_memory

view_k007121_18e_sprite_ram:
		ldx	#K007121_18E_SPRITE
		bra	view_memory

view_k007121_18e_tile_a_ram:
		ldx	#K007121_18E_TILE_A
		bra	view_memory

view_k007121_18e_tile_b_ram:
		ldx	#K007121_18E_TILE_B
		bra	view_memory

view_mmio_input:
		ldx	#$0000
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

view_work_ram:
		ldx	#WORK_RAM
		bra	view_memory

view_memory:
		ldy	#$0			; no callback
		jsr	memory_viewer_handler
		rts

	section data

d_menu_list:
	MENU_ENTRY view_k007121_10e_sprite_ram, d_str_k007121_10e_sprite
	MENU_ENTRY view_k007121_10e_tile_a_ram, d_str_k007121_10e_tile_a
	MENU_ENTRY view_k007121_10e_tile_b_ram, d_str_k007121_10e_tile_b
	MENU_ENTRY view_k007121_18e_sprite_ram, d_str_k007121_18e_sprite
	MENU_ENTRY view_k007121_18e_tile_a_ram, d_str_k007121_18e_tile_a
	MENU_ENTRY view_k007121_18e_tile_b_ram, d_str_k007121_18e_tile_b
	MENU_ENTRY view_mmio_input, d_str_mmio_input
	MENU_ENTRY view_palette_ram, d_str_palette_ram
	MENU_ENTRY view_rom_space, d_str_rom_space
	MENU_ENTRY view_rom_bank_space, d_str_rom_bank_space
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:		STRING "MEMORY VIEWER MENU"

d_str_k007121_10e_sprite:	STRING "K007121 10E SPRITE"
d_str_k007121_10e_tile_a:	STRING "K007121 10E TILE A"
d_str_k007121_10e_tile_b:	STRING "K007121 10E TILE B"
d_str_k007121_18e_sprite:	STRING "K007121 18E SPRITE"
d_str_k007121_18e_tile_a:	STRING "K007121 18E TILE A"
d_str_k007121_18e_tile_b:	STRING "K007121 18E TILE B"
d_str_mmio_input:		STRING "MMIO INPUT"
d_str_palette_ram:		STRING "PALETTE RAM"
d_str_rom_space:		STRING "ROM SPACE"
d_str_rom_bank_space:		STRING "ROM BANK SPACE"
d_str_work_ram:			STRING "WORK RAM"
