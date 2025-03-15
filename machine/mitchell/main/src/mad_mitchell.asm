	include "global/include/macros.inc"
	include "cpu/z80/include/dsub.inc"
	include "cpu/z80/include/macros.inc"

	include "machine.inc"
	include "error_codes.inc"

	global _start

	section code

_start:
		di
		im 1

		ld a, $0
		out (IO_ROM_BANK), a

		DSUB_MODE_PSUB

		PSUB	screen_init

		PSUB	mad_rom_crc32_test
		PSUB	mad_rom_address_test
		PSUB	auto_work_ram_tests

		DSUB_MODE_RSUB

		call	auto_func_tests

		jp	main_menu
