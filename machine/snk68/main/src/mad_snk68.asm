	include "cpu/68000/include/common.inc"

	global _start

	section code

_start:
		CPU_INTS_DISABLE

		DELAY	#$ffff

		move.b	#SOUND_NUM_STOP, REG_SOUND
		DELAY	#$fff
		move.b	#SOUND_NUM_STOP, REG_SOUND
		DELAY	#$fff
		move.b	#SOUND_NUM_START, REG_SOUND
		DELAY	#$fff
		move.b	#SOUND_NUM_START, REG_SOUND

		DSUB_MODE_PSUB

		PSUB	screen_init

		PSUB	auto_test_dsub_handler

		DSUB_MODE_RSUB
		bsr	auto_func_tests

		moveq	#SOUND_NUM_SUCCESS, d0
		SOUND_PLAY

		clr.b	r_menu_cursor
		bra	main_menu
