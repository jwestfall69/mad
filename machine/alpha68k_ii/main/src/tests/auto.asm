	include "cpu/68000/include/macros.inc"
	include "cpu/68000/include/tests/auto.inc"

	global d_auto_dsub_list
	global d_auto_func_list

	section data
	align 2

d_auto_dsub_list:
	AUTO_ENTRY auto_mad_rom_address_test_dsub, d_str_testing_mad_rom_address
	AUTO_ENTRY auto_mad_rom_crc32_test_dsub, d_str_testing_mad_rom_crc32
	AUTO_ENTRY auto_work_ram_tests_dsub, d_str_testing_work_ram
	AUTO_LIST_END

d_auto_func_list:
	AUTO_ENTRY auto_palette_ram_tests, d_str_testing_palette_ram
	AUTO_ENTRY auto_sprite_ram_tests, d_str_testing_sprite_ram
	AUTO_ENTRY auto_tile_ram_tests, d_str_testing_tile_ram
	AUTO_LIST_END

d_str_testing_mad_rom_address:		STRING "TESTING MAD ROM ADDRESS"
d_str_testing_mad_rom_crc32:		STRING "TESTING MAD ROM CRC32"
d_str_testing_palette_ram:		STRING "TESTING PALETTE RAM"
d_str_testing_sprite_ram:		STRING "TESTING SPRITE RAM"
d_str_testing_tile_ram:			STRING "TESTING TILE RAM"
d_str_testing_work_ram:			STRING "TESTING WORK RAM"