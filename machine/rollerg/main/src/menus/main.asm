	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami/include/dsub.inc"
	include "cpu/konami/include/macros.inc"
	include "cpu/konami/include/handlers/menu.inc"

	include "machine.inc"

	global main_menu

	section code

main_menu:
		clr	r_menu_cursor

	.loop_menu:
		RSUB	screen_init

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		ldy	#d_str_menu_title
		RSUB	print_string

		ldy	#d_menu_list
		jsr	menu_handler

		bra	.loop_menu

	section data

d_menu_list:
	MENU_ENTRY cpu_tests_menu, d_str_cpu_tests
	MENU_ENTRY input_test, d_str_input_test
	MENU_LIST_END

d_str_menu_title:		STRING "MAIN MENU"

d_str_cpu_tests:		STRING "CPU TESTS"
d_str_input_test:		STRING "INPUT TEST"
