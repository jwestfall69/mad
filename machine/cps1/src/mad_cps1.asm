	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global _start
	global STR_PASSES

	section code

_start:
		PSUB_INIT

		; init the sound latch or random sounds
		; can play on powerup
		move.b	#$f0, REG_SOUND1

		move.w	#$ffc0, REGA_SCROLL1_X
		move.w	#$0, REGA_SCROLL1_Y

		PSUB	cps_a_init
		PSUB	screen_init

		PSUB	auto_dsub_tests

		RSUB_INIT
		bsr	auto_func_tests
		bsr	main_menu

		STALL

	section data

STR_PASSES:	STRING "PASSES"
