	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/6309/include/macros.inc"
	include "cpu/6309/include/psub.inc"
	include "cpu/6309/include/xy_string.inc"
	include "cpu/6309/include/handlers/menu.inc"

	include "input.inc"
	include "machine.inc"

	global ram_tests_menu

	section code

ram_tests_menu:
		clr	r_menu_cursor

	.loop_menu:
		PSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_menu_title
		PSUB	print_string

		ldy	#d_menu_list
		jsr	menu_handler

		cmpa	#MENU_CONTINUE
		beq	.loop_menu
		rts

	section data

d_menu_list:
	MENU_ENTRY manual_k007121_10e_ram_tests, d_str_k007121_10e_ram
	MENU_ENTRY manual_k007121_18e_ram_tests, d_str_k007121_18e_ram
	MENU_ENTRY manual_palette_ram_tests, d_str_palette_ram
	MENU_ENTRY manual_work_ram_tests, d_str_work_ram
	MENU_LIST_END

d_str_menu_title:		STRING "RAM TESTS"

d_str_k007121_10e_ram:		STRING "K007121 10E RAM"
d_str_k007121_18e_ram:		STRING "K007121 18E RAM"
d_str_palette_ram:		STRING "PALETTE RAM"
d_str_work_ram:			STRING "WORK RAM"
