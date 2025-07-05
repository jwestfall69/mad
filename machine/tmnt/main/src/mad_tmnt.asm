	include "cpu/68000/include/common.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		WATCHDOG
		SOUND_STOP

		move.b	#$13, $10e801
		move.b	#0, $a0001	; coin
		move.b	#$0, $106402
		move.b	#$0, $106400
		move.b	#$0, $106403
		move.b	#$0, $106401
		move.b	#$0, $106018
		move.b	#$0, $106019


		move.b	#$0, $140000
		move.b	#$0, $140001
		move.b	#$0, $140002
		move.b	#$0, $140003
		move.b	#$0, $106d00

		DSUB_MODE_PSUB
		PSUB	screen_init
		PSUB	auto_test_dsub_handler

		DSUB_MODE_RSUB
		bsr	auto_func_tests

		move.b	#SOUND_NUM_SUCCESS, d0
		SOUND_PLAY

		clr.b	r_menu_cursor
		bra	main_menu
