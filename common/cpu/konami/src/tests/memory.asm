	include "cpu/konami/include/dsub.inc"
	include "cpu/konami/include/macros.inc"

	include "machine.inc"

	global memory_output_test_dsub

	section code

; This is testing for dead output from whatever
; is directly connected to the CPU when talking
; to the memory.  This maybe the memory itself
; or there could be some IC in between (ie 74LS245)
; Lack of output will usually result the register be
; filled with the contents of the ld's optarg.  So
; we loop $64 times trying to catch 2 different
; optargs being placed into 'a' in a row.
; params:
;  x = address
; returns:
;  a = 0 (pass), 1 (fail)
memory_output_test_dsub:
		tfr	x, y
		ldb	#$64

	.loop_next:
		lda	, x		; $1226
		cmpa	#$26
		bne	.loop_pass

		lda	, y		; $1236
		cmpa	#$36
		beq	.test_failed

	.loop_pass:
		decbjnz	.loop_next

		WATCHDOG
		clra
		DSUB_RETURN

	.test_failed:
		WATCHDOG
		lda	#$1
		DSUB_RETURN
