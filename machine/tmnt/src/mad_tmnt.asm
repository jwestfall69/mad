	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global _start
	global	STR_PASSES

	section code

_start:

		move.w	#$2700, sr
		WATCHDOG
		PSUB_INIT

		move.b #$13, $10e801
		move.b #0, $a0001 ; coin
		move.b #$10, $140000 ; k051960
		move.b #$0, $106402
		move.b #$0, $106400
		move.b #$0, $106403
		move.b #$0, $106401
		move.b #$0, $106018
		move.b #$0, $106019


		move.b #$18, $140000
		move.b #$0, $106d00

		PSUB	screen_init
		PSUB	auto_dsub_tests

		WATCHDOG

		RSUB_INIT

		jsr	auto_func_tests
		clr.b	INPUT_P1_EDGE
		clr.b	INPUT_P1_RAW
		clr.b	INPUT_SYSTEM_EDGE
		clr.b	INPUT_SYSTEM_RAW
		clr.b	MENU_CURSOR

		lea	WORK_RAM_START+$100, a0
		move.w	#$ff, d0
	.loop:
		move.b	d0, (a0)+
		dbra	d0, .loop

		move.b	#SOUND_NUM_SUCCESS, d0
		SOUND_PLAY

		bsr	main_menu

	section data

STR_PASSES:	STRING "PASSES"
