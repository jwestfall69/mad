	include "global/include/macros.inc"
	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	include "cpu/6309/include/dsub.inc"

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

view_bac06_ram:
		ldx	#BAC06_RAM
		bra	view_memory

view_mmio_input:
		ldx	#$3800
		bra	view_memory

view_rom_space:
		ldx	#$8000
		bra	view_memory

view_rom_bank_space:
		ldx	#$4000
		bra	view_memory

view_sprite_ram:
		ldx	#SPRITE_RAM
		bra	view_memory

view_video_ram:
		ldx	#VIDEO_RAM
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
	MENU_ENTRY view_bac06_ram, d_str_bac06_ram
	MENU_ENTRY view_mmio_input, d_str_mmio_input
	MENU_ENTRY view_rom_space, d_str_rom_space
	MENU_ENTRY view_rom_bank_space, d_str_rom_bank_space
	MENU_ENTRY view_sprite_ram, d_str_sprite_ram
	MENU_ENTRY view_video_ram, d_str_video_ram
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:	STRING "MEMORY VIEWER MENU"

d_str_bac06_ram:	STRING "BAC06 RAM"
d_str_mmio_input:	STRING "MMIO INPUT"
d_str_rom_space:	STRING "ROM SPACE"
d_str_rom_bank_space:	STRING "ROM BANK SPACE"
d_str_sprite_ram:	STRING "SPRITE RAM"
d_str_video_ram:	STRING "VIDEO RAM"
d_str_work_ram:		STRING "WORK RAM"
