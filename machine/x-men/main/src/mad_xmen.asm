	include "cpu/68000/include/common.inc"

	global _start

	section code

_start:
		CPU_INTS_DISABLE

		WATCHDOG

		; allow some time for custom ICs to get started up
		; before we try to adjust their registers.  This
		; fixes issues with sprite ICs not working right.
		move.w	#$ffff, d0
	.startup_delay:
		tst.b	d0
		dbra	d0, .startup_delay

		move.b	#$50, $18f801
		moveq	#$0, d0
		move.b	d0, $18fa01
		move.b	d0, $108001
		move.b	d0, $108000
		move.b	d0, $108025
		move.b	d0, $18f901
		move.b	d0, $18fc01
		move.b	d0, $18f403
		move.b	d0, $18f401
		move.b	d0, $193403
		move.b	d0, $193401
		move.b	d0, $18f019
		move.b	d0, $193019

		move.b	#$18, $108073
		move.b	#$3e, $108075

		move.b	d0, $108077
		move.b	#$7, $108079
		move.b	#$2, $108063
		move.b	#$0, $108067
		move.b	#$5, $108061
		move.b	#$9, $108065
		move.b	#$fe, $108069
		move.b	#$6, $18fd01

		move.b	#$0, $10804d
		move.b	#$0, $10804f
		move.b	#$4, $108000
		nop
		nop
		move.b	#$0, $108000

		; enable sprite rendering/dma
		move.b	#$10, $108025

		move.w	#$3c6, $108020
		move.w	#$292, $108022

		move.b	#$fe, $10804d
		move.b	#$0, $10804f
		move.b	#$4, $108000
		nop
		nop
		move.b	#$0, $108000

		move.b	#$0, $108043

		; reset volume
		move.b	#$0, $108045

		DSUB_MODE_PSUB

		moveq	#$33, d1
	.volume_up:
		move.b	#$1, $108047

		; game code normally loops waiting for the
		; 054321 to be ready before continuing to
		; the the next volume up.  We don't want
		; to get stuck on that if its bad, so just
		; delaying for a bit and hope thats good
		; enough
		move.l	#$1ff, d0
		PSUB	delay
		dbra	d1, .volume_up

		move.b	#$3, $108041
		move.b	#$4a, $108049

		PSUB	screen_init
		PSUB	auto_test_dsub_handler

		DSUB_MODE_RSUB

		bsr	auto_func_tests

		move.w	#SOUND_NUM_SUCCESS, d0
		SOUND_PLAY

		clr.b	r_menu_cursor
		bra	main_menu
