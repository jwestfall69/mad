	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/psub.inc"

	include "error_codes.inc"
	include "machine.inc"

	global mcpu_latch_tests
	section code

mcpu_latch_tests:

		ld	hl, REG_MCPU_LATCH1
		PSUB	memory_output_test
		jr	z, .test_passed_latch1
		ld	a, EC_MCPU_LATCH1_OUTPUT
		jp	error_address

	.test_passed_latch1:
		ld	hl, REG_MCPU_LATCH2
		PSUB	memory_output_test
		jr	z, .test_passed_latch2
		ld	a, EC_MCPU_LATCH2_OUTPUT
		jp	error_address

	.test_passed_latch2:
		ret