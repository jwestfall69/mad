	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global main_menu

	section code

main_menu:
		ldx	#d_str_menu_title
		ldy	#d_menu_list
		jsr	menu_handler
		bra	main_menu
		rts

	section data

d_menu_list:
	MENU_ENTRY graphics_viewer_menu, d_str_graphics_viewer, ME_FLAG_SKIP_SCREEN_INIT
	MENU_ENTRY ram_test, d_str_ram_test, ME_FLAG_SKIP_SCREEN_INIT
	MENU_ENTRY input_test, d_str_input_test, ME_FLAG_NONE
	MENU_ENTRY memory_viewer_menu, d_str_memory_viewer, ME_FLAG_SKIP_SCREEN_INIT
	MENU_ENTRY sound_m58715_test, d_str_sound_m58715_test, ME_FLAG_NONE
	MENU_ENTRY sound_sn76489a_test, d_str_sound_sn76489a_test, ME_FLAG_NONE
	MENU_ENTRY tile_scroll_test, d_str_tile_scroll_test, ME_FLAG_NONE
	MENU_ENTRY debug_menu, d_str_debug_menu, ME_FLAG_SKIP_SCREEN_INIT
	MENU_LIST_END

d_str_menu_title:		STRING "MAIN MENU"

d_str_debug_menu:		STRING "DEBUG MENU"
d_str_graphics_viewer:		STRING "GRAPHICS VIEWER"
d_str_input_test:		STRING "INPUT TEST"
d_str_memory_viewer:		STRING "MEMORY VIEWER"
d_str_ram_test:			STRING "RAM TEST"
d_str_sound_m58715_test:	STRING "SOUND M58715 TEST"
d_str_sound_sn76489a_test:	STRING "SOUND SN76489A TEST"
d_str_tile_scroll_test:		STRING "TILE SCROLL TEST"
