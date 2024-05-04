	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global _start
	global	STR_PASSES

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
		clr.b	MENU_CURSOR

		bsr	main_menu

		SEEK_XY	10,11
		lea	STR_PASSES, a0
		RSUB	print_string

		STALL

	section data

STR_PASSES:	STRING "PASSES"
