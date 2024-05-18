	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/handlers/menu.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global memory_viewer_menu

	section code

memory_viewer_menu:
		move.b	#0, MENU_CURSOR

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	3, 3
		lea	STR_MENU_TITLE, a0
		RSUB	print_string

		lea	MENU_LIST, a0
		lea	menu_input_generic, a1
		jsr	menu_handler

		cmp.b	#MENU_CONTINUE, d0
		beq	.loop_menu

		rts

; Just note that the specific address for a number of the
; graphics locations don't really have any meaning since
; we are telling the cps-a chip to point at those locations
; for them.
view_gfx_ram:
		lea	GFX_RAM_START, a0
		bra	view_memory

view_cps_a_reg:
		lea	$800100, a0
		bra	view_memory

view_cps_b_reg:
		lea	$800140, a0
		bra	view_memory

view_mmio:
		lea	$800000, a0
		bra	view_memory

view_object_ram:
		lea	OBJECT_RAM_START, a0
		bra	view_memory

view_palette_ram:
		lea	PALETTE_RAM_START, a0
		bra	view_memory

view_rom_space:
		lea	$0, a0
		bra	view_memory

view_row_scroll_ram:
		lea	ROW_SCROLL_RAM_START, a0
		bra	view_memory

view_scroll1_ram:
		lea	SCROLL1_RAM_START, a0
		bra	view_memory

view_scroll2_ram:
		lea	SCROLL2_RAM_START, a0
		bra	view_memory

view_scroll3_ram:
		lea	SCROLL3_RAM_START, a0
		bra	view_memory

view_work_ram:
		lea	WORK_RAM_START, a0

view_memory:
		lea	menu_input_generic, a1
		jsr	memory_viewer_handler
		rts


	section data

STR_MENU_TITLE:		STRING "MEMORY VIEWER MENU"

	align 2

MENU_LIST:
	MENU_ENTRY view_gfx_ram, STR_GFX_RAM
	MENU_ENTRY view_cps_a_reg, STR_CPS_A_REG
	MENU_ENTRY view_cps_b_reg, STR_CPS_B_REG
	MENU_ENTRY view_mmio, STR_MMIO
	MENU_ENTRY view_object_ram, STR_OBJECT_RAM
	MENU_ENTRY view_palette_ram, STR_PALETTE_RAM
	MENU_ENTRY view_rom_space, STR_ROM_SPACE
	MENU_ENTRY view_row_scroll_ram, STR_ROW_SCROLL_RAM
	MENU_ENTRY view_scroll1_ram, STR_SCROLL1_RAM
	MENU_ENTRY view_scroll2_ram, STR_SCROLL2_RAM
	MENU_ENTRY view_scroll3_ram, STR_SCROLL3_RAM
	MENU_ENTRY view_work_ram, STR_WORK_RAM
	MENU_LIST_END


STR_GFX_RAM:		STRING "GFX RAM"
STR_CPS_A_REG:		STRING "CPS A REG"
STR_CPS_B_REG:		STRING "CPS B REG"
STR_MMIO:		STRING "MMIO"
STR_OBJECT_RAM:		STRING "OBJECT RAM"
STR_PALETTE_RAM:	STRING "PALETTE RAM"
STR_ROM_SPACE:		STRING "ROM SPACE"
STR_ROW_SCROLL_RAM:	STRING "ROW SCROLL RAM"
STR_SCROLL1_RAM:	STRING "SCROLL1 RAM"
STR_SCROLL2_RAM:	STRING "SCROLL2 RAM"
STR_SCROLL3_RAM:	STRING "SCROLL3 RAM"
STR_WORK_RAM:		STRING "WORK RAM"

