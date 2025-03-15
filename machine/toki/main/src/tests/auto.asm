	include "global/include/macros.inc"
	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/handlers/auto_test.inc"

	global d_auto_test_dsub_list
	global auto_func_tests

	section code

auto_func_tests:
		move.l	#d_auto_test_func_list, a0
		jsr	auto_test_func_handler
		rts

	section data
	align 1

d_auto_test_dsub_list:
	AUTO_TEST_ENTRY auto_mad_rom_address_test_dsub, d_str_testing_mad_rom_address
	AUTO_TEST_ENTRY auto_mad_rom_crc32_test_dsub, d_str_testing_mad_rom_crc32
	AUTO_TEST_ENTRY auto_ram_tests_dsub, d_str_testing_ram
	AUTO_TEST_LIST_END

d_auto_test_func_list:
;	AUTO_TEST_ENTRY auto_fg_ram_tests, d_str_testing_fg_ram
	AUTO_TEST_LIST_END

d_str_testing_mad_rom_address:	STRING "TESTING MAD ROM ADDRESS"
d_str_testing_mad_rom_crc32:	STRING "TESTING MAD ROM CRC32"
d_str_testing_ram:		STRING "TESTING RAM"
