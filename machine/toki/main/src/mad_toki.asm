	include "cpu/68000/include/common.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		move.l	#$fffff, d0
	.loop_delay:
		dbra	d0, .loop_delay

		moveq	#$0, d0
		move.w	D0, $a0000.l
		move.w	D0, $a0010.l
		move.w	D0, $a0020.l
		move.w	D0, $a0030.l
		move.w	#$28, D0
		move.w	#$b9, D1
		move.w	#$28, D2
		move.w	#$ae, D3
		move.w	#$1c, D4
		move.w	D0, $a000c.l
		move.w	D1, $a000e.l
		move.w	D2, $a001c.l
		move.w	D3, $a001e.l
		move.w	D0, $a002c.l
		move.w	D1, $a002e.l
		move.w	D2, $a003c.l
		move.w	D3, $a003e.l

		; high bit flips the screen, not sure what the others
		; are but the screen doesnt seem to render at all without
		; them
		move.w	#$c0f0, REG_SCREEN_FLIP

		SOUND_STOP

		DSUB_MODE_PSUB

		PSUB	screen_init
		PSUB	auto_test_dsub_handler

		DSUB_MODE_RSUB

		; enabling ints so are vblank handler can deal with triggering
		; a screen update during the vblank.  If we do it manually
		; during screen draw it will cause random pixel corruption.
		INTS_ENABLE

		bsr	auto_func_tests

		move.w	#SOUND_NUM_SUCCESS, d0
		SOUND_PLAY

		clr.b	r_menu_cursor
		bra	main_menu
