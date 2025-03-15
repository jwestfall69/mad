	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"
	include "mad.inc"

	global _start

	section code

_start:
		INTS_DISABLE

		; high bit flips the screen, not sure what the others
		; are but the screen doesnt seem to render at all without
		; them
		move.w	#$c0f0, MMIO_SCREEN_FLIP

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
