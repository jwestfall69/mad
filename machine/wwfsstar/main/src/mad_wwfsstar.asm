	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad_rom.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		SOUND_STOP

		move.w	#$0, REG_SCROLL_X
		move.w	#$0, REG_SCROLL_Y

		PSUB_INIT
		PSUB	screen_init
		PSUB	auto_dsub_tests

		RSUB_INIT
		bsr	auto_func_tests

		moveq	#SOUND_NUM_SUCCESS, d0
		SOUND_PLAY

		clr.b	r_menu_cursor
		bra	main_menu

