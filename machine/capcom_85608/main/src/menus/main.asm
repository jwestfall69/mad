	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global main_menu

	section code

main_menu:
		ld	ix, d_str_menu_title
		ld	iy, d_menu_list
		call	menu_handler
		jr	main_menu

	section data

d_menu_list:
	MENU_ENTRY graphics_viewer_menu, d_str_graphics_viewer, ME_FLAG_SKIP_SCREEN_INIT
	MENU_ENTRY input_test, d_str_input_test, ME_FLAG_NONE
	MENU_ENTRY memory_viewer_menu, d_str_memory_viewer, ME_FLAG_SKIP_SCREEN_INIT
	MENU_ENTRY ram_tests_menu, d_str_ram_tests, ME_FLAG_SKIP_SCREEN_INIT
	MENU_ENTRY sound_adpcm_test, d_str_sound_adpcm_test, ME_FLAG_NONE

	ifnd _ROMSET_AVENGERS_
		; The fm sound cpu latch goes through the MCU on avengers.
		; I'm not understand how to get it to work correctly.  So
		; for now disabling fm sound test on avengers.
		MENU_ENTRY sound_fm_test, d_str_sound_fm_test, ME_FLAG_NONE
	endif
	MENU_ENTRY debug_menu, d_str_debug_menu, ME_FLAG_SKIP_SCREEN_INIT
	MENU_LIST_END

d_str_menu_title:		STRING "MAIN MENU"

d_str_debug_menu:		STRING "DEBUG MENU"
d_str_graphics_viewer:		STRING "GRAPHICS VIEWER"
d_str_input_test:		STRING "INPUT TEST"
d_str_memory_viewer:		STRING "MEMORY VIEWER"
d_str_ram_tests:		STRING "RAM TESTS"
d_str_sound_fm_test:		STRING "SOUND FM TEST"
d_str_sound_adpcm_test:		STRING "SOUND ADPCM TEST"
