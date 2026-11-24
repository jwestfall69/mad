	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global debug_hardware_menu

	section code

debug_hardware_menu:
		lea	d_str_menu_title, a0
		lea	d_menu_list, a1
		jsr	menu_handler
		rts

ram_find_palette_low:
		lea	PALETTE_BASE + PALETTE_ENTRY_SIZE, a0
		jmp	ram_find

ram_find_palette_high:
		lea	PALETTE_BASE + PALETTE_ENTRY_SIZE + 1, a0
		jmp	ram_find

ram_find_sprite_byte_1:
		lea	SPRITE_BASE + 1, a0
		jmp	ram_find

ram_find_sprite_byte_2:
		lea	SPRITE_BASE + 2, a0
		jmp	ram_find

ram_find_sprite_byte_3:
		lea	SPRITE_BASE + 3, a0
		jmp	ram_find

ram_find_tile_low:
		lea	TILE_BASE, a0
		jmp	ram_find

ram_find_tile_high:
		lea	TILE_BASE + 1, a0
		jmp	ram_find

ram_find_work_low:
		lea	r_work_ram, a0
		jmp	ram_find

ram_find_work_high:
		lea	r_work_ram + 1, a0
		jmp	ram_find

	section data
	align 1

d_menu_list:
	MENU_ENTRY sprite_debug, d_str_sprite_debug, ME_FLAG_NONE
	MENU_ENTRY watchdog_time, d_str_watchdog_time, ME_FLAG_NONE
	MENU_ENTRY ram_find_none, d_str_ram_find_none, ME_FLAG_NONE
	MENU_ENTRY ram_find_palette_high, d_str_ram_find_palette_high, ME_FLAG_NONE
	MENU_ENTRY ram_find_palette_low, d_str_ram_find_palette_low, ME_FLAG_NONE
	MENU_ENTRY ram_find_sprite_byte_1, d_str_ram_find_sprite_byte_1, ME_FLAG_NONE
	MENU_ENTRY ram_find_sprite_byte_2, d_str_ram_find_sprite_byte_2, ME_FLAG_NONE
	MENU_ENTRY ram_find_sprite_byte_3, d_str_ram_find_sprite_byte_3, ME_FLAG_NONE
	MENU_ENTRY ram_find_tile_high, d_str_ram_find_tile_high, ME_FLAG_NONE
	MENU_ENTRY ram_find_tile_low, d_str_ram_find_tile_low, ME_FLAG_NONE
	MENU_ENTRY ram_find_work_high, d_str_ram_find_work_high, ME_FLAG_NONE
	MENU_ENTRY ram_find_work_low, d_str_ram_find_work_low, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG HARDWARE MENU"

d_str_sprite_debug:		STRING "SPRITE DEBUG"
d_str_watchdog_time:		STRING "WATCHDOG TIME"

d_str_ram_find_none:		STRING "RAM FIND NONE"
d_str_ram_find_palette_high:	STRING "RAM FIND PALETTE HIGH"
d_str_ram_find_palette_low:	STRING "RAM FIND PALETTE LOW"
d_str_ram_find_sprite_byte_1:	STRING "RAM FIND SPRITE BYTE 1"
d_str_ram_find_sprite_byte_2:	STRING "RAM FIND SPRITE BYTE 2"
d_str_ram_find_sprite_byte_3:	STRING "RAM FIND SPRITE BYTE 3"
d_str_ram_find_tile_high:	STRING "RAM FIND TILE HIGH"
d_str_ram_find_tile_low:	STRING "RAM FIND TILE LOW"
d_str_ram_find_work_high:	STRING "RAM FIND WORK HIGH"
d_str_ram_find_work_low:	STRING "RAM FIND WORK LOW"


	section bss

r_work_ram:	dcb.b	2
