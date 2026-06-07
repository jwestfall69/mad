	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/menu.inc"

	global video_tests_menu

	section code

video_tests_menu:
		ld	ix, d_str_menu_title
		ld	iy, d_menu_list
		call	menu_handler
		ret

	section data

d_menu_list:
	MENU_ENTRY bg_tile_scroll_test, d_str_bg_tile_scroll, ME_FLAG_NONE
;	MENU_ENTRY video_dac_test, d_str_video_dac, ME_FLAG_SKIP_SCREEN_INIT
	MENU_LIST_END

d_str_menu_title:		STRING "VIDEO TESTS"

d_str_bg_tile_scroll:		STRING "BG TILE SCROLL"
;d_str_video_dac:		STRING "VIDEO DAC"
