	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		move.b	#$0, $30c011 	; tile/sprite priority
		move.b	#$3, $30c01f	; reset intel 8751?

		SOUND_STOP

		PSUB_INIT
		PSUB	screen_init
		PSUB	auto_dsub_tests

		RSUB_INIT
		bsr	auto_func_tests

		;moveq	#SOUND_NUM_SUCCESS, d0
		;SOUND_PLAY

		clr.b	MENU_CURSOR
		bra	main_menu
