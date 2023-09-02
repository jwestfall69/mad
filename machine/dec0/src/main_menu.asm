	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/main_menu_handler.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global main_menu
	global main_menu_get_input

	section code

main_menu:
		RSUB	screen_init

		lea	MAIN_MENU_LIST, a0
		lea	main_menu_get_input, a1
		moveq	#'*', d0
		moveq	#0, d1
		jsr	main_menu_handler

		bra	main_menu

; returns:
;  d0 = 0, MAIN_MENU_UP, MAIN_MENU_DOWN, MAIN_MENU_BUTTON
main_menu_get_input:
		move.w	#$1fff, d0
		RSUB	delay

		jsr	input_p1_update

		moveq	#0, d0
		move.b	INPUT_P1_EDGE, d0

		; up/down already line up, so just need to check b2
		btst	#P1_B1_BIT, INPUT_P1_EDGE
		beq	.b1_not_pressed
		or.b	#4, d0
		and.b	#$7, d0
		rts

	.b1_not_pressed:
		and.w	#$3, d0
		rts


MAIN_MENU_LIST:
	MAIN_MENU_ENTRY manual_work_ram_tests, STR_RAM_TEST
	MAIN_MENU_ENTRY manual_work_ram_tests, STR_TEST2
	MAIN_MENU_ENTRY manual_work_ram_tests, STR_TEST3
	MAIN_MENU_ENTRY input_test, STR_INPUT_TEST
	MAIN_MENU_ENTRY_LIST_END

STR_RAM_TEST:		STRING "RAM TEST"
STR_TEST2:		STRING "TEST2"
STR_TEST3:		STRING "TEST3"
STR_INPUT_TEST:		STRING "INPUT TEST"
