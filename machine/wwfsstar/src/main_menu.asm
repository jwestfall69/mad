	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/main_menu_handler.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global main_menu

	section code

main_menu:
		RSUB	screen_init

		lea	MENU_LIST, a0
		lea	main_menu_get_input, a1
		moveq	#'*', d0
		moveq	#' ', d1
		jsr	main_menu_handler

		bra	main_menu

; returns:
;  d0 = 0, MENU_UP, MENU_DOWN, MENU_BUTTON
main_menu_get_input:
		move.w	#$1fff, d0
		RSUB	delay

		jsr	input_p1_update
		move.b	INPUT_P1_EDGE, d0

		; we can get away with just doing a shift
		; p1's buttons line up with the MENU_* values
		lsr.b	#2, d0
		and.b	#$7, d0
		rts

	section data


MENU_LIST:
	MAIN_MENU_ENTRY manual_work_ram_tests, STR_RAM_TEST
	MAIN_MENU_ENTRY manual_work_ram_tests, STR_TEST2
	MAIN_MENU_ENTRY manual_work_ram_tests, STR_TEST3
	MAIN_MENU_ENTRY manual_work_ram_tests, STR_TEST4
	MAIN_MENU_ENTRY input_test, STR_INPUTS
	MAIN_MENU_ENTRY_LIST_END

STR_RAM_TEST:	STRING "RAM TEST"
STR_INPUTS:	STRING "INPUT TESTS"
STR_TEST2:	STRING "TEST2"
STR_TEST3:	STRING "TEST3"
STR_TEST4:	STRING "TEST4"
