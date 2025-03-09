	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/dsub.inc"

	include "error_codes.inc"
	include "machine.inc"

	global auto_work_ram_tests_dsub

	section code

auto_work_ram_tests_dsub:

		ld	hl, WORK_RAM_START
		PSUB	memory_output_test
		jr	z, .test_passed_output
		ld	a, EC_WORK_RAM_OUTPUT
		jp	error_address

	.test_passed_output:
		ld	hl, WORK_RAM_START
		PSUB	memory_write_test
		jr	z, .test_passed_write
		ld	a, EC_WORK_RAM_WRITE
		jp	error_address

	.test_passed_write:
		ld	hl, WORK_RAM_START
		ld	de, WORK_RAM_SIZE
		ld	c, $00
		PSUB	memory_data_pattern_test
		jr	nz, .test_failed_data

		ld	hl, WORK_RAM_START
		ld	de, WORK_RAM_SIZE
		ld	c, $55
		PSUB	memory_data_pattern_test
		jr	nz, .test_failed_data

		ld	hl, WORK_RAM_START
		ld	de, WORK_RAM_SIZE
		ld	c, $aa
		PSUB	memory_data_pattern_test
		jr	nz, .test_failed_data

		ld	hl, WORK_RAM_START
		ld	de, WORK_RAM_SIZE
		ld	c, $ff
		PSUB	memory_data_pattern_test
		jr	nz, .test_failed_data

		ld	hl, WORK_RAM_START
		ld	b, WORK_RAM_ADDRESS_LINES
		PSUB	memory_address_test
		jr	z, .test_passed_address
		ld	a, EC_WORK_RAM_ADDRESS
		jp	error_address

	.test_passed_address:
		ld	hl, WORK_RAM_START
		ld	de, WORK_RAM_SIZE
		PSUB	memory_march_test
		jr	z, .test_passed_march
		ld	a, EC_WORK_RAM_MARCH
		jp	error_address

	.test_passed_march:
		DSUB_RETURN

	.test_failed_data:
		ld	a, EC_WORK_RAM_DATA
		jp	error_address
