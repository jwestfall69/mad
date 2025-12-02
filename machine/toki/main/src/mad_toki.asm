	include "cpu/68000/include/common.inc"

	global _start

	section code

_start:
		INTS_DISABLE


		move.l	#$fffff, d0
	.loop_delay:
		dbra	d0, .loop_delay

		move.w	#$0008, $a0000
		move.w	#$0030, $a000a
		move.w	#$0300, $a000c
		move.w	#$00b9, $a000e

		move.w	#$0008, $a0010
		move.w	#$0028, $a0018
		move.w	#$00ef, $a001a
		move.w	#$fe60, $a001c
		move.w	#$00ae, $a001e

		move.w	#$0008, $a0020
		move.w	#$0010, $a002a
		move.w	#$0140, $a002c
		move.w	#$00b9, $a002e

		move.w	#$0008, $a0030
		move.w	#$0028, $a0038
		move.w	#$00ff, $a003a
		move.w	#$ff70, $a003c
		move.w	#$00ae, $a003e

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
