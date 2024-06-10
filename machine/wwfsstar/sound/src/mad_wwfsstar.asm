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

		STALL

	.test_failed:
		jp	error_address
