	include "cpu/konami2/include/common.inc"
	include "cpu/6x09/include/handlers/menu.inc"

	global cpu_tests_menu

	section code

cpu_tests_menu:
		ldx	#d_str_menu_title
		ldy	#d_menu_list
		jsr	menu_handler
		rts

	section data

d_menu_list:
	MENU_ENTRY exgtfr_test, d_str_exgtfr_test, ME_FLAG_NONE
	MENU_ENTRY bmove_test, d_str_bmove_test, ME_FLAG_NONE
	MENU_ENTRY move_test, d_str_move_test, ME_FLAG_NONE
	MENU_ENTRY opcode_idx_test, d_str_opcode_idx_test, ME_FLAG_NONE
	MENU_ENTRY opcode_inh_test, d_str_opcode_inh_test, ME_FLAG_NONE
	MENU_ENTRY opcode_imm_test, d_str_opcode_imm_test, ME_FLAG_NONE
	MENU_LIST_END

d_str_menu_title:		STRING "CPU TESTS MENU"

d_str_exgtfr_test:		STRING "EXGTFR TEST"
d_str_bmove_test:		STRING "BMOVE TEST"
d_str_move_test:		STRING "MOVE TEST"
d_str_opcode_idx_test:		STRING "OPCODE IDX TEST"
d_str_opcode_inh_test:		STRING "OPCODE INH TEST"
d_str_opcode_imm_test:		STRING "OPCODE IMM TEST"

