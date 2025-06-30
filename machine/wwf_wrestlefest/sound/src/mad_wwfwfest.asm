	include "cpu/z80/include/common.inc"

	global _start

	section code

_start:
		di
		im 1

		DSUB_MODE_PSUB

		PSUB	mad_rom_crc32_test
		jr	nz, .test_failed

		PSUB	mad_rom_address_test
		jr	nz, .test_failed

		PSUB	auto_work_ram_tests

		DSUB_MODE_RSUB

		call	mcpu_latch_tests
		call	msm6295_tests
		call	ym2151_tests

		ld	a, EC_ALL_TESTS_PASSED

	.test_failed:
		jp	error_address
