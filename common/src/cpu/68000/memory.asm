	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"
	include "cpu/68000/ssa3.inc"

	global memory_address_test_dsub
	global memory_data_test_dsub
	global memory_fill_dsub
	global memory_fill_list_dsub
        global memory_fill_long_dsub
	global memory_output_test_dsub
	global memory_rewrite_word_dsub
	global memory_write_test_dsub

	section code
; Write an incrementing value at each address line, then
; read them back checking for any differences
; params:
;  a0 = start address
;  d0 = address lines to test
; returns
;  d0 = 0 (pass), 1 (fail)
;  a0 = fail address
;  d1 = expected value
;  d2 = actual value
memory_address_test_dsub:

		move.l	a0, a1
		move.l	d0, d4

		moveq	#0, d1		; value we are writing
		moveq	#1, d3		; offset from address start

	.loop_write_next_address:
		add.w	#$101, d1
		move.w	d1, (a0)
		lsl.l	#1, d3
		move.l	a1, a0
		add.l	d3, a0
		dbra	d0, .loop_write_next_address


		move.l	a1, a0
		move.l	d4, d0

		moveq	#0, d1
		moveq	#1, d3

	.loop_read_next_address:
		add.w	#$101, d1
		move.w	(a0), d2
		cmp.w	d1, d2
		bne	.test_failed

		lsl.l	#1, d3
		move.l	a1, a0
		add.l	d3, a0
		dbra	d0, .loop_read_next_address

		moveq	#0, d0
		DSUB_RETURN

	.test_failed:
		moveq	#1, d0
		DSUB_RETURN

; params:
;  a0 = start address
;  d0 = length in bytes
; returns:
;  d0 = 0 (pass), 1 (lower bad), 2 (upper bad), 3 (both bad)
;  a0 = failed address
;  d1 = expected value
;  d2 = actual value
memory_data_test_dsub:

		; adjust length since we are writing in words
		ror.l	#1, d0
		subq.w	#1, d0

		lea	DATA_PATTERNS, a1
		moveq	#(((DATA_PATTERNS_END - DATA_PATTERNS) / 2) - 1), d3

		; backup params
		move.l	d0, d4
		movea.l	a0, a2

	.loop_next_pattern:
		movea.l	a2, a0
		move.l	d4, d0

		move.w	(a1)+, d1

	.loop_next_address:
		move.w	d1, (a0)
		move.w	(a0)+, d2
		cmp.w	d1, d2
		dbne	d0, .loop_next_address
		bne	.test_failed
		dbne	d3, .loop_next_pattern

		moveq	#0, d0
		DSUB_RETURN

	.test_failed:
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

; params:
;  a0 = start address
;  d0 = number of words
;  d1 = value
memory_fill_dsub:
		subq.w	#1, d0
	.loop_next_address:
		move.w	d1, (a0)+
		dbra	d0, .loop_next_address
		DSUB_RETURN

; params:
;  a0 = start of list of MEMORY_FILL_ENTRY's
memory_fill_list_dsub:
		move.l	a0, a1

	.loop_next_entry:
		move.l	(a1)+, a0
		cmp.l	#0, a0
		beq	.fills_done

		move.w	(a1)+, d0		; size
		move.w	(a1)+, d1		; value to write

		subq.w	#1, d0
	.loop_next_address:
		move.w	d1, (a0)+
		dbra	d0, .loop_next_address
		bra	.loop_next_entry

	.fills_done:

		DSUB_RETURN

; params:
;  a0 = start address
;  d0 = number of words
;  d1 = value
memory_fill_long_dsub:
		subq.w	#1, d0
	.loop_next_address:
		move.l	d1, (a0)+
		dbra	d0, .loop_next_address
		DSUB_RETURN

; Tests both lower and upper bytes for each output
; params:
;  a0 = address
; return:
;  d0 = 0 (pass), 1 (lower bad), 2 (upper bad), 3 (both bad)
memory_output_test_dsub:
		moveq	#0, d4		; return value

		moveq	#0, d0
		SSA3	memory_output_byte_test
		tst.b	d0
		beq	.test_lower
		moveq	#2, d4

	.test_lower:
		moveq	#1, d0
		SSA3	memory_output_byte_test
		tst.b	d0
		beq	.lower_passed
		or.b	#1, d4

	.lower_passed:
		move.b	d4, d0
		DSUB_RETURN

; writes a region of memory (mainly just used to force
; mame to consider the memorry dirty, causing it to update
; its state/redraw the screen)
; params:
;  a0 = start address
;  d0 = number of words
memory_rewrite_word_dsub:
		subq.w #1, d0
	.loop_next_address:
		move.w	(a0), d1
		move.w	d1, (a0)+
		dbra	d0, .loop_next_address
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
memory_output_byte_test_ssa3:
		adda.w  d0, a0
		moveq   #$31, d2

	.loop_test_again:
		move.b  (a0), d1
		cmp.b   *(PC,d0.w), d1
		bne     .check_passed

		move.b  (a0), d1
		nop
		cmp.b   *-2(PC,d0.w), d1
		bne     .check_passed

		move.b  (a0), d1
		add.w   #0, d0
		cmp.b   *-4(PC,d0.w), d1

	.check_passed:
		dbeq	d2, .loop_test_again
		beq	.test_failed
		moveq	#0, d0
		SSA3_RETURN

	.test_failed:
		moveq	#1, d0
		SSA3_RETURN


; params:
;  a0 = memory address
; returns:
;  d0 = 0 (pass), 1 (lower unwritable), 2 (upper unwritable), 3 (both unwritable)
; - reads a word value from the memory address
; - writes !value to memory address
; - re-reads memory address
; - compare re-read with original
memory_write_test_dsub:

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
		ror.l	#8, d1
		ror.l	#8, d2
		cmp.b	d1, d2
		bne	.check_done
		or.b	#2, d0

	.check_done:
		DSUB_RETURN


DATA_PATTERNS:
	dc.w	$0000, $5555, $aaaa, $ffff
DATA_PATTERNS_END:
