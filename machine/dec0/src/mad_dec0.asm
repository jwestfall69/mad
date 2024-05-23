	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global _start

	section code

_start:
		move.b	#$0, $30c011 	; tile/sprite priority
		move.b	#$3, $30c01f	; reset intel 8751?

		SOUND_STOP

		PSUB_INIT
		PSUB	screen_init

		PSUB	auto_dsub_tests

		RSUB_INIT

		jsr	auto_func_tests

		clr.b	INPUT_P1_EDGE
		clr.b	INPUT_P1_RAW
		clr.b	INPUT_SYSTEM_EDGE
		clr.b	INPUT_SYSTEM_RAW
		clr.b	MENU_CURSOR

		bsr	main_menu
		STALL
