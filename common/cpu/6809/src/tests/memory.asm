	include "cpu/6809/include/common.inc"

	global memory_output_test_dsub

	section code

; This is testing for dead output from whatever
; is directly connected to the CPU when talking
; to the memory.  This maybe the memory itself
; or there could be some IC in between (ie 74LS245)
; When the memory location has dead output the
; 6809 will fill the destination register with
; the first byte of the next instruction.
; params:
;  x = address
; returns:
;  a = 0 (pass), 1 (fail)
memory_output_test_dsub:
		ldb	#$64

	.loop_next:
		lda	, x
		cmpa	#$81		; $8181
		bne	.loop_pass

		lda	, x
		nop			; $12
		cmpa	#$12
		beq	.test_failed

	.loop_pass:
		decb
		bne	.loop_next
		WATCHDOG
		clra
		DSUB_RETURN

	.test_failed:
		lda	#$1
		WATCHDOG
