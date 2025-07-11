	include "cpu/68000/include/common.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		move.b	#$0, $30c011 	; tile/sprite priority
		move.b	#$3, $30c01f	; reset intel 8751?

		SOUND_STOP

		DSUB_MODE_PSUB
		PSUB	screen_init
		PSUB	auto_test_dsub_handler

		DSUB_MODE_RSUB
		bsr	auto_func_tests

		;moveq	#SOUND_NUM_SUCCESS, d0
		;SOUND_PLAY

		clr.b	r_menu_cursor
		bra	main_menu
