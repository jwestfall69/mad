	include "cpu/z80/include/common.inc"

	global mcpu_latch_tests
	section code

mcpu_latch_tests:

		ld	hl, REG_MCPU_LATCH
		RSUB	memory_output_test
		jr	z, .test_passed_output
		ld	a, EC_MCPU_LATCH_OUTPUT
		jp	error_address

	.test_passed_output:
		ret
