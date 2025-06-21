	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/dsub.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/handlers/menu.inc"

	include "machine.inc"

	global ram_tests_menu

	section code

ram_tests_menu:
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
	MENU_ENTRY manual_bac06_ram_tests, d_str_bac06_ram
	MENU_ENTRY manual_sprite_ram_tests, d_str_sprite_ram
	MENU_ENTRY manual_video_ram_tests, d_str_video_ram
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:		STRING "RAM TESTS"

d_str_bac06_ram:		STRING "BAC06 RAM"
d_str_palette_ram:		STRING "PALETTE RAM"
d_str_sprite_ram:		STRING "SPRITE RAM"
d_str_video_ram:		STRING "VIDEO RAM"
d_str_work_ram:			STRING "WORK RAM"
