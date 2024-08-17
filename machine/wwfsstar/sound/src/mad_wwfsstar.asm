	include "cpu/z80/include/error_codes.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/psub.inc"

	include "machine.inc"

	global	_start

	section code

_start:
		di
		im 1


		PSUB	mad_rom_crc32_test
		jr	nz, .test_failed

		PSUB	mad_rom_address_test
		jr	nz, .test_failed

		PSUB	ram_tests

		ld	sp, RAM_START + RAM_SIZE - 2

		call	msm6295_tests
		call	ym2151_tests

		ld	a, EC_ALL_TESTS_PASSED

	.test_failed:
		jp	error_address
