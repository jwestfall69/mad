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
	AUTO_TEST_ENTRY auto_bg_tile_ram_tests, d_str_testing_bg_tile_ram
	AUTO_TEST_ENTRY auto_fg_tile_ram_tests, d_str_testing_fg_tile_ram
	AUTO_TEST_ENTRY auto_fix_tile_ram_tests, d_str_testing_fix_tile_ram
	AUTO_TEST_ENTRY auto_palette_ram_tests, d_str_testing_palette_ram
	AUTO_TEST_ENTRY auto_sprite_ram_tests, d_str_testing_sprite_ram
	AUTO_TEST_LIST_END

d_str_testing_bg_tile_ram:			STRING "TESTING BG TILE RAM"
d_str_testing_fg_tile_ram:			STRING "TESTING FG TILE RAM"
d_str_testing_fix_tile_ram:			STRING "TESTING FIX TILE RAM"
d_str_testing_palette_ram:			STRING "TESTING PALETTE RAM"
d_str_testing_sprite_ram:			STRING "TESTING SPRITE RAM"
