	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"

	global memory_fill_dsub
	global memory_fill_list_dsub
	global memory_fill_long_dsub

	section code

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
		move.w	(a1)+, d0		; size

		cmp.w	#0, d0
		beq	.fills_done

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
