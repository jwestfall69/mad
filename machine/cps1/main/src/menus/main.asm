	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global main_menu

	section code

main_menu:
		lea	d_str_menu_title, a0
		lea	d_menu_list, a1
		jsr	menu_handler
		bra	main_menu

	section data
	align 1

d_menu_list:
	MENU_ENTRY manual_gfx_ram_tests, d_str_gfx_ram_test, ME_FLAG_NONE
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram_test, ME_FLAG_NONE
	MENU_ENTRY input_test, d_str_input_test, ME_FLAG_NONE
	MENU_ENTRY memory_viewer_menu, d_str_memory_viewer, ME_FLAG_SKIP_SCREEN_INIT
	MENU_ENTRY sound_test, d_str_sound_test, ME_FLAG_NONE
	MENU_ENTRY video_dac_test, d_str_video_dac_test, ME_FLAG_SKIP_SCREEN_INIT
	MENU_ENTRY debug_menu, d_str_debug_menu, ME_FLAG_SKIP_SCREEN_INIT
	MENU_LIST_END

d_str_menu_title:		STRING "MAIN MENU"

d_str_debug_menu:		STRING "DEBUG MENU"
d_str_gfx_ram_test:		STRING "GFX RAM TEST"
d_str_input_test:		STRING "INPUT TEST"
d_str_memory_viewer:		STRING "MEMORY VIEWER"
d_str_sound_test:		STRING "SOUND TEST"
d_str_video_dac_test:		STRING "VIDEO DAC TEST"
d_str_work_ram_test:		STRING "WORK RAM TEST"
