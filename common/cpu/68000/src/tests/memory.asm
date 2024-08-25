	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"

	global memory_address_test_dsub
	global memory_data_test_dsub
	global memory_march_test_dsub
	global memory_output_test_dsub
	global memory_output_list_test_dsub
	global memory_write_test_dsub
	global memory_write_list_test_dsub

	section code
; Write an incrementing value at each address line, then
; read them back checking for any differences
; params:
;  a0 = start address
;  d0 = address lines to test (word)
;  d1 = mask (word)
; returns
;  d0 = 0 (pass), 1 (fail)
;  a0 = fail address
;  d1 = expected value
;  d2 = actual value
memory_address_test_dsub:

		move.l	a0, a1
		sub.b	#1, d0		; adjust for loop
		move.w	d0, d4
		move.w	d1, d5

		moveq	#0, d1		; value we are writing
		moveq	#1, d3		; offset from address start

	.loop_write_next_address:
		add.w	#$101, d1
		and.w	d5, d1
		move.w	d1, (a0)
		lsl.l	#1, d3
		move.l	a1, a0
		add.l	d3, a0
		dbra	d0, .loop_write_next_address
		WATCHDOG

		move.l	a1, a0
		move.w	d4, d0

		moveq	#0, d1
		moveq	#1, d3

	.loop_read_next_address:
		add.w	#$101, d1
		and.w	d5, d1
		move.w	(a0), d2
		and.w	d5, d2
		cmp.w	d1, d2
		bne	.test_failed

		lsl.l	#1, d3
		move.l	a1, a0
		add.l	d3, a0
		dbra	d0, .loop_read_next_address
		WATCHDOG

		moveq	#0, d0
		DSUB_RETURN

	.test_failed:

		WATCHDOG

		moveq	#1, d0
		DSUB_RETURN

; params:
;  a0 = start address
;  d0 = length in bytes (long)
;  d1 = mask (word)
; returns:
;  d0 = 0 (pass), 1 (lower bad), 2 (upper bad), 3 (both bad)
;  a0 = failed address
;  d1 = expected value
;  d2 = actual value
memory_data_test_dsub:

		; adjust length since we are writing in words
		ror.l	#1, d0
		subq.l	#1, d0 		; make space for poisoning using the next word

		lea	DATA_PATTERNS, a1
		moveq	#(((DATA_PATTERNS_END - DATA_PATTERNS) / 2) - 1), d3

		; backup params
		move.l	d0, d4
		move.w	d1, d5
		movea.l	a0, a2

	.loop_next_pattern:

		movea.l	a2, a0
		move.l	d4, d0

		move.w	(a1)+, d1
		and.w	d5, d1

	.loop_next_write_address:
		move.w	d1, (a0)+
		subq.l	#1, d0
		bne	.loop_next_write_address
		WATCHDOG

		; In some cases when you write then re-read right away
		; you will just get back the last written data on the bus when
		; the ram chip or IC before it aren't working right.  To try
		; and avoid this situation we are writing out !pattern to
		; last word of the testing range.
		not.w	d1
		move.w	d1, (a0)
		not.w	d1

		; re-init for re-read
		movea.l	a2, a0
		move.l	d4, d0

	.loop_next_read_address:
		move.w	(a0)+, d2
		and.w	d5, d2
		cmp.w	d1, d2
		bne	.test_failed
		subq.l	#1, d0
		bne	.loop_next_read_address
		WATCHDOG

		dbra	d3, .loop_next_pattern

		; verify the poison looks good too
		move.w	(a0)+, d2
		and.w	d5, d2
		not.w	d1
		and.w	d5, d1
		cmp.w	d1, d2
		bne	.test_failed

		moveq	#0, d0
		DSUB_RETURN

	.test_failed:

		WATCHDOG

		subq.l	#2, a0

		moveq	#0, d0
		cmp.b	d1, d2
		beq	.check_upper
		moveq	#1, d0

	.check_upper:
		ror.l	#8, d1
		ror.l	#8, d2
		cmp.b	d1, d2
		beq	.check_done
		or.b	#2, d0

	.check_done:
		rol.l	#8, d1
		rol.l	#8, d2
		DSUB_RETURN

; Do a march test
; params:
;  a0 = start address
;  d0 = number of bytes (long)
;  d1 = mask (word)
memory_march_test_dsub:

		; adjust length since we are writing in words
		ror.l	#1, d0

		; backup params
		move.l	d0, d4
		move.w	d1, d5
		movea.l	a0, a2

		moveq	#0, d1
	.loop_fill_zero:
		move.w	d1, (a0)+
		subq.l	#1, d0
		bne	.loop_fill_zero
		WATCHDOG

		movea.l	a2, a0
		move.l	d4, d0

	.loop_up_test:
		move.w	(a0), d2
		and.w	d5, d2
		cmp.w	d1, d2
		bne	.test_failed
		move.w	#$ffff, (a0)+
		subq.l	#1, d0
		bne	.loop_up_test
		WATCHDOG

		suba.l	#2, a0
		move.l	d4, d0

		move.w	#$ffff, d1
		and.w	d5, d1
	.loop_down_test:
		move.w	(a0), d2
		and.w	d5, d2
		cmp.w	d1, d2
		bne	.test_failed
		move.w	#0, (a0)
		suba.l	#2, a0
		subq.l	#1, d0
		bne	.loop_down_test
		WATCHDOG

		moveq	#0, d0
		DSUB_RETURN

	.test_failed:

		WATCHDOG

		moveq	#0, d0
		cmp.b	d1, d2
		beq	.check_upper
		moveq	#1, d0

	.check_upper:
		ror.l	#8, d1
		ror.l	#8, d2
		cmp.b	d1, d2
		beq	.check_done
		or.b	#2, d0

	.check_done:
		rol.l	#8, d1
		rol.l	#8, d2
		DSUB_RETURN

; Tests both lower and upper bytes for each output
; params:
;  a0 = address
;  d0 = 0 test upper+low, !0 test lower only
; return:
;  d0 = 0 (pass), 1 (lower bad), 2 (upper bad), 3 (both bad)
memory_output_test_dsub:
		moveq	#0, d4		; return value

		tst.b	d0
		bne	.test_lower

		moveq	#0, d0
		DSUB	memory_output_byte_test
		tst.b	d0
		beq	.test_lower
		moveq	#2, d4

	.test_lower:
		moveq	#1, d0
		DSUB	memory_output_byte_test
		sub.l	#1, a0		; revert a0 back to what was passed in
		tst.b	d0
		beq	.lower_passed
		or.b	#1, d4

	.lower_passed:
		move.b	d4, d0
		DSUB_RETURN

; Tests both lower and upper bytes for each output
; params:
;  a0 = address list
;  d0 = 0 test upper+low, !0 test lower only
; return:
;  d0 = 0 (pass), 1 (lower bad), 2 (upper bad), 3 (both bad)
;  a0 = address (if failure)
; note: not able to call memory_output_test_dsub because we would
; nest to deep
memory_output_list_test_dsub:
		movea.l	a0, a1
		move.b	d0, d2

	.loop_next_address:

		moveq	#0, d4
		move.l	(a1)+, a0
		cmpa.l	#1, a0		; an address of 0x1 is our end of list
		beq	.tests_passed

		tst.b	d2
		bne	.test_lower

		moveq	#1, d0
		DSUB	memory_output_byte_test
		tst.b	d0
		beq	.test_lower
		moveq	#2, d4

	.test_lower:
		moveq	#1, d0
		DSUB	memory_output_byte_test
		sub.l	#1, a0		; revert a0 back to what was passed in
		tst.b	d0
		beq	.lower_passed
		or.b	#1, d4

	.lower_passed:
		move.b	d4, d0
		tst.b	d0
		beq	.loop_next_address
		DSUB_RETURN

	.tests_passed:
		DSUB_RETURN

; Attempts to read from the memory location.  If the chip never
; gets enabled d1 will be filled with the next data on the data
; bus, which would be the next instruction because of prefetching.
; We do the move.b 3 times with 3 different instructions after it.
; If the data loaded into d1 is the next instruction for all of
; them it will trigger an error
; params:
;  a0 = address
;  d0 = 0 (upper chip) or 1 (lower chip)
; return:
;  d0 = $00 (pass) or 1 (fail)
memory_output_byte_test_dsub:
		adda.w	d0, a0
		moveq	#$31, d2

		WATCHDOG

	.loop_test_again:
		move.b	(a0), d1
		cmp.b	*(PC,d0.w), d1
		bne	.check_passed

		move.b	(a0), d1
		nop
		cmp.b	*-2(PC,d0.w), d1
		bne	.check_passed

		move.b	(a0), d1
		add.w	#0, d0
		cmp.b	*-4(PC,d0.w), d1

	.check_passed:
		dbeq	d2, .loop_test_again
		beq	.test_failed
		moveq	#0, d0
		DSUB_RETURN

	.test_failed:
		moveq	#1, d0
		DSUB_RETURN


; params:
;  a0 = memory address
;  d0 = 0 test upper+low, !0 test lower only
; returns:
;  d0 = 0 (pass), 1 (lower unwritable), 2 (upper unwritable), 3 (both unwritable)
; - reads a word value from the memory address
; - writes !value to memory address
; - re-reads memory address
; - compare re-read with original
memory_write_test_dsub:

		WATCHDOG

		move.b	d0, d3
		move.w	(a0), d1
		move.w	d1, d2
		not.w	d1

		move.w	d1, (a0)
		move.w	(a0), d1

		moveq	#0, d0
		cmp.b	d1, d2
		bne	.check_upper
		moveq	#1, d0

	.check_upper:
		tst.b	d3
		bne	.check_done

		ror.l	#8, d1
		ror.l	#8, d2
		cmp.b	d1, d2
		bne	.check_done
		or.b	#2, d0

	.check_done:
		DSUB_RETURN

; params:
;  a0 = address list
;  d0 = 0 test upper+low, !0 test lower only
; returns:
;  d0 = 0 (pass), 1 (lower unwritable), 2 (upper unwritable), 3 (both unwritable)
;  a0 = address (if failure)
; - reads a word value from the memory address
; - writes !value to memory address
; - re-reads memory address
; - compare re-read with original
memory_write_list_test_dsub:
		movea.l	a0, a1
		move.w	d0, d4

	.loop_next_address:
		move.l	(a1)+, a0
		cmpa.l	#1, a0		; an address of 0x1 is our end of list
		beq	.tests_passed

		move.w	d4, d0
		DSUB	memory_write_test
		tst.b	d0
		beq	.loop_next_address
		DSUB_RETURN

	.tests_passed:
		DSUB_RETURN


DATA_PATTERNS:
	dc.w	$0000, $5555, $aaaa, $ffff
DATA_PATTERNS_END:
