	include "cpu/z80/include/error_codes.inc"
	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/dsub.inc"

	include "machine.inc"

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

		; need to see what a busted iorq latch looks like
		;call	mcpu_latch_tests

		call	ym2203_tests
		; board also has a ym2413, but there
		; is no way to read data from it

		; todo: nmi test.  nmi's get enabled/disabled
		; via porta on the ym2203 (default is disabled)
		; https://github.com/mamedev/mame/blob/0bd289b75898e69ec7f8684f34f811e95ee272f3/src/mame/alpha/alpha68k.cpp#L1174

		ld	a, EC_ALL_TESTS_PASSED

	.test_failed:
		jp	error_address
