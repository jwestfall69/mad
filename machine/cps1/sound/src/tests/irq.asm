
	include "error_codes.inc"

	global irq_tests

	section code

irq_tests:

		call	unexpected_irq_test
		jr	nz, .test_failed
		xor	a
		ret

	.test_failed:
		ld	a, EC_UNEXPECTED_IRQ
		jp	error_address
