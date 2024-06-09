	include "cpu/z80/include/error_codes.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/psub.inc"

	global	_start

	section code

_start:
		di
		im 1

		ld	a, EC_ALL_TESTS_PASSED
		jp	error_address
		PSUB	auto_mad_rom_crc32_test

		STALL

