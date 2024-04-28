	; global includes
	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"

	; machine incldues
	include "diag_rom.inc"
	include "machine.inc"

	global _start
	global STR_PASSES

	section code

_start:


		PSUB_INIT

		PSUB	screen_init
		PSUB	auto_dsub_tests

		RSUB_INIT

		clr.b	INPUT_P1_EDGE
		clr.b	INPUT_P1_RAW
		clr.b	INPUT_SYSTEM_EDGE
		clr.b	INPUT_SYSTEM_RAW
		clr.b	MAIN_MENU_CURSOR

		bsr	auto_func_tests

		bsr	main_menu


	section data

STR_PASSES:	STRING "PASSES"

