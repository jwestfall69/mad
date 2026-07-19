	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global debug_hardware_menu

	section code

debug_hardware_menu:
		ldx	#d_str_menu_title
		ldy	#d_menu_list
		jsr	menu_handler
		rts

; fills entire fg with the letter E
screen_size_debug:
		ldx	#FG_TILE_RAM
		ldy	#FG_TILE_RAM_SIZE / 2
		ldd	#$e
		DSUB	memory_fill_word

		lda	#INPUT_B2
		jsr	wait_button_press

		rts


ram_find_bg_tile:
		ldx	#BG_TILE_RAM
		jmp	ram_find

ram_find_fg_tile:
		ldx	#FG_TILE_RAM
		jmp	ram_find

ram_find_palette_even:
		ldx	#PALETTE_RAM
		jmp	ram_find

ram_find_palette_odd:
		ldx	#PALETTE_RAM + 1
		jmp	ram_find

ram_find_sprite:
		ldx	#SPRITE_RAM
		jmp	ram_find

ram_find_work:
		ldx	#r_work_ram
		jmp	ram_find

	section data

d_menu_list:
	MENU_ENTRY screen_size_debug, d_str_screen_size_debug, ME_FLAG_NONE
	MENU_ENTRY sprite_debug, d_str_sprite_debug, ME_FLAG_NONE
	MENU_ENTRY ram_find_none, d_str_ram_find_none, ME_FLAG_NONE
	MENU_ENTRY ram_find_bg_tile, d_str_ram_find_bg_tile, ME_FLAG_NONE
	MENU_ENTRY ram_find_fg_tile, d_str_ram_find_fg_tile, ME_FLAG_NONE
	MENU_ENTRY ram_find_palette_even, d_str_ram_find_palette_even, ME_FLAG_NONE
	MENU_ENTRY ram_find_palette_odd, d_str_ram_find_palette_odd, ME_FLAG_NONE
	MENU_ENTRY ram_find_sprite, d_str_ram_find_sprite, ME_FLAG_NONE
	MENU_ENTRY ram_find_work, d_str_ram_find_work, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "DEBUG HARDWARE MENU"

d_str_screen_size_debug:	STRING "SCREEN SIZE DEBUG"
d_str_sprite_debug:		STRING "SPRITE DEBUG"

d_str_ram_find_bg_tile:		STRING "RAM FIND BG TILE"
d_str_ram_find_fg_tile:		STRING "RAM FIND FG TILE"
d_str_ram_find_none:		STRING "RAM FIND NONE"
d_str_ram_find_palette_even:	STRING "RAM FIND PALETTE EVEN"
d_str_ram_find_palette_odd:	STRING "RAM FIND PALETTE ODD"
d_str_ram_find_sprite:		STRING "RAM FIND SPRITE"
d_str_ram_find_work:		STRING "RAM FIND WORK"

	section bss

r_work_ram:	dcb.b 1
