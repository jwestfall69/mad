	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global _start

	section code

_start:

		SOUND_STOP

		PSUB_INIT
		PSUB	screen_init
		;PSUB	auto_dsub_tests

		RSUB_INIT
		;bsr	auto_func_tests

		move.w	#SOUND_NUM_SUCCESS, d0
		SOUND_PLAY

	.loop:

		bsr	main_menu

		lea	TXT_RAM_START, a0
		move.l	#TXT_RAM_SIZE, d0
		RSUB	memory_rewrite

		WATCHDOG
		lea	PALETTE_RAM_START, a0
		move.l	#PALETTE_RAM_SIZE, d0
		RSUB	memory_rewrite
		WATCHDOG

		bra	.loop
		;clr.b	MENU_CURSOR
		;bra	main_menu
		STALL

