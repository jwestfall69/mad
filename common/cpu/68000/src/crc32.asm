	include "cpu/68000/include/dsub.inc"

	include "machine.inc"

	global crc32_dsub

	section code

; calculate the crc32 value
; params:
;  d0 = length
;  a0 = start address
; returns:
;  d0 = crc value
crc32_dsub:
		subq.l	#1, d0
		move.w	d0, d3
		swap	d0
		move.w	d0, d4
		move.l	#$edb88320, d5			; P
		moveq	#-1, d0
	.loop_outer:
		WATCHDOG
		moveq	#7, d2
		move.b	(a0)+, d1
		eor.b	d1, d0
	.loop_inner:
		lsr.l	#1, d0
		bcc	.no_carry
		eor.l	d5, d0
	.no_carry:
		dbra	d2, .loop_inner
		dbra	d3, .loop_outer
		dbra	d4, .loop_outer
		not.l	d0
		DSUB_RETURN
