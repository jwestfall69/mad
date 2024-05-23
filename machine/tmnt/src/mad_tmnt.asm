	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global _start

	section code

_start:
		WATCHDOG
		SOUND_STOP

		move.b #$13, $10e801
		move.b #0, $a0001 	; coin
		move.b #$10, $140000	; k051960
		move.b #$0, $106402
		move.b #$0, $106400
		move.b #$0, $106403
		move.b #$0, $106401
		move.b #$0, $106018
		move.b #$0, $106019


		move.b #$18, $140000
		move.b #$0, $106d00

		PSUB_INIT
		PSUB	screen_init
		PSUB	auto_dsub_tests

		RSUB_INIT
		bsr	auto_func_tests

		move.b	#SOUND_NUM_SUCCESS, d0
		SOUND_PLAY

		clr.b	INPUT_P1_EDGE
		clr.b	INPUT_P1_RAW
		clr.b	INPUT_SYSTEM_EDGE
		clr.b	INPUT_SYSTEM_RAW
		clr.b	MENU_CURSOR
		bra	main_menu
