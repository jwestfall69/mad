	include "cpu/68000/include/common.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		SOUND_STOP

		move.w	#$0, REG_SCROLL_X
		move.w	#$0, REG_SCROLL_Y

		DSUB_MODE_PSUB
		PSUB	screen_init
		PSUB	auto_test_dsub_handler

		DSUB_MODE_RSUB
		bsr	auto_func_tests

		moveq	#SOUND_NUM_SUCCESS, d0
		SOUND_PLAY

		clr.b	r_menu_cursor
		bra	main_menu

