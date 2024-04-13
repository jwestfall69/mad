	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global _start
	global vblank_interrupt
	global STR_PASSES

	section code

vblank_interrupt:
		rte

_start:
		PSUB_INIT

		move.b  #$80, $800030
		move.b  #$0, $800030
		move.b  #$f0, $800181

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
