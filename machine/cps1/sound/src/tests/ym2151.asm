	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/psub.inc"

	include "error_codes.inc"
	include "machine.inc"

	global ym2151_tests
	section code

ym2151_tests:

		ld	hl, REG_YM2151_DATA
		PSUB	memory_output_test
		jr	z, .test_passed_output
		ld	a, EC_YM2151_OUTPUT
		jp	error_address

	; z80's irq line is hooked up to the ym2151. Since
	; we haven't configured the timer yet we shouldn't
	; be getting any irqs
	.test_passed_output:
		call	unexpected_irq_test
		jr	z, .test_passed_unexpected_irq
		ld	a, EC_YM2151_UNEXPECTED_IRQ
		jp	error_address

	.test_passed_unexpected_irq:
		ld	hl, REG_YM2151_DATA
		call	ym2151_busy_bit_test
		jr	z, .test_passed_busy_bit
		ld	a, EC_YM2151_BUSY_BIT
		jp	error_address

	.test_passed_busy_bit:
		ret
