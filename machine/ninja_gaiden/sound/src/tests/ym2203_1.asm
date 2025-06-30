	include "cpu/z80/include/common.inc"

	global ym2203_1_tests
	section code

ym2203_1_tests:

		ld	hl, REG_YM2203_1_DATA
		RSUB	memory_output_test
		jr	z, .test_passed_output
		ld	a, EC_YM2203_1_OUTPUT
		jp	error_address

	; z80's irq line is hooked up to the ym2203. Since
	; we haven't configured the timer yet we shouldn't
	; be getting any irqs
	.test_passed_output:
		call	unexpected_irq_test
		jr	z, .test_passed_unexpected_irq
		ld	a, EC_YM2203_1_UNEXPECTED_IRQ
		jp	error_address

	.test_passed_unexpected_irq:
		; ym2203 tests won't modify these, so we only
		; need to set once
		ld	hl, REG_YM2203_1_DATA
		ld	de, REG_YM2203_1_ADDRESS

		call	ym2203_busy_bit_test
		jr	z, .test_passed_busy_bit
		ld	a, EC_YM2203_1_BUSY_BIT
		jp	error_address

	.test_passed_busy_bit:
		ld	a, $1f			; upper 8 bits of timer data
		call	ym2203_timera_irq_test
		jr	z, .test_passed_timera_irq
		ld	a, EC_YM2203_1_TIMERA_IRQ
		jp	error_address

	.test_passed_timera_irq:
		ld	a, $1f
		call	ym2203_timerb_irq_test
		jr	z, .test_passed_timerb_irq
		ld	a, EC_YM2203_1_TIMERB_IRQ
		jp	error_address

	.test_passed_timerb_irq:
		ret
