	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/psub.inc"

	include "error_codes.inc"
	include "machine.inc"

	global ym2203_tests
	section code

; timesold has the RD pin of the ym2203 tied to VCC, which disables
; being able to do reads from it.  It does have its irq line wired
; to the z80 (but mame doesn't), which at least allows us to setup
; timers to verify the ym2203 is alive.
ym2203_tests:
	ifdef _MAME_BUILD_
		ret
	endif
		call	unexpected_irq_test
		jr	z, .test_passed_unexpected_irq
		ld	a, EC_YM2203_UNEXPECTED_IRQ
		jp	error_address

	.test_passed_unexpected_irq:
		ld	a, $1f		; upper 8 bits of timer data
		call	ym2203_timera_irq_test
		jr	z, .test_passed_timera_irq
		ld	a, EC_YM2203_TIMERA_IRQ
		jp	error_address

	.test_passed_timera_irq:
		ld	a, $1f
		call	ym2203_timerb_irq_test
		jr	z, .test_passed_timerb_irq
		ld	a, EC_YM2203_TIMERB_IRQ
		jp	error_address

	.test_passed_timerb_irq:
		ret
