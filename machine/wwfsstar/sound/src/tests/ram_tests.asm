	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/psub.inc"

	include "error_codes.inc"
	include "machine.inc"

	global ram_tests_psub

	section code

ram_tests_psub:

		ld	hl, RAM_START
		PSUB	memory_output_test
		jr	z, .test_passed_output
		ld	a, EC_RAM_OUTPUT
		jp	error_address

	.test_passed_output:
		ld	hl, RAM_START
		PSUB	memory_write_test
		jr	z, .test_passed_write
		ld	a, EC_RAM_WRITE
		jp	error_address

	.test_passed_write:
		ld	hl, RAM_START
		ld	de, RAM_SIZE
		ld	c, $00
		PSUB	memory_data_pattern_test
		jr	nz, .test_failed_data

		ld	hl, RAM_START
		ld	de, RAM_SIZE
		ld	c, $55
		PSUB	memory_data_pattern_test
		jr	nz, .test_failed_data

		ld	hl, RAM_START
		ld	de, RAM_SIZE
		ld	c, $aa
		PSUB	memory_data_pattern_test
		jr	nz, .test_failed_data

		ld	hl, RAM_START
		ld	de, RAM_SIZE
		ld	c, $ff
		PSUB	memory_data_pattern_test
		jr	nz, .test_failed_data

		ld	hl, RAM_START
		ld	b, RAM_ADDRESS_LINES
		PSUB	memory_address_test
		jr	z, .test_passed_address
		ld	a, EC_RAM_ADDRESS
		jp	error_address

	.test_passed_address:
		ld	hl, RAM_START
		ld	de, RAM_SIZE
		PSUB	memory_march_test
		jr	z, .test_passed_march
		ld	a, EC_RAM_MARCH
		jp	error_address

	.test_passed_march:
		PSUB_RETURN

	.test_failed_data:
		ld	a, EC_RAM_DATA
		jp	error_address
