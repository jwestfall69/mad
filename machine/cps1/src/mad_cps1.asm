	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global _start

	section code

_start:

		move.w	#$ffc0, REGA_SCROLL1_X
		move.w	#$0, REGA_SCROLL1_Y

		SOUND_STOP

		PSUB_INIT
		PSUB	cps_a_init
		PSUB	screen_init
		PSUB	auto_dsub_tests

		RSUB_INIT
		bsr	auto_func_tests

		;moveq	#SOUND_NUM_SUCCESS, d0
		;SOUND_PLAY

		clr.b	INPUT_P1_EDGE
		clr.b	INPUT_P1_RAW
		clr.b	INPUT_SYSTEM_EDGE
		clr.b	INPUT_SYSTEM_RAW
		clr.b	MENU_CURSOR
		bra	main_menu
