	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/psub.inc"

	include "error_codes.inc"
	include "machine.inc"

	global ym2203_2_tests
	section code

	; This 2nd ym2203 doesn't have its irq line wired to the z80.
	; TODO? maybe we should do a poll test on the timers just to
	; verify this ym2203 is working ok?

ym2203_2_tests:

		ld	hl, REG_YM2203_2_DATA
		PSUB	memory_output_test
		jr	z, .test_passed_output
		ld	a, EC_YM2203_2_OUTPUT
		jp	error_address

	.test_passed_output:
		ld	hl, REG_YM2203_2_DATA
		;ld	de, REG_YM2203_2_ADDRESS

		call	ym2203_busy_bit_test
		jr	z, .test_passed_busy_bit
		ld	a, EC_YM2203_2_BUSY_BIT
		jp	error_address

	.test_passed_busy_bit:
		ret
