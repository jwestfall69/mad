	include "cpu/68000/include/common.inc"
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
	AUTO_TEST_ENTRY auto_work_ram_tests_dsub, d_str_testing_work_ram
	AUTO_TEST_LIST_END

d_auto_test_func_list:
	AUTO_TEST_ENTRY auto_palette_ram_tests, d_str_testing_palette_ram
	AUTO_TEST_ENTRY auto_sprite_ram_tests, d_str_testing_sprite_ram
	AUTO_TEST_ENTRY auto_tile_ram_tests, d_str_testing_tile_ram
	AUTO_TEST_ENTRY auto_tile_attr_ram_tests, d_str_testing_tile_attr_ram
	AUTO_TEST_ENTRY auto_tile_ext_ram_tests, d_str_testing_tile_ext_ram
	AUTO_TEST_LIST_END

d_str_testing_mad_rom_address:	STRING "TESTING MAD ROM ADDRESS"
d_str_testing_mad_rom_crc32:	STRING "TESTING MAD ROM CRC32"
d_str_testing_palette_ram:	STRING "TESTING PALETTE RAM"
d_str_testing_sprite_ram:	STRING "TESTING SPRITE RAM"
d_str_testing_tile_ram:		STRING "TESTING TILE RAM"
d_str_testing_tile_attr_ram:	STRING "TESTING TILE ATTR RAM"
d_str_testing_tile_ext_ram:	STRING "TESTING TILE EXT RAM"
d_str_testing_work_ram:		STRING "TESTING WORK RAM"
