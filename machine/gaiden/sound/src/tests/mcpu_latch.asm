	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/psub.inc"

	include "error_codes.inc"
	include "machine.inc"

	global mcpu_latch_tests
	section code

mcpu_latch_tests:

		ld	hl, REG_MCPU_LATCH
		PSUB	memory_output_test
		jr	z, .test_passed_output
		ld	a, EC_MCPU_LATCH_OUTPUT
		jp	error_address

	.test_passed_output:
		ret
