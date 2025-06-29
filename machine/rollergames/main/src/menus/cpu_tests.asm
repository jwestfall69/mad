	include "global/include/macros.inc"
	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	include "cpu/konami2/include/dsub.inc"

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
	MENU_ENTRY bmove_test, d_str_bmove_test
	MENU_ENTRY bset_test, d_str_bset_test
	MENU_ENTRY bsetw_test, d_str_bsetw_test
	MENU_ENTRY move_test, d_str_move_test
	MENU_ENTRY opcode_idx_test, d_str_opcode_idx_test
	MENU_ENTRY opcode_inh_test, d_str_opcode_inh_test
	MENU_ENTRY opcode_imm_test, d_str_opcode_imm_test
	MENU_LIST_END

d_str_menu_title:		STRING "CPU TESTS MENU"

d_str_exgtfr_test:		STRING "EXGTFR TEST"
d_str_bmove_test:		STRING "BMOVE TEST"
d_str_bset_test:		STRING "BSET TEST"
d_str_bsetw_test:		STRING "BSETW TEST"
d_str_move_test:		STRING "MOVE TEST"
d_str_opcode_idx_test:		STRING "OPCODE IDX TEST"
d_str_opcode_inh_test:		STRING "OPCODE INH TEST"
d_str_opcode_imm_test:		STRING "OPCODE IMM TEST"

