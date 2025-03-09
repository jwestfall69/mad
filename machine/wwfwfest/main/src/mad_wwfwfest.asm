	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		; one of these causes the sync
		; signal to start
		move.w #$0081, $100008
		move.w #$0050, $10000c
		move.w #$00ab, $140006
		move.w #$00f7, $140012
		move.w #$0001, $140014

		SOUND_STOP

		DSUB_MODE_PSUB
		PSUB	screen_init
		PSUB	auto_dsub_tests

		DSUB_MODE_RSUB
		bsr	auto_func_tests

		moveq	#SOUND_NUM_SUCCESS, d0
		SOUND_PLAY

		clr.b	r_menu_cursor
		bra	main_menu
