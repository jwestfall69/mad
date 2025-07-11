	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global video_tests_menu

	section code

video_tests_menu:
		clr	r_menu_cursor

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_menu_title
		RSUB	print_string

		ldy	#d_menu_list
		jsr	menu_handler

		cmpa	#MENU_CONTINUE
		beq	.loop_menu
		rts

	section data

d_menu_list:
	MENU_ENTRY bac06_tile_scroll_test, d_str_bac06_tile_scroll
;	MENU_ENTRY video_dac_test, d_str_video_dac
	MENU_LIST_END

d_str_menu_title:		STRING "VIDEO TESTS"

d_str_bac06_tile_scroll:	STRING "BAC06 TILE SCROLL"
;d_str_video_dac:		STRING "VIDEO DAC"
