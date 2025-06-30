	include "cpu/68000/include/common.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		move.w	#$ffc0, REGA_SCROLL1_X
		move.w	#$0, REGA_SCROLL1_Y

		SOUND_STOP

		DSUB_MODE_PSUB
		PSUB	cps_a_init
		PSUB	screen_init_workaround
		PSUB	auto_test_dsub_handler

		DSUB_MODE_RSUB
		INTS_ENABLE
		bsr	auto_func_tests

		;moveq	#SOUND_NUM_SUCCESS, d0
		;SOUND_PLAY

		clr.b	r_menu_cursor
		bra	main_menu
