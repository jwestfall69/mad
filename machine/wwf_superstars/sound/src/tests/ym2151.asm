	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/dsub.inc"

	include "error_codes.inc"
	include "machine.inc"

	global ym2151_tests
	section code

ym2151_tests:

		ld	hl, REG_YM2151_DATA
		RSUB	memory_output_test
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
		; ym2151 tests won't modify these, so we only
		; need to set once
		ld	hl, REG_YM2151_DATA
		ld	de, REG_YM2151_ADDRESS

		call	ym2151_busy_bit_test
		jr	z, .test_passed_busy_bit
		ld	a, EC_YM2151_BUSY_BIT
		jp	error_address

	.test_passed_busy_bit:
		ld	a, $1f			; upper 8 bits of timer data
		call	ym2151_timera_irq_test
		jr	z, .test_passed_timera_irq
		ld	a, EC_YM2151_TIMERA_IRQ
		jp	error_address

	.test_passed_timera_irq:
		ld	a, $1f
		call	ym2151_timerb_irq_test
		jr	z, .test_passed_timerb_irq
		ld	a, EC_YM2151_TIMERB_IRQ
		jp	error_address

	.test_passed_timerb_irq:
		ret
