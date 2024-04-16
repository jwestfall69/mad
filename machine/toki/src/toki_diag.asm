	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global _start
	global	vblank_interrupt
	global	STR_PASSES

	section code

_start:
		PSUB_INIT
		PSUB	screen_init

		; high bit flips the screen, not sure what the others
		; are but the screen doesnt seem to render at all without
		; them
		move.w	#$c0f0, MMIO_SCREEN_FLIP

		PSUB	auto_dsub_tests

		RSUB_INIT
		ENABLE_INTS

		RSUB	screen_init
		bsr	auto_func_tests
		bsr	main_menu
		STALL

	section data

STR_PASSES:	STRING "PASSES"
