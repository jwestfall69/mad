	include "cpu/z80/include/dsub.inc"

	global unexpected_irq_test

	section code

; If nothing is configured for generating interrupts
; we shouldn't be getting any
; Your irq handler should define (bss) and set r_irq_seen to non-zero
unexpected_irq_test:
		xor	a
		ld	(r_irq_seen), a

		ei

		ld	bc, $ffff
		RSUB	delay

		di

		ld	a, (r_irq_seen)

		jr	nz, .test_failed
		xor	a
		ret

	.test_failed:
		xor	a
		inc	a
		ret
