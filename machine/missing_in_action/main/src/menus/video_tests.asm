	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global video_tests_menu

	section code

video_tests_menu:
		lea	d_str_menu_title, a0
		lea	d_menu_list, a1
		jsr	menu_handler
		rts

	section data
	align 1

d_menu_list:
	MENU_ENTRY tile_scroll_test, d_str_tile_scroll, ME_FLAG_NONE
	MENU_ENTRY video_dac_test, d_str_video_dac, ME_FLAG_SKIP_SCREEN_INIT
	MENU_LIST_END

d_str_menu_title:		STRING "VIDEO TESTS"

d_str_tile_scroll:		STRING "TILE SCROLL"
d_str_video_dac:		STRING "VIDEO DAC"
