	include "cpu/6809/include/error_codes.inc"
	include "cpu/6809/include/macros.inc"
	include "cpu/6809/include/psub.inc"

	include "machine.inc"
	include "mad.inc"

	global _start

	section code

_start:

		PSUB	mad_rom_address_test
		PSUB	mad_rom_crc16_test

		PSUB	work_ram_output_test
		PSUB	work_ram_write_test
		PSUB	work_ram_data_test
		PSUB	work_ram_address_test
		PSUB	work_ram_march_test

		lds	#(WORK_RAM_START + WORK_RAM_SIZE)

		jsr	ym2151_tests

		lda	#EC_ALL_TESTS_PASSED
		jmp	error_address
