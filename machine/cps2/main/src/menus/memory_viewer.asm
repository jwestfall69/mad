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

; Just note that the specific address for a number of the
; graphics locations don't really have any meaning since
; we are telling the cps-a chip to point at those locations
; for them.
view_gfx_ram:
		lea	GFX_RAM_START, a0
		bra	view_memory

view_cps_a_reg:
		lea	REGA_BASE, a0
		bra	view_memory

view_cps_b_reg:
		lea	REGB_BASE, a0
		bra	view_memory

view_mmio:
		lea	$804000, a0
		bra	view_memory

view_object_ram:
		lea	OBJECT_RAM_START, a0
		bra	view_memory

view_palette_ram:
		lea	PALETTE_RAM_START, a0
		bra	view_memory

view_qsound_ram:
		lea	QSOUND_RAM_START, a0
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
		lea	$0, a1			; no callback
		jsr	memory_viewer_handler
		rts


	section data
	align 1

d_menu_list:
	MENU_ENTRY view_cps_a_reg, d_str_cps_a_reg
	MENU_ENTRY view_cps_b_reg, d_str_cps_b_reg
	MENU_ENTRY view_gfx_ram, d_str_gfx_ram
	MENU_ENTRY view_mmio, d_str_mmio
	MENU_ENTRY view_object_ram, d_str_object_ram
	MENU_ENTRY view_palette_ram, d_str_palette_ram
	MENU_ENTRY view_qsound_ram, d_str_qsound_ram
	MENU_ENTRY view_rom_space, d_str_rom_space
	MENU_ENTRY view_row_scroll_ram, d_str_row_scroll_ram
	MENU_ENTRY view_scroll1_ram, d_str_scroll1_ram
	MENU_ENTRY view_scroll2_ram, d_str_scroll2_ram
	MENU_ENTRY view_scroll3_ram, d_str_scroll3_ram
	MENU_ENTRY view_work_ram, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:	STRING "MEMORY VIEWER MENU"

d_str_cps_a_reg:	STRING "CPS A REG"
d_str_cps_b_reg:	STRING "CPS B REG"
d_str_gfx_ram:		STRING "GFX RAM"
d_str_mmio:		STRING "MMIO"
d_str_object_ram:	STRING "OBJECT RAM"
d_str_palette_ram:	STRING "PALETTE RAM"
d_str_qsound_ram:	STRING "QSOUND RAM"
d_str_rom_space:	STRING "ROM SPACE"
d_str_row_scroll_ram:	STRING "ROW SCROLL RAM"
d_str_scroll1_ram:	STRING "SCROLL1 RAM"
d_str_scroll2_ram:	STRING "SCROLL2 RAM"
d_str_scroll3_ram:	STRING "SCROLL3 RAM"
d_str_work_ram:		STRING "WORK RAM"

