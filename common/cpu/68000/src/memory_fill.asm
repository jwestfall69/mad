	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "machine.inc"

	global memory_fill_dsub
	global memory_fill_list_dsub

	section code

; params:
;  a0 = start address
;  d0 = number of bytes (long)
;  d1 = value (word)
memory_fill_dsub:
		lsr.l	#1, d0	; convert to words
	.loop_next_address:
		WATCHDOG
		move.w	d1, (a0)+
		subq.l	#1, d0
		bne	.loop_next_address
		DSUB_RETURN

; params:
;  a0 = start of list of MEMORY_FILL_ENTRY's
memory_fill_list_dsub:
		move.l	a0, a1

	.loop_next_entry:
		move.l	(a1)+, a0
		move.l	(a1)+, d0		; size in bytes

		cmp.l	#0, d0
		beq	.fills_done

		move.w	(a1)+, d1		; value to write

		lsr.l	#1, d0
	.loop_next_address:
		move.w	d1, (a0)+
		subq.l	#1, d0
		bne	.loop_next_address
		bra	.loop_next_entry

	.fills_done:
		DSUB_RETURN
