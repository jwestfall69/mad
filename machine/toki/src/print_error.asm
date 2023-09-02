	include "cpu/68000/dsub.inc"
	include "cpu/68000/macros.inc"

	include "diag_rom.inc"
	include "machine.inc"

	global print_error_memory_override_dsub

	section code

; params:
;  d0 = error code
;  d1 = expected value
;  d2 = actual value
;  a0 = address
;  a1 = error description
; need to fix up screen ram before we call the real
; print function.
print_error_memory_override_dsub:
		move.l	a0, d0

		lea	NOT_WORK_RAM_START, a0
	.loop_next_address:
		move.w	#0, (a0)+
		cmp.l	#(NOT_WORK_RAM_START + NOT_WORK_RAM_SIZE), a0
		bne	.loop_next_address

		move.l	d0, a0
		bra	print_error_string_dsub
