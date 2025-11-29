	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/menu.inc"

	global ram_tests_menu

	section code

ram_tests_menu:
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
	MENU_ENTRY manual_bg_ram_tests, d_str_bg_ram_test
	MENU_ENTRY manual_fg_ram_tests, d_str_fg_ram_test
	MENU_ENTRY manual_sprite_ram_tests, d_str_sprite_ram_test
	MENU_ENTRY manual_txt_ram_tests, d_str_txt_ram_test
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram_test
	MENU_LIST_END

d_str_menu_title:		STRING "RAM TESTS"

d_str_bg_ram_test:		STRING "BG RAM TEST"
d_str_fg_ram_test:		STRING "FG RAM TEST"
d_str_sprite_ram_test:		STRING "SPRITE RAM TEST"
d_str_txt_ram_test:		STRING "TXT RAM TEST"
d_str_work_ram_test:		STRING "WORK RAM TEST"
