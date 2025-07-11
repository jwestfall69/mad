	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/auto_test.inc"

	global auto_test_dsub_handler_dsub
	global auto_test_func_handler

	section code
; params:
;  none, d_auto_test_dsub_list must be a global
auto_test_dsub_handler_dsub:
		moveq	#0, d6		; index within the struct

	.loop_next_test:
		; doing it this way because the only thing that we
		; know will presist across test functions is d6
		lea	d_auto_test_dsub_list + s_at_name_ptr, a0	; string offset
		move.l	(a0, d6), a0				; jump to index in the table

		cmp.l	#0, a0					; table is null terminated
		beq	.all_tests_done

		SEEK_XY	0, SCREEN_START_Y
		DSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		DSUB	print_string

		lea	d_auto_test_dsub_list, a2	; test dsub offset
		move.l	(a2, d6), a2			; jump to index in the table

		; this is manually setting up a dsub call and return point
		lea	(.test_return), a3
		bra	dsub_enter
	.test_return:

		tst.b	d0
		bne	.test_failed

		addq.w	#s_at_struct_size, d6
		bra	.loop_next_test

	.test_failed:
		DSUB	error_handler
		STALL

	.all_tests_done:
		DSUB_RETURN

; params
;  a0 = auto test list
auto_test_func_handler:
		move.l	a0, a1

	.loop_next_test:
		tst.l	(a1)			; table is null terminated
		beq	.all_tests_done

		SEEK_XY	0, SCREEN_START_Y
		RSUB	print_clear_line

		SEEK_XY	SCREEN_START_X, SCREEN_START_Y
		move.l	s_at_name_ptr(a1), a0
		RSUB	print_string

		move.l	(a1), a0		; test function

		movem.l a1, -(a7)
		jsr	s_at_function_ptr(a0)
		movem.l (a7)+, a1

		tst.b	d0
		bne	.test_failed

		; re-init the screen since the test may have
		; screwed it up
		movem.l a1, -(a7)
		RSUB	screen_init
		movem.l	(a7)+, a1

		addq.l	#s_at_struct_size, a1
		bra	.loop_next_test

	.test_failed:
		RSUB	error_handler
		STALL

	.all_tests_done:
		rts
