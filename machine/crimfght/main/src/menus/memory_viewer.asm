	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami/include/dsub.inc"
	include "cpu/konami/include/macros.inc"
	include "cpu/konami/include/handlers/menu.inc"

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

view_mmio_input:
		ldx	#$3f80
		bra	view_memory

view_palette_ram:
		ldx	#PALETTE_RAM_START
		ldy	#cb_read_memory_palette
		bra	view_memory_cb

view_rom_space:
		ldx	#$8000
		bra	view_memory

view_rom_bank_space:
		ldx	#$6000
		bra	view_memory

view_sprite_ram:
		ldx	#SPRITE_RAM_START
		bra	view_memory

view_tile1_ram:
		ldx	#TILE1_RAM_START
		bra	view_memory

view_tile2_ram:
		ldx	#TILE2_RAM_START
		bra	view_memory

view_work_ram:
		ldx	#WORK_RAM_START
		bra	view_memory

view_memory:
		ldy	#$0			; no callback
view_memory_cb:
		jsr	memory_viewer_handler
		rts


; palette and work ram share some of the same address
; space and you have to bank switch them in/out as
; ended.  So when wanting to read palette ram we need
; to bank switch it in, read, then unbank.
; params:
;  x = address to read from
;  y = address to write long to
cb_read_memory_palette:
		; bank switch palette ram in/out
		setln	#$a0
		ldd	, x
		std	, y
		ldd	2, x
		std	2, y
		setln	#$80
		rts

	section data

d_menu_list:
	MENU_ENTRY view_mmio_input, d_str_mmio_input
	MENU_ENTRY view_palette_ram, d_str_palette_ram
	MENU_ENTRY view_rom_space, d_str_rom_space
	MENU_ENTRY view_rom_bank_space, d_str_rom_bank_space
	MENU_ENTRY view_sprite_ram, d_str_sprite_ram
	MENU_ENTRY view_tile1_ram, d_str_tile1_ram
	MENU_ENTRY view_tile2_ram, d_str_tile2_ram
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:	STRING "MEMORY VIEWER MENU"

d_str_mmio_input:	STRING "MMIO INPUT"
d_str_palette_ram:	STRING "PALETTE RAM"
d_str_rom_space:	STRING "ROM SPACE"
d_str_rom_bank_space:	STRING "ROM BANK SPACE"
d_str_sprite_ram:	STRING "SPRITE RAM"
d_str_tile1_ram:	STRING "TILE1 RAM"
d_str_tile2_ram:	STRING "TILE2 RAM"
d_str_work_ram:		STRING "WORK RAM"
