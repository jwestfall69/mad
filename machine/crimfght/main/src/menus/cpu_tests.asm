	include "global/include/macros.inc"
	include "global/include/screen.inc"
	include "cpu/konami/include/dsub.inc"
	include "cpu/konami/include/macros.inc"
	include "cpu/konami/include/handlers/menu.inc"

	include "machine.inc"

	global cpu_tests_menu

	section code

cpu_tests_menu:
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
	MENU_ENTRY exgtfr_test, d_str_exgtfr_test
	MENU_LIST_END

d_str_menu_title:		STRING "CPU TESTS MENU"

d_str_exgtfr_test:		STRING "EXGTFR TEST"
