	include "cpu/z80/include/error_codes.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/psub.inc"

	global	_start

	section code

_start:
		di
		im 1


		PSUB	auto_mad_rom_crc32_test
		jr	nz, .test_failed

		PSUB	auto_mad_rom_address_test
		jr	nz, .test_failed

		STALL

	.test_failed:
		jp	error_address
