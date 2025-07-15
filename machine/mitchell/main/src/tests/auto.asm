	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/auto_test.inc"

	global auto_func_tests

	section code

auto_func_tests:
		ld	ix, d_auto_test_func_list
		call	auto_test_func_handler
		ret

	section data

d_auto_test_func_list:
	AUTO_TEST_ENTRY auto_sprite_ram_tests, d_str_testing_sprite_ram
	AUTO_TEST_ENTRY auto_tile_ram_tests, d_str_testing_tile_ram
	AUTO_TEST_ENTRY auto_tile_attr_ram_tests, d_str_testing_tile_attr_ram
	AUTO_TEST_LIST_END

d_str_testing_sprite_ram:		STRING "TESTING SPRITE RAM"
d_str_testing_tile_ram:			STRING "TESTING TILE RAM"
d_str_testing_tile_attr_ram:		STRING "TESTING TILE ATTR RAM"
