	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global video_tests_menu

	section code

video_tests_menu:
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

	section data
	align 1

d_menu_list:
;	MENU_ENTRY tile_scroll_test, d_str_tile_scroll
	MENU_ENTRY video_dac_test, d_str_video_dac
	MENU_LIST_END

d_str_menu_title:		STRING "VIDEO TESTS"

d_str_tile_scroll:		STRING "TILE SCROLL"
d_str_video_dac:		STRING "VIDEO DAC"
