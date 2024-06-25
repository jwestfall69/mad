	include "cpu/z80/include/psub.inc"

	global unexpected_irq_test

	section code

; If nothing is configured for generating interrupts
; we shouldn't be getting any
; Your irq handler should define (bss) and set IRQ_SEEN to non-zero
unexpected_irq_test:
		xor	a
		ld	(IRQ_SEEN), a

		ei

		ld	bc, $ffff
		PSUB	delay

		di

		ld	a, (IRQ_SEEN)

		jr	nz, .test_failed
		xor	a
		ret

	.test_failed:
		xor	a
		inc	a
		ret
