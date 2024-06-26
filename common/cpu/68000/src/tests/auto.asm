	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"

	global auto_dsub_tests_dsub
	global auto_func_tests

	section code

auto_dsub_tests_dsub:
		moveq	#0, d6		; index within the struct

	.loop_next_test:
		; doing it this way because the only thing that we
		; know will presist across test functions is d6
		lea	AUTO_DSUB_LIST + 4, a0		; string offset
		move.l	(a0, d6), a0			; jump to index in the table

		cmp.l	#0, a0				; table is null terminated
		beq	.all_tests_done

		SEEK_LN	5
		DSUB	print_clear_line

		SEEK_XY	4,5
		DSUB	print_string

		lea	AUTO_DSUB_LIST, a2		; test dsub offset
		move.l	(a2, d6), a2			; jump to index in the table

		; this is manually setting up a dsub call and return point
		lea	(.test_return), a3
		bra	dsub_enter
	.test_return:

		tst.b	d0
		bne	.test_failed

		addq.w	#8, d6
		bra	.loop_next_test

	.test_failed:
		DSUB	error_handler
		STALL

	.all_tests_done:
		DSUB_RETURN

auto_func_tests:
		lea	(AUTO_FUNC_LIST), a1

	.loop_next_test:
		tst.l	(a1)			; table is null terminated
		beq	.all_tests_done

		SEEK_LN	5
		RSUB	print_clear_line

		move.l (4, a1), a0
		SEEK_XY	4,5
		RSUB	print_string

		move.l	(a1), a0		; test function

		movem.l a1, -(a7)
		jsr	(a0)
		movem.l (a7)+, a1

		tst.b	d0
		bne	.test_failed

		; re-init the screen since the test may have
		; screwed it up
		movem.l a1, -(a7)
		RSUB	screen_init
		movem.l	(a7)+, a1

		addq.l	#8, a1
		bra	.loop_next_test

	.test_failed:
		RSUB	error_handler
		STALL

	.all_tests_done:
		rts
