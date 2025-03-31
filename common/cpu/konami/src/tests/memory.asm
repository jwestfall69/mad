	include "cpu/konami/include/macros.inc"
	include "cpu/konami/include/psub.inc"

	include "machine.inc"

	global memory_output_test_psub

	section code

; This is testing for dead output from whatever
; is directly connected to the CPU when talking
; to the memory.  This maybe the memory itself
; or there could be some IC in between (ie 74LS245)
; params:
;  x = address
; returns:
;  a = 0 (pass), 1 (fail)
memory_output_test_psub:
		; the konami does dummy memory reads of 0xffff
		; when its doesnt need to access the address bus.
		; because of this, reads of memory locations with
		; no/dead output will cause the register to be filled
		; with the lower byte of the reset function's address
		; from the vector table.  This is why we have a special
		; RESET section in the linker as it gives us control
		; of what that last byte will be (0x5a)

		lda	$ffff
		ldb	#$7f
	.loop_next_address:
		cmpa	, x
		bne	.test_passed

		decb
		bne	.loop_next_address
		WATCHDOG

		lda	#$1
		PSUB_RETURN

	.test_passed:
		WATCHDOG
		clra
		PSUB_RETURN
